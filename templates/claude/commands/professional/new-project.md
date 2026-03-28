---
description: Create a new project note with metadata and update the Projects MOC
argument-hint: <project-name>
allowed-tools: [Read, Write, Glob, Grep, Edit]
---

Create a new project tracking note.

## Instructions

Arguments: $ARGUMENTS

1. Ask for any missing information:
   - Project name (required — may be in $ARGUMENTS)
   - Client name
   - Brief description
   - Priority (high/medium/low)

2. Create the file at `{{VAULT_FOLDER}}/projects/<kebab-case-name>.md`:

```markdown
---
type: project
status: active
priority: "<priority>"
client: "<client>"
start-date: "YYYY-MM-DD"
target-date: ""
tags: [project]
---

# <Project Name>

## Overview
<description>

## Objectives
-

## Key Contacts
- [[]]

## Related
- **Commercial**: [[]]
- **Coding**: [[]]
- **Meetings**: [[]]

## Progress Log
| Date | Update |
|------|--------|
| YYYY-MM-DD | Created |

## Tasks
- [ ]
```

3. Add a link to this project in `{{VAULT_FOLDER}}/maps/Projects MOC.md` under the **Active** section.
4. If today's daily note exists in `{{VAULT_FOLDER}}/daily/`, add a mention of the new project there.
5. Confirm creation and show the file path.
