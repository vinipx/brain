---
description: Generate a weekly review summarizing the past 5 work days
allowed-tools: [Read, Write, Glob, Grep, Edit, "Bash(ls:*)", "Bash(date:*)"]
---

Generate a summary of the past week's activity.

## Instructions

1. List all daily notes in `{{VAULT_FOLDER}}/daily/` sorted by date descending. Take the most recent 5.
2. Read each of those daily notes.
3. Aggregate:
   - All meetings attended (with brief summaries)
   - Tasks completed (checked `- [x]`)
   - Tasks still open (unchecked `- [ ]`)
   - Projects referenced
   - Presales referenced
4. Determine the ISO week number and date range.
5. Create a review note at `{{VAULT_FOLDER}}/daily/YYYY-WNN-review.md`:

```markdown
---
type: weekly-review
week: "YYYY-WNN"
date-range: "YYYY-MM-DD to YYYY-MM-DD"
tags: [weekly-review]
---

# Week NN Review (YYYY-MM-DD to YYYY-MM-DD)

## Meetings This Week
- <date> — <meeting summary>

## Completed Tasks
- [x] <task> (from [[source]])

## Open Tasks
- [ ] <task> (from [[source]])

## Project Activity
- [[project]] — <what happened>

## Presale Activity
- [[presale]] — <what happened>

## Reflections

```

6. Present the summary to the user.
