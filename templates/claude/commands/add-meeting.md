---
description: Add a meeting record to today's daily note or create a standalone meeting note
argument-hint: <meeting-topic>
allowed-tools: [Read, Write, Glob, Grep, Edit, "Bash(date:*)"]
---

Record a meeting outcome.

## Instructions

Arguments: $ARGUMENTS

1. Ask for details if not fully provided:
   - Meeting topic/title (may be in $ARGUMENTS)
   - Attendees
   - Related project or presale (if any)
   - Key discussion points
   - Decisions made
   - Action items

2. Check if today's daily note exists at `{{VAULT_FOLDER}}/daily/YYYY-MM-DD.md`.
   - If **NO**: Create it first using the daily note template, then add the meeting.
   - If **YES**: Read it to find the `## Meetings` section.

3. Add the meeting under `## Meetings` in the daily note:

```markdown
### HH:MM - <Topic>
- **Project**: [[<project>]]
- **Attendees**: <names>
- **Discussion**: <summary>
- **Decisions**: <decisions>
- **Action Items**:
  - [ ] <action>
```

4. If the meeting is substantial (3+ decisions or 5+ action items), also create a standalone note at `{{VAULT_FOLDER}}/meetings/YYYY-MM-DD-<kebab-topic>.md` using the meeting template, and link it from the daily note.

5. Add cross-reference wiki-links to any mentioned projects (`[[project-name]]`), presales, or people.
6. Create person notes in `{{VAULT_FOLDER}}/people/` for any new attendees not yet in the vault.
7. Confirm what was recorded.
