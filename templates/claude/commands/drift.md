---
description: Surface loosely connected ideas that keep appearing across unrelated notes
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Scan my vault for recurring themes I might not be aware of.

## Instructions

1. Perform a broad scan of the vault:
   - Read all daily notes from `{{VAULT_FOLDER}}/daily/` (focus on the last 30 days).
   - Read all project notes from `{{VAULT_FOLDER}}/projects/`.
   - Read meeting notes from `{{VAULT_FOLDER}}/meetings/`.
   - Scan weekly reviews for themes.

2. Look for **drift patterns** — ideas, words, phrases, or themes that:
   - Appear across **unrelated** notes (different projects, different contexts).
   - Recur without the user explicitly connecting them.
   - Show up in informal sections (Notes, Reflections) more than structured sections (Tasks, Decisions).
   - Are not already tracked as a project or tagged as a known interest.

3. For each drift pattern found:
   - Count how many notes mention it and across how many different contexts.
   - Note whether the frequency is increasing, stable, or fading.
   - Identify what's orbiting around it (related topics, people, projects).

4. Present the findings:

```
## Drift Report

### Strong Drift (appears across 3+ unrelated contexts)

**1. <theme or phrase>**
- Appearances: N notes across M contexts
- Trend: increasing / stable / fading
- Found in:
  - [[note]] (type) — "<relevant quote>"
  - [[note]] (type) — "<relevant quote>"
  - [[note]] (type) — "<relevant quote>"
- Orbiting topics: <related ideas that appear near this theme>
- Interpretation: <why this might keep coming up>

**2. ...**

### Emerging Drift (2 unrelated contexts, worth watching)

**1. <theme>**
- Found in: [[note]], [[note]]
- Interpretation: <early signal, may develop>

### Fading Drift (used to appear, hasn't recently)

**1. <theme>**
- Last seen: YYYY-MM-DD in [[note]]
- Context: <what it was about>
- Note: <may be resolved, abandoned, or subsumed by another topic>

### What This Might Mean
- <high-level interpretation of what the user's subconscious seems to be circling>
- <suggestions: promote to project? explore further? talk to someone about it?>
```

5. Be specific. Quote actual text from notes. The value is in surfacing what's hidden in plain sight.
