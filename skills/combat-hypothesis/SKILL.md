---
name: combat-hypothesis
description: Replace blind trial-and-error with ranked, information-maximizing tests. Use when: COMPLEX | any debugging or diagnosis task.
license: MIT
metadata:
  combat-activation: COMPLEX | any debugging or diagnosis task
  combat-order: 3
---

# HYPOTHESIS ENGINE

Never jump straight into execution. Generate explanations first.

## Generate

Aim for 3–5 mutually distinguishable hypotheses. Example — "system is slow":

```
H1: database bottleneck
H2: network latency
H3: memory leak
H4: external API delay
```

Weak hypothesis sets share the same root cause. Good sets are *separable*:
one test should kill at least one of them.

## Rank

```
Priority = Probability × Impact × Ease of Testing × Information Value
```

| ID | Hypothesis | P | Impact | Ease | Info | Score |
|----|------------|---|--------|------|------|-------|

Test the highest-scoring hypothesis first. Prefer tests that **bisect** the
space (eliminate ~half the candidates) over tests that confirm a favorite.

## Discipline

- A hypothesis must be falsifiable: state in advance what result would kill it.
- Record the prediction BEFORE running the test.
- A test whose outcome you cannot interpret is not a test — redesign it.
- Confirmation without an attempted disconfirmation is not confirmation.

# 8. EXPERIMENT LOOP

```
PLAN → ACT → OBSERVE → VERIFY → SUCCESS?
  YES → DONE
  NO  → FAILURE ANALYSIS → NEW STRATEGY → repeat
```

Maintain the attempt ledger:

| # | Hypothesis | Action | Expected | Actual | Learning | Next |
|---|------------|--------|----------|--------|----------|------|

# 9. FAILURE ANALYZER

After every failure answer, explicitly:

```
What assumption failed?
What did we learn?
What possibility disappeared?
What new possibility appeared?
What dimension should change?
```

If no learning happened, the attempt was badly designed — fix the design,
do not simply retry.

# 10. STRATEGY ESCALATION ENGINE

Do not increase effort blindly; change dimension.

```
hypothesis · tool · data · algorithm · environment · architecture
abstraction · decomposition · problem definition · resources
```

Hard cap: **2 attempts per strategy class**, then change dimension.

# 14. ANTI-LOOP PROTECTION

Detect: same action · same assumption · same failure.
Response: STOP. Change strategy or escalate to the user. Looping is not effort.
