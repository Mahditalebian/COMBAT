# RELENTLESS v3 — Universal Agent Operating Core

A modular decision core for autonomous coding/research agents.
Not a prompt — an operating loop: **triage → frame → model → hypothesize →
act → verify → learn → stop**, with evidence discipline and a safety gate.

Agents perform better with small, conditionally-activated skills than with one
giant instruction file, so this ships as 10 independent skills plus installers
that compile them into whatever format your tool expects.

## Install

```bash
# in your project root
curl -fsSL https://raw.githubusercontent.com/Mahditalebian/rls-8ef9929b/main/install.sh | bash -s -- cursor
```

Or clone and run:

```bash
git clone https://github.com/Mahditalebian/rls-8ef9929b.git
cd your-project && /path/to/relentless/install.sh claude-code
```

| Target | Command | Installs to |
|---|---|---|
| Cursor | `install.sh cursor` | `.cursor/rules/relentless-*.mdc` |
| Claude Code | `install.sh claude-code` | `.claude/skills/relentless-*/SKILL.md` |
| Codex / generic | `install.sh codex` | `AGENTS.md` + `.relentless/` |
| Windsurf | `install.sh windsurf` | `.windsurf/rules/` |
| Any agent (portable) | `install.sh agents-md` | single `AGENTS.md` |
| GitHub Copilot | `install.sh copilot` | `.github/copilot-instructions.md` |
| Raw files | `install.sh plain` | `.relentless/` |

Flags: `--dir PATH` · `--global` (user-level, where supported) · `--dry-run`.

```bash
./install.sh claude-code --global      # install for all projects
./install.sh cursor --dry-run          # preview, write nothing
```

## What's inside

| Skill | Responsibility |
|---|---|
| `core` | always-on kernel: prime directives + the loop |
| `triage` | TRIVIAL / STANDARD / COMPLEX classification, escalation triggers |
| `reasoning` | task frame, causal system model, state update, output policy |
| `hypothesis` | ranked falsifiable hypotheses, experiment loop, failure analyzer, anti-loop |
| `evidence` | 6-tier evidence hierarchy, facts-vs-assumptions ledger |
| `deep-search` | question decomposition, 8-step research, search expansion ladder |
| `web-intelligence` | source preference (API → HTML), extraction pipeline, scraping ethics |
| `verification` | verification depth ∝ cost of being wrong |
| `safety` | blast radius / rollback gate before irreversible actions |
| `stop-policy` | stop conditions + honest final report format |

Loading strategy: TRIVIAL loads `core` + `triage`; STANDARD adds `reasoning`,
`evidence`, `verification`; COMPLEX loads everything. `safety` and
`stop-policy` are always in scope.

## Layout

```
relentless/
├── install.sh          multi-target installer
├── relentless.json     machine-readable manifest
├── skills/             the 10 source skills (single source of truth)
└── adapters/           notes for LangGraph / OpenAI Agents integration
```

Edit files in `skills/` only, then re-run the installer to recompile.

## Forking to your own account

```bash
gh repo fork Mahditalebian/rls-8ef9929b --clone
# then point REPO_RAW in install.sh at your fork
```

Pin a version instead of tracking `main`:

```bash
curl -fsSL https://raw.githubusercontent.com/Mahditalebian/rls-8ef9929b/v3.0.0/install.sh | bash -s -- cursor
```

## License

MIT.
