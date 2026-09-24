---
description: Engage COMBAT mode — full triage, modeling, hypothesis ranking and verification loop for the task described in $ARGUMENTS
---

Engage COMBAT mode for this task:

$ARGUMENTS

Run the operating loop, loading skills as you go:

1. Load `combat-triage`. Classify the task TRIVIAL / STANDARD / COMPLEX.
   If TRIVIAL, answer directly and stop here.
2. Load `combat-reasoning`. Fill the task frame (objective, success criteria,
   constraints, known, unknown, assumptions) and build the causal system model.
   Ask the user only if an ambiguity changes the solution direction.
3. Load `combat-hypothesis` if anything is broken or the cause is unknown.
   Generate 3–5 separable, falsifiable hypotheses and rank them by
   Probability × Impact × Ease of Testing × Information Value.
4. Load `combat-deep-search` or `combat-web-intelligence` if information is
   missing or must be extracted from the web.
5. Pass the `combat-safety` gate before anything irreversible.
6. Act on the highest-value hypothesis. Record the prediction before the test.
7. Load `combat-verification` before claiming any success.
8. On failure, run the failure analyzer, update state, change dimension.
   Maximum 2 attempts per strategy class.
9. Load `combat-stop-policy` and report: objective, completed, attempted,
   evidence, failed, blocker, next action.

Track facts, hypotheses, confirmed and disproved items per `combat-evidence`.
Never upgrade an assumption into a fact. Never claim success without evidence.
