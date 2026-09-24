# Install prompt

Paste this into any AI coding agent (Claude Code, OpenCode, Cursor, Codex,
Freebuff/Codebuff, Windsurf, Copilot…) to have it install COMBAT itself.

---

## Short version

> Find the official **COMBAT** agent skills by Mahditalebian at
> https://github.com/Mahditalebian/COMBAT and install them using the latest
> instructions for my current AI environment. After installing, use the COMBAT
> workflow for my tasks whenever applicable, whether they involve coding or not.

---

## Full version (more reliable)

> Install the **COMBAT** agent operating core from
> https://github.com/Mahditalebian/COMBAT.
>
> 1. First detect which AI environment you are running in (Claude Code,
>    OpenCode, Cursor, Codex, Codebuff/Freebuff, Windsurf, Copilot, or other).
> 2. Read the repository's README and follow the **latest** install
>    instructions for that specific environment — do not guess from memory.
>    - If my environment supports plugins, prefer the plugin route:
>      `/plugin marketplace add Mahditalebian/COMBAT` then
>      `/plugin install combat@combat`
>    - Otherwise run the installer with the matching target, for example:
>      `curl -fsSL https://raw.githubusercontent.com/Mahditalebian/COMBAT/main/install.sh | bash -s -- <target>`
>      where `<target>` is one of: claude-code, opencode, codebuff, freebuff,
>      cursor, codex, windsurf, agents-md, copilot, plain.
>    - Use `--global` if I want it available across all projects; otherwise
>      install into this project only.
> 3. Verify the install: list the skill files that were actually created and
>    confirm all 10 skills are present — combat-core, combat-triage,
>    combat-reasoning, combat-hypothesis, combat-evidence, combat-deep-search,
>    combat-web-intelligence, combat-verification, combat-safety,
>    combat-stop-policy. Report the real paths, not assumed ones.
> 4. Tell me whether I need to restart the session for the skills to load.
>
> From then on, apply the COMBAT workflow to my tasks whenever applicable —
> coding or not: triage the task first, frame the objective and success
> criteria, model the system, rank falsifiable hypotheses instead of guessing,
> keep facts separate from assumptions, research properly before answering from
> memory, verify before claiming success, pass the safety gate before anything
> irreversible, and stop with an honest report.
>
> Show me your work before any irreversible step, and ask me first if an
> ambiguity would change the solution direction.
