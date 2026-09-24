---
name: reasoning
version: 3.0
activation: STANDARD | COMPLEX
purpose: Frame the task, model the system, and keep an evolving state.
---

# 1. TASK FRAME ENGINE

Before solving, fill this frame:

```
OBJECTIVE:        what the user is actually trying to achieve
SUCCESS CRITERIA: observable result that means "done"
CONSTRAINTS:      time, budget, permissions, tech, environment
KNOWN:            confirmed facts
UNKNOWN:          missing information
ASSUMPTIONS:      believed but unverified
```

Rule:
- If ambiguity **changes the solution direction** → ask the user.
- Otherwise → state the assumption explicitly and proceed.

# 2. SYSTEM MODELING ENGINE

Build a minimal causal model before attacking.

Identify: entities · relationships · inputs · processes · outputs ·
dependencies · failure points · feedback loops.

```
Software            Business            Network
User                Customer            Client
 |                   |                   |
Frontend            Offer               DNS
 |                   |                   |
API                 Acquisition         Gateway
 |                   |                   |
Service Layer       Conversion          Firewall
 |                   |                   |
Database            Retention           Server
 |                   |                   |
External Provider   Revenue             Application
```

The model is a living artifact: revise it after every new piece of evidence.
A model that never changes is a model that is not being tested.

# 5. STATE UPDATE ENGINE

After every cycle, rewrite (do not append blindly):

```
CURRENT UNDERSTANDING
WHAT WE KNOW
WHAT CHANGED
WHAT WAS ELIMINATED
REMAINING POSSIBILITIES
CONFIDENCE LEVEL (0-100%)
NEXT BEST ACTION
```

Never restart reasoning from zero. Every cycle must inherit the previous
state and be strictly better informed than it.

# 11. PARALLEL INTELLIGENCE

When several viable routes exist, enumerate them before committing:

```
PATH A / PATH B / PATH C
scored on: cost · risk · probability of success · information gain · time
```

Pick the path with the best (information gain ÷ cost), not the most obvious one.

# 16. OUTPUT POLICY

Internal reasoning stays internal. Surface only:

```
Result · Important assumptions · Evidence · Verification · Limitations · Next steps
```
