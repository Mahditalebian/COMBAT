# COMBAT

**Universal agent operating core.** A plugin of 10 composable skills that turn
an agent from a fast answerer into a disciplined problem solver.

Most agent prompts tell the model *what* to be ("be thorough", "be careful").
COMBAT specifies *how* to proceed: classify the task, model the system, rank
falsifiable hypotheses, separate facts from assumptions, research properly,
prove success before claiming it, gate irreversible actions, stop honestly.

## Install

| Harness | Command | Status |
|---|---|---|
| **Claude Code** | `/plugin marketplace add Mahditalebian/COMBAT` → `/plugin install combat@combat` | ✅ verified v2.1.197 |
| **Codex CLI** | `codex plugin marketplace add Mahditalebian/COMBAT` → `codex plugin add combat@combat` | ✅ verified v0.156.1 |
| **OpenCode** | `"plugin": ["combat-core@git+https://github.com/Mahditalebian/COMBAT.git"]` in `opencode.json` | ✅ verified v1.18.32 |
| **Gemini CLI** | `gemini extensions install https://github.com/Mahditalebian/COMBAT.git` | ✅ verified v0.61.0 |
| **Qwen Code** | `qwen extensions install https://github.com/Mahditalebian/COMBAT:combat` | ✅ verified v0.15.10 |
| Cursor | `install.sh cursor` → `.cursor/rules/*.mdc` | file layout |
| Codebuff / Freebuff | `install.sh freebuff` → `.agents/skills/` + `knowledge.md` | file layout |
| Windsurf | `install.sh windsurf` → `.windsurf/rules/` | file layout |
| GitHub Copilot | `install.sh copilot` → `.github/copilot-instructions.md` | file layout |
| Anything else | `install.sh agents-md` → portable `AGENTS.md` | file layout |

"✅ verified" means the harness's own CLI was installed and the install was
executed end to end, then the loaded skills were listed back. "file layout"
means the files are written to the paths that harness documents, without an
end-to-end run.

Gemini CLI can also take the skills alone, without the extension:

```bash
gemini skills install https://github.com/Mahditalebian/COMBAT.git --path skills
```

Check any installation:

```bash
curl -fsSL https://raw.githubusercontent.com/Mahditalebian/COMBAT/main/verify.sh | bash
```

## Install as a plugin

```
/plugin marketplace add Mahditalebian/COMBAT
/plugin install combat@combat
```

Then use `/combat:combat <task>` to engage the full loop, or let the agent
load individual skills on demand. Plugin components are namespaced with the
plugin name.

Verified against Claude Code v2.1.197: `claude plugin validate` passes and
`/plugin install combat@combat` reports `Status: enabled` with all 10 skills
and 2 commands loaded.

Plugin manifests ship for Claude Code (`.claude-plugin/`), Codex
(`.codex-plugin/`), Cursor (`.cursor-plugin/`), OpenCode (`.opencode-plugin/`)
and the shared `.agents/plugins/` marketplace surface.

## Install without a plugin system

```bash
curl -fsSL https://raw.githubusercontent.com/Mahditalebian/COMBAT/main/install.sh | bash -s -- claude-code
```

| Target | Installs to |
|---|---|
| `claude-code` | `.claude/skills/<id>/SKILL.md` + `.claude/commands/` |
| `opencode` | `.opencode/skills/<id>/SKILL.md` + `AGENTS.md` |
| `codebuff` / `freebuff` | `.agents/skills/<id>/SKILL.md` + `knowledge.md` |
| `cursor` | `.cursor/rules/*.mdc` |
| `codex` | `AGENTS.md` + `.combat/` |
| `windsurf` | `.windsurf/rules/` |
| `agents-md` | single portable `AGENTS.md` |
| `copilot` | `.github/copilot-instructions.md` |
| `plain` | `.combat/` |

Flags: `--dir PATH` · `--global` · `--dry-run`.

## Let an agent install it for itself

Paste the prompt in [`PROMPT.md`](PROMPT.md) into any agent and it will detect
your environment, install COMBAT the right way, and verify the result.

## The 10 skills

| Skill | Enforces |
|---|---|
| `combat-core` | always-on kernel: prime directives and the loop |
| `combat-triage` | TRIVIAL / STANDARD / COMPLEX before any effort is spent |
| `combat-reasoning` | task frame, causal system model, state update, output policy |
| `combat-hypothesis` | ranked falsifiable hypotheses, ≤2 attempts per strategy class |
| `combat-evidence` | 6-tier evidence hierarchy; assumptions never become facts |
| `combat-deep-search` | question decomposition, 8-step research, expansion ladder |
| `combat-web-intelligence` | API before scraping, structured extraction, validation |
| `combat-verification` | verification depth ∝ cost of being wrong |
| `combat-safety` | blast radius and rollback gate before irreversible actions |
| `combat-stop-policy` | stop conditions and an honest final report |

Only `combat-core` needs to be resident (~50 lines). The other ~600 lines load
on demand, so the framework costs almost nothing when the task is trivial.

## Commands

| Command | Does |
|---|---|
| `/combat <task>` | Runs the full loop on the task, loading skills as triggers fire |
| `/combat-status` | Prints current understanding, evidence ledger, eliminated possibilities, confidence, next action |

## The loop

```
TRIAGE → FRAME → MODEL → HYPOTHESIZE → RANK
→ SEARCH / EXTRACT (if needed) → SAFETY GATE → ACT → OBSERVE → VERIFY
→ success? yes: REPORT
          no:  LEARN → UPDATE STATE → CHANGE DIMENSION → REPEAT
```

## Layout

```
COMBAT/
├── .claude-plugin/     plugin.json + marketplace.json
├── .codex-plugin/      .cursor-plugin/  .opencode-plugin/
├── .agents/plugins/    shared marketplace surface
├── skills/<id>/SKILL.md   the 10 skills — single source of truth
├── commands/           /combat, /combat-status
└── install.sh          fallback installer for non-plugin harnesses
```

Edit `skills/` only. Everything else is generated or references it.

## License

MIT.
