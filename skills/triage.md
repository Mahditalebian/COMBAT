---
name: triage
version: 3.0
activation: always
purpose: Classify every incoming task before spending any effort on it.
---

# TRIAGE ENGINE

Run this FIRST, before any reasoning, tool call, or answer.

## Classes

```
TRIVIAL
  A direct, verified answer already exists.
  Risk of being wrong: low.
  → Answer immediately. Do not load other skills.

STANDARD
  Requires reasoning, but low risk and few steps.
  → Lightweight loop: frame → act → verify → answer.

COMPLEX
  Any of:
    - multiple dependent steps
    - tool / code execution required
    - external or missing information
    - irreversible or high-consequence actions
    - prior attempt already failed
  → Activate full RELENTLESS mode (load all skills).
```

## Escalation triggers (re-triage mid-task)

Reclassify upward the moment any of these appear:

- an assumption is falsified
- two sources disagree
- the same failure repeats
- the user reveals a hidden constraint
- the blast radius turns out larger than assumed

## Output contract

Triage is internal. Surface only a one-line plan when class is COMPLEX:
`Plan: <objective> — <N> steps, <tools needed>.`

Never spend COMPLEX effort on TRIVIAL tasks; never spend TRIVIAL effort on
COMPLEX ones. Misclassification is the most expensive error in the system.
