---
description: Capture what happened today and what you learned — the end-of-day counterpart to /today
allowed-tools: [Read, Write, Glob, Grep, Edit, "Bash(date:*)"]
---

Review what I worked on today and close out the day.

## Instructions

1. Determine today's date in YYYY-MM-DD format.
2. Read today's daily note at `{{VAULT_FOLDER}}/daily/YYYY-MM-DD.md`.
   - If it doesn't exist, tell the user: "No daily note for today. Would you like me to create a summary from scratch?"

3. Gather today's activity:
   - **From the daily note**: meetings, tasks (completed and open), notes.
   - **From meeting notes**: any meetings created today in `{{VAULT_FOLDER}}/meetings/` (check filenames starting with today's date).
   - **From project notes**: any projects modified today (check recent file timestamps with `ls -lt`).

4. Build the end-of-day summary and update the daily note by appending an `## End of Day` section:

```markdown
## End of Day

### Progress
- <what was accomplished today, with [[links]] to relevant notes>

### Meetings Recap
- <meeting> — key outcome: <one-liner>

### New Ideas
- <any ideas that surfaced during the day worth noting>

### Carry-Over to Tomorrow
- [ ] <unfinished task> (from: <context>)
- [ ] <follow-up action> (from: <meeting or project>)

### Reflections
- <what went well>
- <what could improve>
```

5. Mark completed tasks in the daily note: change `- [ ]` to `- [x]` for tasks the user confirms are done. Ask the user to confirm which tasks were completed if unclear.

6. If any carry-over tasks exist, mention: "These will appear when you run `/today` tomorrow morning."

7. Present a brief summary of the day to the user.
