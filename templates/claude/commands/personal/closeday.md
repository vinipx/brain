---
description: Capture what happened today across your personal life — study, health, spending, family, hobbies
allowed-tools: [Read, Write, Glob, Grep, Edit, "Bash(date:*)"]
---

Review what I did today across all personal domains and close out the day.

## Instructions

1. Determine today's date in YYYY-MM-DD format.
2. Read today's daily note at `{{VAULT_FOLDER}}/daily/YYYY-MM-DD.md`.
   - If it doesn't exist, tell the user: "No daily note for today. Would you like me to create a summary from scratch?"

3. Gather today's activity:
   - **From the daily note**: events, tasks (completed and open), notes, reflections.
   - **Study & courses**: Check `{{VAULT_FOLDER}}/study/` and `{{VAULT_FOLDER}}/courses/` for any notes modified today.
   - **Health**: Check `{{VAULT_FOLDER}}/health/` for workout logs, habit tracking, or health notes from today.
   - **Finances**: Check `{{VAULT_FOLDER}}/finances/` for any spending entries or financial activity.
   - **Family**: Check `{{VAULT_FOLDER}}/family/` for family interactions or events today.
   - **Hobbies**: Check `{{VAULT_FOLDER}}/hobby/` for hobby activity today.
   - **Projects**: Check `{{VAULT_FOLDER}}/projects/` for any personal projects modified today.

4. Build the end-of-day summary and update the daily note by appending an `## End of Day` section:

```markdown
## End of Day

### Study & Learning
- <what was studied, for how long, key takeaways>
- Course progress: <any assignments completed, lectures watched>

### Health & Wellness
- <workout completed or skipped, habits tracked>
- <how energy/mood was today>

### Finances
- <any spending, bills paid, financial decisions>

### Family & Social
- <family interactions, events attended, quality time>

### Hobby Progress
- <what was done, any milestones or creative output>

### Personal Projects
- <progress on active personal projects, with [[links]]>

### New Ideas
- <any ideas that surfaced during the day worth noting>

### Carry-Over to Tomorrow
- [ ] <unfinished task> (from: <context>)
- [ ] <follow-up action> (from: <domain>)

### Reflections
- <what went well>
- <what could improve>
- <gratitude or highlight of the day>
```

5. Mark completed tasks in the daily note: change `- [ ]` to `- [x]` for tasks the user confirms are done. Ask the user to confirm which tasks were completed if unclear.

6. If any carry-over tasks exist, mention: "These will appear when you run `/today` tomorrow morning."

7. Present a brief summary of the day to the user.
