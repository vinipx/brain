---
description: Create a new study subject note
argument-hint: <subject-name>
allowed-tools: [Read, Write, Edit, Glob, Grep, "Bash(date:*)"]
---

Create a new study subject tracking note.

## Instructions

Arguments: $ARGUMENTS

1. Ask for any missing information:
   - Subject name (required -- may be in $ARGUMENTS)
   - Institution (optional)
   - Semester (optional)

2. Check if `{{VAULT_FOLDER}}/study/<kebab-case-name>.md` already exists. If it does, inform the user and stop.

3. Create the file at `{{VAULT_FOLDER}}/study/<kebab-case-name>.md`:

```markdown
---
type: study
subject: "<subject>"
semester: "<semester>"
institution: "<institution>"
status: active
tags: [study]
---

# <Subject Name>

## Subject Info
- **Subject**: <subject>
- **Institution**: <institution>
- **Semester**: <semester>

## Schedule
| Day | Time |
|-----|------|
|     |      |

## Assignments
- [ ]

## Grades
| Assignment | Grade | Weight |
|------------|-------|--------|
|            |       |        |

## Notes


## Resources
- [[]]
```

4. Add a link to this subject in `{{VAULT_FOLDER}}/maps/Study MOC.md` under the appropriate section.
5. If today's daily note exists at `{{VAULT_FOLDER}}/daily/YYYY-MM-DD.md`, add a mention of the new study subject there.
6. Confirm creation and show the file path.
