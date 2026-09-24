# Adapters — programmatic integration

The file-based installers cover Cursor, Claude Code, Windsurf, Codex and
Copilot. For SDK-driven agents, wire the skills in as follows.

## OpenAI Agents SDK

```python
from pathlib import Path
from agents import Agent

S = Path(".relentless")
core = (S / "core.md").read_text()

def load(*names: str) -> str:
    return "\n\n---\n\n".join((S / f"{n}.md").read_text() for n in names)

agent = Agent(
    name="relentless",
    instructions=core + "\n\n" + load("triage", "safety", "stop-policy"),
)

# escalate mid-run when triage returns COMPLEX
def escalate(agent):
    agent.instructions += "\n\n" + load(
        "reasoning", "hypothesis", "evidence",
        "deep-search", "web-intelligence", "verification",
    )
```

## LangGraph

Map skills to graph nodes; the loop in `core.md` is the graph.

```
triage ──trivial──> answer
   │
 complex
   ↓
frame_and_model (reasoning.md)
   ↓
hypothesize (hypothesis.md)  ←──────────────┐
   ↓                                        │
need_info? ──yes──> research (deep-search,  │
   │                 web-intelligence)      │
   no                                       │
   ↓                                        │
[safety gate (safety.md)] ──blocked──> ask_user
   ↓                                        │
act ──> observe ──> verify (verification.md)│
   ↓                                        │
success? ──no──> update_state (reasoning.md)┘
   │              (anti-loop: max 2 per strategy class)
  yes
   ↓
report (stop-policy.md)
```

Keep the evidence ledger from `evidence.md` in graph state:

```python
class State(TypedDict):
    facts: list[dict]        # {claim, tier, source}
    hypotheses: list[dict]   # {id, text, score, status}
    attempts: list[dict]     # {n, hypothesis, action, expected, actual, learning}
    confidence: int
```

## MCP / tool servers

Expose each skill file as a resource (`relentless://skill/<id>`) and let the
model fetch on demand — this keeps the always-on context to `core.md` only
(~50 lines) while the remaining ~600 lines stay one call away.
