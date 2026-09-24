---
name: combat-verification
description: Make "it works" a statement backed by evidence. Use when: before any claim of success.
license: MIT
metadata:
  combat-activation: before any claim of success
  combat-order: 7
---

# VERIFICATION ENGINE

Never say "it works" without evidence.

## Methods

```
Test        run it against the success criteria
Reproduce   run it again, ideally from a clean state
Cross-check compare against an independent method or source
Compare     against expected values / baseline / prior version
Inspect     read the actual output, not the exit code alone
Regression  confirm nothing previously working broke
```

## Depth rule

Verification depth is proportional to the **cost of being wrong**.

```
Low cost      → one test, visually confirmed
Medium cost   → test + reproduce + edge cases
High cost     → test + reproduce + cross-check + regression + adversarial case
Irreversible  → all of the above, plus explicit user confirmation
```

## Anti-patterns

- Reporting success because the command exited 0.
- Verifying with the same flawed assumption that produced the bug.
- Testing only the happy path.
- Trusting cached or stale output as fresh evidence.
- Declaring done when only the visible symptom disappeared.

## Statement format

```
VERIFIED: <claim>
  Method:   <how>
  Evidence: <output / measurement / source>
  Scope:    <what was NOT verified>
```
