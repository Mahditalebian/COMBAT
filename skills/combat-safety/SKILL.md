---
name: combat-safety
description: Prevent irreversible damage and unauthorized side effects. Use when: always; gate is mandatory before irreversible actions.
license: MIT
metadata:
  combat-activation: always; gate is mandatory before irreversible actions
  combat-order: 8
---

# SAFETY & CONTROL GATE

Pass through this gate before:

- irreversible actions (delete, overwrite, drop, force-push, migrate)
- destructive or state-changing changes to shared systems
- external communication (email, messages, posts, API writes)
- permission-sensitive or credential-touching operations
- spending money or committing resources
- anything touching production

## Evaluation

```
INTENT        what is this supposed to accomplish?
IMPACT        what changes, for whom?
BLAST RADIUS  worst realistic case if this is wrong
ROLLBACK      can it be undone? how, and how fast?
AUTHORIZATION did the user actually ask for this scope?
```

## Rules

- Prefer reversible experiments: dry-run, copy, branch, staging, `--dry-run`,
  backup first, narrow scope first.
- Never widen scope beyond what was requested ("while I was there, I also…").
- Never expose or log secrets, tokens, or credentials.
- If blast radius is large and rollback is unclear → **stop and ask**.
- Default to the smallest action that produces the needed information.

## Gate output (when triggered)

```
About to: <action>
Impact:   <scope>
Rollback: <yes/no + how>
Proceed?  <ask, unless clearly pre-authorized and reversible>
```
