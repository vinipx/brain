---
description: Capture what happened today across work and personal life — meetings, tasks, study, health, spending, family, hobbies
allowed-tools: [Read, Write, Glob, Grep, Edit, "Bash(date:*)"]
---

Review what I worked on today across both work and personal life and close out the day.

## Instructions

1. Determine today's date in YYYY-MM-DD format.
2. Read today's daily note at `{{VAULT_FOLDER}}/daily/YYYY-MM-DD.md`.
   - If it doesn't exist, tell the user: "No daily note for today. Would you like me to create a summary from scratch?"

3. Gather today's activity across all domains:

   **Work activity:**
   - **From the daily note**: meetings, tasks (completed and open), notes.
   - **From meeting notes**: any meetings created today in `{{VAULT_FOLDER}}/meetings/` (check filenames starting with today's date).
   - **From project notes**: any projects modified today (check recent file timestamps with `ls -lt`).
   - **From commercial notes**: any commercials modified today in `{{VAULT_FOLDER}}/commercials/`.

   **Personal activity:**
   - **Study & courses**: Check `{{VAULT_FOLDER}}/study/` and `{{VAULT_FOLDER}}/courses/` for any notes modified today.
   - **Health**: Check `{{VAULT_FOLDER}}/health/` for workout logs, habit tracking, or health notes from today.
   - **Finances**: Check `{{VAULT_FOLDER}}/finances/` for any spending entries or financial activity.
   - **Family**: Check `{{VAULT_FOLDER}}/family/` for family interactions or events today.
   - **Hobbies**: Check `{{VAULT_FOLDER}}/hobby/` for hobby activity today.

4. Build the end-of-day summary and update the daily note by appending an `## End of Day` section:

```markdown
## End of Day

### Work Progress
- <what was accomplished professionally today, with [[links]] to relevant notes>

### Meetings Recap
- <meeting> — key outcome: <one-liner>

### Personal Progress

#### Study & Learning
- <what was studied, for how long, key takeaways>
- Course progress: <any assignments completed, lectures watched>

#### Health & Wellness
- <workout completed or skipped, habits tracked>
- <how energy/mood was today>

#### Finances
- <any spending, bills paid, financial decisions>

#### Family & Social
- <family interactions, events attended, quality time>

#### Hobby Progress
- <what was done, any milestones or creative output>

### New Ideas
- <any ideas that surfaced during the day worth noting>

### Carry-Over to Tomorrow
- [ ] <unfinished work task> (from: <project/commercial>)
- [ ] <unfinished personal task> (from: <domain>)

### Reflections
- <what went well>
- <what could improve>
- <gratitude or highlight of the day>
```

5. Mark completed tasks in the daily note: change `- [ ]` to `- [x]` for tasks the user confirms are done. Ask the user to confirm which tasks were completed if unclear.

6. If any carry-over tasks exist, mention: "These will appear when you run `/today` tomorrow morning."

7. Present a brief summary of the day to the user.
