---
description: "Log a health entry -- workout, appointment, or habit"
argument-hint: <category>
allowed-tools: [Read, Write, Edit, Glob, Grep, "Bash(date:*)"]
---

Log a health entry.

## Instructions

Arguments: $ARGUMENTS

1. Ask for any missing information:
   - Category (required -- workout, appointment, or habit; may be in $ARGUMENTS)
   - Details/description of the entry

2. Determine the filename using today's date and category: `YYYY-MM-DD-<category>.md`. Check if `{{VAULT_FOLDER}}/health/YYYY-MM-DD-<category>.md` already exists. If it does, inform the user and offer to append instead.

3. Create the file at `{{VAULT_FOLDER}}/health/YYYY-MM-DD-<category>.md`:

```markdown
---
type: health-log
category: "<category>"
date: "YYYY-MM-DD"
tags: [health]
---

# <Category> - YYYY-MM-DD

## Details
- **Category**: <category>
- **Date**: YYYY-MM-DD

## Measurements
| Metric | Value |
|--------|-------|
|        |       |

## Notes
<details provided by user>

## Follow-up
- [ ]
```

4. Add a link to this entry in `{{VAULT_FOLDER}}/maps/Health MOC.md` under the appropriate section.
5. If today's daily note exists at `{{VAULT_FOLDER}}/daily/YYYY-MM-DD.md`, add a mention of the health log there.
6. Confirm creation and show the file path.
