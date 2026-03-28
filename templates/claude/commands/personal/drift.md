---
description: Surface recurring themes across personal domains — health patterns, spending habits, study topics, hobby interests
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Scan my vault for recurring personal themes I might not be aware of.

## Instructions

1. Perform a broad scan of the vault:
   - Read all daily notes from `{{VAULT_FOLDER}}/daily/` (focus on the last 30 days).
   - Read all personal project notes from `{{VAULT_FOLDER}}/projects/`.
   - Read study and course notes from `{{VAULT_FOLDER}}/study/` and `{{VAULT_FOLDER}}/courses/`.
   - Read health logs from `{{VAULT_FOLDER}}/health/`.
   - Read financial notes from `{{VAULT_FOLDER}}/finances/`.
   - Read family notes from `{{VAULT_FOLDER}}/family/`.
   - Read hobby notes from `{{VAULT_FOLDER}}/hobby/`.
   - Scan weekly reviews for themes.

2. Look for **drift patterns** — ideas, words, phrases, or themes that:
   - Appear across **unrelated personal domains** (e.g., a theme in both health notes and hobby notes).
   - Recur without the user explicitly connecting them.
   - Show up in informal sections (Reflections, Notes, Ideas) more than structured sections (Tasks, Plans).
   - Are not already tracked as a project or tagged as a known interest.
   - Reveal unconscious patterns: spending triggers, health correlations, study preferences, mood patterns.

3. For each drift pattern found:
   - Count how many notes mention it and across how many different personal domains.
   - Note whether the frequency is increasing, stable, or fading.
   - Identify what's orbiting around it (related topics, people, activities).

4. Present the findings:

```
## Personal Drift Report

### Strong Drift (appears across 3+ unrelated personal domains)

**1. <theme or phrase>**
- Appearances: N notes across M domains
- Domains: <e.g., health, daily notes, hobby>
- Trend: increasing / stable / fading
- Found in:
  - [[note]] (domain) -- "<relevant quote>"
  - [[note]] (domain) -- "<relevant quote>"
  - [[note]] (domain) -- "<relevant quote>"
- Orbiting topics: <related ideas that appear near this theme>
- Interpretation: <why this might keep coming up>

**2. ...**

### Emerging Drift (2 unrelated domains, worth watching)

**1. <theme>**
- Found in: [[note]], [[note]]
- Domains: <which personal areas>
- Interpretation: <early signal, may develop>

### Fading Drift (used to appear, hasn't recently)

**1. <theme>**
- Last seen: YYYY-MM-DD in [[note]]
- Context: <what it was about>
- Note: <may be resolved, abandoned, or subsumed by another interest>

### Pattern Insights
- **Health patterns**: <correlations between mood, energy, exercise, sleep mentioned in notes>
- **Spending patterns**: <recurring spending themes or financial concerns>
- **Learning patterns**: <what subjects or skills keep pulling attention>
- **Energy patterns**: <when the user seems most productive or engaged>

### What This Might Mean
- <high-level interpretation of what the user's subconscious seems to be circling>
- <suggestions: promote to project? set a new goal? change a habit? explore further?>
```

5. Be specific. Quote actual text from notes. The value is in surfacing what's hidden in plain sight across different areas of life.
