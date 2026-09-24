# COMBAT

**Universal agent operating core.** A plugin of 10 composable skills that turn
an agent from a fast answerer into a disciplined problem solver.

Most agent prompts tell the model *what* to be ("be thorough", "be careful").
COMBAT specifies *how* to proceed: classify the task, model the system, rank
falsifiable hypotheses, separate facts from assumptions, research properly,
prove success before claiming it, gate irreversible actions, stop honestly.

## Install as a plugin

```
/plugin marketplace add Mahditalebian/COMBAT
/plugin install combat@combat
```

Then use `/combat <task>` to engage the full loop, or let the agent load
individual skills on demand.

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
