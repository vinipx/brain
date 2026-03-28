---
description: Create a new hobby tracking note
argument-hint: <hobby-name>
allowed-tools: [Read, Write, Edit, Glob, Grep, "Bash(date:*)"]
---

Create a new hobby tracking note.

## Instructions

Arguments: $ARGUMENTS

1. Ask for any missing information:
   - Hobby name (required -- may be in $ARGUMENTS)

2. Check if `{{VAULT_FOLDER}}/hobby/<kebab-case-name>.md` already exists. If it does, inform the user and stop.

3. Create the file at `{{VAULT_FOLDER}}/hobby/<kebab-case-name>.md`:

```markdown
---
type: hobby
hobby-name: "<hobby>"
status: active
tags: [hobby]
---

# <Hobby Name>

## Description


## Goals
-

## Progress Log
| Date | Update |
|------|--------|
| YYYY-MM-DD | Started |

## Resources
- [[]]

## Related
- [[]]
```

4. Add a link to this hobby in `{{VAULT_FOLDER}}/maps/Hobbies MOC.md` under the appropriate section.
5. If today's daily note exists at `{{VAULT_FOLDER}}/daily/YYYY-MM-DD.md`, add a mention of the new hobby there.
6. Confirm creation and show the file path.
