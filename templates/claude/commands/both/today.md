---
description: Generate a prioritized plan for today covering work tasks, meetings, and personal commitments — study, health, family, hobbies
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Read my daily note, tasks, and recent context. Generate a prioritized plan covering both work and personal life.

## Instructions

1. Determine today's date in YYYY-MM-DD format and the full day name.
2. Check if today's daily note exists at `{{VAULT_FOLDER}}/daily/YYYY-MM-DD.md`.
   - If **YES**: Read it for any pre-existing meetings, tasks, or notes.
   - If **NO**: Note that no daily note exists yet and suggest creating one with `/daily`.

3. Gather context across all domains:

   **Work context:**
   - Read the **previous 3 daily notes** for carry-over tasks (`- [ ]`), momentum, and patterns.
   - Read all **active projects** (`{{VAULT_FOLDER}}/projects/*.md` with `status: active`) for deadlines or milestones.
   - Read all **active commercials** (`{{VAULT_FOLDER}}/commercials/*.md` with `status: active`) for upcoming deliverables.
   - Check for any **meeting notes** from yesterday in `{{VAULT_FOLDER}}/meetings/` that have unresolved action items.

   **Personal context:**
   - Read all **active courses** (`{{VAULT_FOLDER}}/courses/*.md`) for upcoming assignments, exams, or deadlines.
   - Read all **study notes** (`{{VAULT_FOLDER}}/study/*.md`) for current study goals and sessions planned.
   - Read all **health notes** (`{{VAULT_FOLDER}}/health/*.md`) for today's habits, workout schedule, or appointments.
   - Read all **finance notes** (`{{VAULT_FOLDER}}/finances/*.md`) for pending payments, bills due, or budget reviews.
   - Read all **family notes** (`{{VAULT_FOLDER}}/family/*.md`) for today's family events or commitments.
   - Read all **hobby notes** (`{{VAULT_FOLDER}}/hobby/*.md`) for hobby goals or scheduled sessions.

4. Build a prioritized plan:
   - **Must do**: Tasks with deadlines today, health appointments, overdue carry-overs, bills due, critical work deliverables.
   - **Should do**: Active project work, commercial follow-ups, scheduled meetings, study sessions, course work, scheduled workouts, family commitments.
   - **Could do**: Low-priority tasks, hobby time, exploration, learning, reading.
   - **Carry-over**: Incomplete tasks from previous days with their source.

5. Present the plan:

```
## Today's Plan — DayOfWeek, Month DD, YYYY

### Must Do
- [ ] <task> — <why it's urgent>

### Should Do — Work
- [ ] <task> — <context from project/commercial>

### Should Do — Personal
- [ ] <task> — <context from course/study/project>

### Could Do
- [ ] <task> — <context>

### Meetings
- <time> — <meeting> (from [[source]])

### Health & Habits
- [ ] <workout/habit> — <schedule or goal>
- <appointment if any>

### Study & Courses
- [ ] <study session or assignment> — <course/subject, deadline>

### Family & Events
- <event or commitment> (from [[source]])

### Carry-Over from Previous Days
- [ ] <task> (from [[YYYY-MM-DD]])

### Context
- Work: <brief note on active projects, deadlines approaching>
- Personal: <brief note on what's happening this week personally>
```

6. If the daily note doesn't exist, offer to create it with the plan pre-filled.
