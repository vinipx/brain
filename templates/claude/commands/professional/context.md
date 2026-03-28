---
description: Load your full life and work state — projects, preferences, priorities, current focus
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Read the vault and summarize my current context.

## Instructions

1. Determine today's date in YYYY-MM-DD format.
2. Scan the vault to build a full picture of the user's current state:

   **Active Projects:**
   - Glob `{{VAULT_FOLDER}}/projects/*.md` and read each one. List those with `status: active` or `status: on-hold`.
   - Note key details: client, priority, timeline, recent progress.

   **Active Commercials:**
   - Glob `{{VAULT_FOLDER}}/commercials/*.md` and read each one. List those with `status: active`.
   - Note: client, value, probability, next steps.

   **Coding Projects:**
   - Glob `{{VAULT_FOLDER}}/coding/*.md` and read each one.
   - Note: repo name, language, status.

   **Recent Focus (last 7 days):**
   - Read the most recent 7 daily notes from `{{VAULT_FOLDER}}/daily/`.
   - Extract: recurring topics, mentioned priorities, patterns in tasks and meetings.

   **People in Context:**
   - Glob `{{VAULT_FOLDER}}/people/*.md` and read each one.
   - Note who appears frequently in recent daily notes and meetings.

   **Recent Reflections:**
   - Check weekly reviews in `{{VAULT_FOLDER}}/daily/` (files matching `*-review.md`).
   - Extract any reflections or themes from the most recent review.

3. Present the summary in this format:

```
## Your Current Context

### Active Projects
- [[project]] — status, client, priority, brief description
  - Recent: <latest progress or activity>

### Active Commercials
- [[commercial]] — client, stage, next step

### Coding Projects
- [[repo]] — language, status

### This Week's Focus
- <what the user has been spending time on based on daily notes>
- <recurring themes, mentioned priorities>

### Key People
- [[person]] — role/context, recent interactions

### Recent Reflections
- <themes from latest weekly review>

### Suggested Focus
- <based on patterns, what seems most important right now>
```

4. Keep the summary scannable. Use wiki-links so the user can jump to any note for details.
