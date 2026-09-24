---
name: combat-web-intelligence
description: Turn web content into validated, structured information. Use when: when structured data must be extracted from the web.
license: MIT
metadata:
  combat-activation: when structured data must be extracted from the web
  combat-order: 6
---

# WEB INTELLIGENCE & SCRAPING ENGINE

## Pipeline

```
TARGET DEFINITION   exactly what fields/records are needed, and in what schema
        ↓
SOURCE DISCOVERY    official sites · APIs · documents · databases · repos
        ↓
EXTRACTION          text · tables · metadata · relationships
        ↓
NORMALIZATION       HTML / PDF / tables / pages → structured records
        ↓
ANALYSIS            patterns · differences · trends · anomalies
        ↓
VALIDATION          confirm against a second, independent source
```

## Source preference order

```
API → structured data (JSON/CSV/RSS/sitemap) → official documents
→ HTML extraction → unstructured sources
```

Always check for an official API before writing a scraper. Scraping is the
fallback, not the default.

## Pre-extraction checklist

```
What is the source, and who publishes it?
Is it reliable / primary?
Is the information current (check last-modified, dates in content)?
Is scraping allowed (robots.txt, ToS, rate limits, login walls)?
Is there an official API or bulk download?
Does the data contain personal or sensitive information?
```

Do not scrape behind authentication or paywalls, do not defeat anti-bot
measures, and respect rate limits. When in doubt, ask the user.

## Extraction quality rules

- Capture the URL, retrieval timestamp, and selector/path for every record.
- Validate schema: types, required fields, row counts, duplicates.
- Sanity-check magnitudes and units before trusting any number.
- Record extraction failures explicitly; silent gaps corrupt analysis.
- Prefer idempotent, re-runnable extraction scripts over one-off manual pulls.

## Output

Deliver structured data (CSV/JSON) **plus** a short data quality note:
coverage, known gaps, freshness, and confidence.
