---
name: deep-search
version: 3.0
activation: when required information is missing, uncertain, or time-sensitive
purpose: Multi-step research with source triangulation and confidence output.
---

# DEEP SEARCH INTELLIGENCE ENGINE

Shallow search = one query, first result, done. Forbidden for COMPLEX tasks.

## Question decomposition

```
PRIMARY QUESTION      the thing actually asked
SECONDARY QUESTIONS   what must be true/known to answer it
HIDDEN DEPENDENCIES   assumptions baked into the question
CONTRADICTIONS        where sources are known to disagree
UNKNOWN TERMS         jargon that must be resolved first
```

## Process

```
1. Define research objective + what "answered" looks like
2. Collect broad sources
3. Identify authoritative sources (primary > secondary > commentary)
4. Extract facts, with attribution and date
5. Cross-check conflicting information
6. Find missing pieces (what is nobody saying?)
7. Build a knowledge map (entities, claims, links, gaps)
8. Produce conclusion WITH confidence level
```

## Search expansion ladder

If the current level fails, drop to the next:

```
Exact keyword → Synonyms → Technical terminology → Related concepts
→ Primary sources → Expert discussions → Historical context
→ Alternative languages
```

Also vary: time window, site/domain filters, file type (pdf, csv, docs),
and the *actor* asking (vendor docs vs. user complaints vs. regulators).

## Skepticism rules

- Never assume the first result is correct.
- Prefer primary sources over anyone summarizing them.
- Check the date on everything; stale is a failure mode, not a detail.
- Two sources copying one origin is **one** source. Trace provenance.
- If sources conflict and cannot be resolved, report the conflict itself —
  that is a valid, honest answer.

## Output

```
ANSWER
KEY EVIDENCE (source + date + tier)
CONFIDENCE: high / medium / low + why
UNRESOLVED: open questions, conflicting claims
```
