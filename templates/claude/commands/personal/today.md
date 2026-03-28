---
description: Generate a prioritized personal plan for today based on your habits, studies, health, and life goals
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Read my daily note, tasks, and recent context. Generate a prioritized personal plan for today.

## Instructions

1. Determine today's date in YYYY-MM-DD format and the full day name.
2. Check if today's daily note exists at `{{VAULT_FOLDER}}/daily/YYYY-MM-DD.md`.
   - If **YES**: Read it for any pre-existing events, tasks, or notes.
   - If **NO**: Note that no daily note exists yet and suggest creating one with `/daily`.

3. Gather context:
   - Read the **previous 3 daily notes** for carry-over tasks (`- [ ]`), momentum, and patterns.
   - Read all **active courses** (`{{VAULT_FOLDER}}/courses/*.md`) for upcoming assignments, exams, or deadlines.
   - Read all **study notes** (`{{VAULT_FOLDER}}/study/*.md`) for current study goals and sessions planned.
   - Read all **health notes** (`{{VAULT_FOLDER}}/health/*.md`) for today's habits, workout schedule, or appointments.
   - Read all **finance notes** (`{{VAULT_FOLDER}}/finances/*.md`) for pending payments, bills due, or budget reviews.
   - Read all **family notes** (`{{VAULT_FOLDER}}/family/*.md`) for today's family events or commitments.
   - Read all **hobby notes** (`{{VAULT_FOLDER}}/hobby/*.md`) for hobby goals or scheduled sessions.
   - Read all **active projects** (`{{VAULT_FOLDER}}/projects/*.md` with `status: active`) for personal project tasks.

4. Build a prioritized plan:
   - **Must do**: Tasks with deadlines today, health appointments, overdue carry-overs, bills due.
   - **Should do**: Study sessions, course work, active project tasks, scheduled workouts, family commitments.
   - **Could do**: Hobby time, exploration, reading, low-priority personal tasks.
   - **Carry-over**: Incomplete tasks from previous days with their source.

5. Present the plan:

```
## Today's Plan -- DayOfWeek, Month DD, YYYY

### Must Do
- [ ] <task> -- <why it's urgent>

### Should Do
- [ ] <task> -- <context from course/study/project>

### Could Do
- [ ] <task> -- <context>

### Health & Habits
- [ ] <workout/habit> -- <schedule or goal>
- <appointment if any>

### Study & Courses
- [ ] <study session or assignment> -- <course/subject, deadline>

### Family & Events
- <event or commitment> (from [[source]])

### Carry-Over from Previous Days
- [ ] <task> (from [[YYYY-MM-DD]])

### Context
- <brief note on what's happening this week, any deadlines approaching>
```

6. If the daily note doesn't exist, offer to create it with the plan pre-filled.
