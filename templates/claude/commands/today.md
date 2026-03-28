---
description: Generate a prioritized plan for today based on your tasks, calendar, and recent notes
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Read my daily note, tasks, and recent context. Generate a prioritized plan for today.

## Instructions

1. Determine today's date in YYYY-MM-DD format and the full day name.
2. Check if today's daily note exists at `{{VAULT_FOLDER}}/daily/YYYY-MM-DD.md`.
   - If **YES**: Read it for any pre-existing meetings, tasks, or notes.
   - If **NO**: Note that no daily note exists yet and suggest creating one with `/daily`.

3. Gather context:
   - Read the **previous 3 daily notes** for carry-over tasks (`- [ ]`), momentum, and patterns.
   - Read all **active projects** (`{{VAULT_FOLDER}}/projects/*.md` with `status: active`) for deadlines or milestones.
   - Read all **active presales** (`{{VAULT_FOLDER}}/presales/*.md` with `status: active`) for upcoming deliverables.
   - Check for any **meeting notes** from yesterday that have unresolved action items.

4. Build a prioritized plan:
   - **Must do**: Tasks with deadlines today or overdue carry-overs.
   - **Should do**: Active project work, presale follow-ups, scheduled meetings.
   - **Could do**: Low-priority tasks, exploration, learning.
   - **Carry-over**: Incomplete tasks from previous days with their source.

5. Present the plan:

```
## Today's Plan — DayOfWeek, Month DD, YYYY

### Must Do
- [ ] <task> — <why it's urgent>

### Should Do
- [ ] <task> — <context from project/presale>

### Could Do
- [ ] <task> — <context>

### Meetings
- <time> — <meeting> (from [[source]])

### Carry-Over from Previous Days
- [ ] <task> (from [[YYYY-MM-DD]])

### Context
- <brief note on what's hot this week, any deadlines approaching>
```

6. If the daily note doesn't exist, offer to create it with the plan pre-filled.
