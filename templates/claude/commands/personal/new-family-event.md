---
description: Create a family event note
argument-hint: <event-name>
allowed-tools: [Read, Write, Edit, Glob, Grep, "Bash(date:*)"]
---

Create a new family event note.

## Instructions

Arguments: $ARGUMENTS

1. Ask for any missing information:
   - Event name (required -- may be in $ARGUMENTS)
   - Date of the event
   - Participants

2. Check if `{{VAULT_FOLDER}}/family/<kebab-case-name>.md` already exists. If it does, inform the user and stop.

3. Create the file at `{{VAULT_FOLDER}}/family/<kebab-case-name>.md`:

```markdown
---
type: family-event
date: "<event-date>"
participants: [<participants>]
tags: [family]
---

# <Event Name>

## Event
- **Date**: <event-date>
- **Location**:

## Participants
- <participant list>

## Notes


## Follow-up
- [ ]
```

4. Add a link to this event in `{{VAULT_FOLDER}}/maps/Family MOC.md` under the appropriate section.
5. If today's daily note exists at `{{VAULT_FOLDER}}/daily/YYYY-MM-DD.md`, add a mention of the family event there.
6. Confirm creation and show the file path.
