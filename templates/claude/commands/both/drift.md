---
description: Surface recurring themes across all work and personal domains — project patterns, health correlations, spending habits, learning interests
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Scan my vault for recurring themes I might not be aware of across both work and personal life.

## Instructions

1. Perform a broad scan of the vault:

   **Work domain:**
   - Read all daily notes from `{{VAULT_FOLDER}}/daily/` (focus on the last 30 days).
   - Read all project notes from `{{VAULT_FOLDER}}/projects/`.
   - Read commercial notes from `{{VAULT_FOLDER}}/commercials/`.
   - Read coding notes from `{{VAULT_FOLDER}}/coding/`.
   - Read meeting notes from `{{VAULT_FOLDER}}/meetings/`.

   **Personal domain:**
   - Read study and course notes from `{{VAULT_FOLDER}}/study/` and `{{VAULT_FOLDER}}/courses/`.
   - Read health logs from `{{VAULT_FOLDER}}/health/`.
   - Read financial notes from `{{VAULT_FOLDER}}/finances/`.
   - Read family notes from `{{VAULT_FOLDER}}/family/`.
   - Read hobby notes from `{{VAULT_FOLDER}}/hobby/`.

   **Cross-domain:**
   - Read people notes from `{{VAULT_FOLDER}}/people/`.
   - Scan weekly reviews for themes.

2. Look for **drift patterns** — ideas, words, phrases, or themes that:
   - Appear across **unrelated** notes (different projects, different life domains).
   - Recur without the user explicitly connecting them.
   - Show up in informal sections (Notes, Reflections, Ideas) more than structured sections (Tasks, Decisions, Plans).
   - Are not already tracked as a project or tagged as a known interest.
   - Cross the work-personal boundary (e.g., a theme in both meeting notes and health reflections).
   - Reveal unconscious patterns: spending triggers, health correlations, productivity rhythms, mood patterns.

3. For each drift pattern found:
   - Count how many notes mention it and across how many different contexts or domains.
   - Note whether the frequency is increasing, stable, or fading.
   - Identify what's orbiting around it (related topics, people, projects, activities).

4. Present the findings:

```
## Drift Report

### Strong Drift (appears across 3+ unrelated contexts or domains)

**1. <theme or phrase>**
- Appearances: N notes across M contexts/domains
- Domains: <e.g., projects, health, daily notes, hobby>
- Trend: increasing / stable / fading
- Found in:
  - [[note]] (domain) — "<relevant quote>"
  - [[note]] (domain) — "<relevant quote>"
  - [[note]] (domain) — "<relevant quote>"
- Orbiting topics: <related ideas that appear near this theme>
- Interpretation: <why this might keep coming up>

**2. ...**

### Emerging Drift (2 unrelated contexts, worth watching)

**1. <theme>**
- Found in: [[note]], [[note]]
- Domains: <which areas>
- Interpretation: <early signal, may develop>

### Cross-Domain Drift (themes bridging work and personal life)

**1. <theme>**
- Work side: [[note]] — "<relevant quote>"
- Personal side: [[note]] — "<relevant quote>"
- Interpretation: <what this bridge might mean>

### Fading Drift (used to appear, hasn't recently)

**1. <theme>**
- Last seen: YYYY-MM-DD in [[note]]
- Context: <what it was about>
- Note: <may be resolved, abandoned, or subsumed by another topic>

### Pattern Insights
- **Work patterns**: <recurring themes in projects, meetings, or commercials>
- **Health patterns**: <correlations between mood, energy, exercise, sleep mentioned in notes>
- **Spending patterns**: <recurring spending themes or financial concerns>
- **Learning patterns**: <what subjects or skills keep pulling attention>
- **Energy patterns**: <when the user seems most productive or engaged>

### What This Might Mean
- <high-level interpretation of what the user's subconscious seems to be circling>
- <suggestions: promote to project? set a new goal? change a habit? explore further? talk to someone about it?>
```

5. Be specific. Quote actual text from notes. The value is in surfacing what's hidden in plain sight across different areas of life and work.
