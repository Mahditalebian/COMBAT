/**
 * COMBAT plugin for OpenCode.
 *
 * Dual-compatible with OpenCode V1 and V2, with no external dependencies.
 *
 *   V1 (opencode 1.x): discovered via the named export `CombatPlugin`.
 *     Registers skills by pushing the package's skills directory into
 *     `config.skills.paths` from the `config` hook, so no symlink or manual
 *     config edit is required.
 *
 *   V2 (opencode 2.x): loaded via the default export `{ id, setup }`.
 *     Registers each skill natively through `ctx.skill.transform(draft => ...)`.
 *
 * Also injects a compact kernel (combat-core) into the first user message of
 * each top-level session, so triage happens before the agent starts guessing.
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const SKILLS_DIR = path.resolve(__dirname, '../../skills');
const MARKER = 'COMBAT_OPERATING_CORE';

/* ------------------------------------------------------------------ utils */

// Minimal frontmatter reader. Not a full YAML parser: it handles `key: value`,
// surrounding quotes, and indented continuation lines, which covers the
// name/description fields consumed here. Nested maps flatten harmlessly.
function parseFrontmatter(raw) {
  const m = raw.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?([\s\S]*)$/);
  if (!m) return { frontmatter: {}, content: raw };
  const out = {};
  let lastKey = null;
  for (const rawLine of m[1].split('\n')) {
    const line = rawLine.replace(/\r$/, '');
    const i = line.indexOf(':');
    if (i > 0 && !/^\s/.test(line)) {
      const k = line.slice(0, i).trim();
      const v = line.slice(i + 1).trim();
      out[k] = /^(>[+-]?|\|[+-]?)$/.test(v) ? '' : v;
      lastKey = k;
    } else if (lastKey && line.trim() !== '') {
      out[lastKey] = `${out[lastKey]} ${line.trim()}`.trim();
    }
  }
  for (const k of Object.keys(out)) {
    out[k] = out[k].replace(/^(["'])([\s\S]*)\1$/, '$2');
  }
  return { frontmatter: out, content: m[2] };
}

function readSkills() {
  const skills = [];
  if (!fs.existsSync(SKILLS_DIR)) return skills;
  for (const entry of fs.readdirSync(SKILLS_DIR, { withFileTypes: true })) {
    if (!entry.isDirectory() || entry.name.startsWith('.')) continue;
    const file = path.join(SKILLS_DIR, entry.name, 'SKILL.md');
    if (!fs.existsSync(file)) continue;
    const { frontmatter, content } = parseFrontmatter(fs.readFileSync(file, 'utf8'));
    skills.push({
      id: entry.name,
      name: frontmatter.name || entry.name,
      ...(frontmatter.description ? { description: frontmatter.description } : {}),
      // Skill.Info renamed `location` -> `path` in OpenCode 2.0.4.
      path: file,
      location: file,
      content,
    });
  }
  return skills;
}

let bootstrapCache = null;
function bootstrap() {
  if (bootstrapCache !== null) return bootstrapCache;
  const core = path.join(SKILLS_DIR, 'combat-core', 'SKILL.md');
  if (!fs.existsSync(core)) return (bootstrapCache = '');
  const { content } = parseFrontmatter(fs.readFileSync(core, 'utf8'));
  const ids = readSkills().map((s) => s.id).filter((id) => id !== 'combat-core');
  bootstrapCache = [
    `<${MARKER}>`,
    content.trim(),
    '',
    'Load these skills with the `skill` tool when their trigger fires:',
    ids.map((id) => `- ${id}`).join('\n'),
    '',
    'Triage first. Do not spend COMPLEX effort on a TRIVIAL task.',
    `</${MARKER}>`,
  ].join('\n');
  return bootstrapCache;
}

async function isChildSession(get, id) {
  try {
    const res = await get(id);
    const info = res?.data ?? res;
    return Boolean(info?.parentID);
  } catch {
    return false;
  }
}

/* ------------------------------------------------------------- V1 (1.x) */

export const CombatPlugin = async ({ client }) => ({
  config: async (config) => {
    // V2 exposes `skills` as a flat array; setup() handles that case.
    if (Array.isArray(config.skills)) return;
    config.skills = config.skills || {};
    config.skills.paths = config.skills.paths || [];
    if (!config.skills.paths.includes(SKILLS_DIR)) config.skills.paths.push(SKILLS_DIR);
  },

  'experimental.chat.messages.transform': async (_input, output) => {
    const text = bootstrap();
    if (!text || !output?.messages?.length) return;
    const first = output.messages.find((m) => m.info?.role === 'user');
    if (!first?.parts?.length) return;
    if (first.parts.some((p) => p.type === 'text' && p.text?.includes(MARKER))) return;
    if (client && (await isChildSession((id) => client.session.get({ path: { id } }), first.info.sessionID))) return;
    first.parts.unshift({ ...first.parts[0], type: 'text', text });
  },
});

/* ------------------------------------------------------------- V2 (2.x) */

async function setup(ctx) {
  // V1 also calls default.setup, but with a ctx lacking these domains.
  if (!ctx?.skill?.transform || typeof ctx.skill.transform !== 'function') return;

  try {
    const skills = readSkills();
    await ctx.skill.transform((draft) => {
      // draft.add() validates against the host schema and throws synchronously.
      // An escaping throw hard-disables the whole plugin, so contain per skill.
      for (const s of skills) {
        try {
          draft.add(s);
        } catch (err) {
          console.error(`[combat] skill "${s.id}" rejected by host, skipping:`, err);
        }
      }
    });
  } catch (err) {
    console.error('[combat] skill registration failed:', err);
  }

  if (!ctx.session?.hook) return;
  try {
    await ctx.session.hook('context', async (event) => {
      try {
        const text = bootstrap();
        if (!text || !event?.messages?.length) return;
        const first = event.messages.find((m) => m.role === 'user');
        if (first?.content?.some((p) => p.type === 'text' && p.text?.includes(MARKER))) return;
        if (typeof ctx.session.get === 'function' &&
            (await isChildSession((id) => ctx.session.get({ sessionID: id }), event.sessionID))) return;
        if (first?.content) first.content.unshift({ type: 'text', text });
        else event.messages.push({ role: 'user', content: [{ type: 'text', text }] });
      } catch (err) {
        console.error('[combat] bootstrap injection failed:', err);
      }
    });
  } catch (err) {
    console.error('[combat] session hook failed:', err);
  }
}

/* --------------------------------------------------------- default export */

// OpenCode V1 scans module exports and calls each one as
// `Plugin = (input) => Promise<Hooks>`. A plain object default export makes the
// host reject the whole module, so the default export must be the V1 function
// itself. V2 only reads the `id` and `setup` properties off the default export,
// and a function carries properties fine — so one value satisfies both hosts.
const plugin = CombatPlugin;
plugin.id = 'combat';
plugin.setup = setup;

export default plugin;
