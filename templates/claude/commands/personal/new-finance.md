---
description: Create a finance tracking note
argument-hint: <description>
allowed-tools: [Read, Write, Edit, Glob, Grep, "Bash(date:*)"]
---

Create a new finance tracking note.

## Instructions

Arguments: $ARGUMENTS

1. Ask for any missing information:
   - Category (required, e.g. expense, income, investment, subscription)
   - Amount (required)
   - Description (required -- may be in $ARGUMENTS)

2. Determine the filename using today's date and a kebab-case description. Check if `{{VAULT_FOLDER}}/finances/YYYY-MM-DD-<kebab-case-description>.md` already exists. If it does, inform the user and stop.

3. Create the file at `{{VAULT_FOLDER}}/finances/YYYY-MM-DD-<kebab-case-description>.md`:

```markdown
---
type: finance
category: "<category>"
amount: "<amount>"
date: "YYYY-MM-DD"
recurring: false
tags: [finance]
---

# <Description>

## Details
- **Category**: <category>
- **Amount**: <amount>
- **Date**: YYYY-MM-DD
- **Recurring**: false

## Notes


## Related
- [[]]
```

4. Add a link to this entry in `{{VAULT_FOLDER}}/maps/Finance MOC.md` under the appropriate section.
5. If today's daily note exists at `{{VAULT_FOLDER}}/daily/YYYY-MM-DD.md`, add a mention of the finance entry there.
6. Confirm creation and show the file path.
