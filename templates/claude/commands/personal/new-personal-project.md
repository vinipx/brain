---
description: Create a new personal project note
argument-hint: <project-name>
allowed-tools: [Read, Write, Edit, Glob, Grep, "Bash(date:*)"]
---

Create a new personal project tracking note.

## Instructions

Arguments: $ARGUMENTS

1. Ask for any missing information:
   - Project name (required -- may be in $ARGUMENTS)
   - Priority (high/medium/low, optional -- defaults to medium)

2. Check if `{{VAULT_FOLDER}}/projects/<kebab-case-name>.md` already exists. If it does, inform the user and stop.

3. Create the file at `{{VAULT_FOLDER}}/projects/<kebab-case-name>.md`:

```markdown
---
type: personal-project
status: active
priority: "<priority>"
start-date: "YYYY-MM-DD"
target-date: ""
tags: [project]
---

# <Project Name>

## Overview


## Goals
-

## Tasks
- [ ]

## Related
- [[]]

## Progress Log
| Date | Update |
|------|--------|
| YYYY-MM-DD | Created |
```

4. Add a link to this project in `{{VAULT_FOLDER}}/maps/Projects MOC.md` under the **Active** section.
5. If today's daily note exists at `{{VAULT_FOLDER}}/daily/YYYY-MM-DD.md`, add a mention of the new personal project there.
6. Confirm creation and show the file path.
