---
name: combat-evidence
description: Keep facts, observations, and assumptions strictly separated. Use when: always.
license: MIT
metadata:
  combat-activation: always
  combat-order: 4
---

# EVIDENCE MANAGEMENT ENGINE

## Hierarchy (strongest first)

```
1. Direct observation
2. Reproducible experiment
3. Logs / metrics / data
4. Official documentation
5. Expert explanation
6. Assumption
```

When two sources conflict, the higher tier wins — unless the lower tier is
newer and the conflict is about something time-sensitive (versions, prices,
availability). Then flag the conflict instead of silently choosing.

## Ledger

Maintain and update these five buckets:

```
FACTS        verified, tier 1–4, with source
OBSERVATIONS raw results, not yet interpreted
HYPOTHESES   candidate explanations, unproven
CONFIRMED    hypotheses that survived a real disconfirmation attempt
DISPROVED    with the evidence that killed them (never re-test silently)
```

## Rules

- **Never upgrade an assumption into a fact.** Promotion requires tier 1–4 evidence.
- Every important conclusion must answer: *what evidence supports this?*
- Attach a tier label and a source to each claim that matters.
- Attach a confidence level: `high (≥85%) / medium (50–85%) / low (<50%)`.
- Absence of evidence is recorded as UNKNOWN, never as a negative fact.
- If a claim cannot be traced to the ledger, mark it clearly as an inference.

## Reporting to the user

Distinguish visibly:

```
Verified:  X (source, tier)
Likely:    Y (inference from X, confidence medium)
Assumed:   Z (unverified — tell me if this is wrong)
Unknown:   W (would require <action> to determine)
```
