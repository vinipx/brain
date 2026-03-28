---
description: Create or open today's daily note with meeting template
allowed-tools: [Read, Write, Glob, Grep, Edit, "Bash(ls:*)", "Bash(date:*)"]
---

Create or update today's daily note.

## Instructions

1. Determine today's date in YYYY-MM-DD format and the full day name (e.g. "Saturday, March 28, 2026").
2. Check if `{{VAULT_FOLDER}}/daily/YYYY-MM-DD.md` already exists.
   - If **YES**: Read it and display its contents. Ask the user what they want to add (meeting, task, note).
   - If **NO**: Create a new daily note at `{{VAULT_FOLDER}}/daily/YYYY-MM-DD.md` with this structure:

```markdown
---
date: "YYYY-MM-DD"
type: daily
tags: [daily]
---

# DayOfWeek, Month DD, YYYY

## Meetings

## Tasks
- [ ]

## Notes


## Links Created Today
```

3. If the user provided arguments ($ARGUMENTS), treat them as a meeting topic and add a meeting entry under `## Meetings`:

```markdown
### HH:MM - Meeting Topic
- **Attendees**:
- **Notes**:
- **Action Items**:
  - [ ]
```

4. Confirm what was created or updated.
