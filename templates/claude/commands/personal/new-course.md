---
description: Create a new course tracking note
argument-hint: <course-name>
allowed-tools: [Read, Write, Edit, Glob, Grep, "Bash(date:*)"]
---

Create a new course tracking note.

## Instructions

Arguments: $ARGUMENTS

1. Ask for any missing information:
   - Course name (required -- may be in $ARGUMENTS)
   - Platform (optional, e.g. Udemy, Coursera, YouTube)
   - Instructor (optional)

2. Check if `{{VAULT_FOLDER}}/courses/<kebab-case-name>.md` already exists. If it does, inform the user and stop.

3. Create the file at `{{VAULT_FOLDER}}/courses/<kebab-case-name>.md`:

```markdown
---
type: course
platform: "<platform>"
instructor: "<instructor>"
url: ""
start-date: "YYYY-MM-DD"
status: active
tags: [course]
---

# <Course Name>

## Course Info
- **Platform**: <platform>
- **Instructor**: <instructor>
- **URL**:

## Modules
1. [ ]
2. [ ]
3. [ ]

## Progress


## Notes


## Certificate
```

4. Add a link to this course in `{{VAULT_FOLDER}}/maps/Courses MOC.md` under the appropriate section.
5. If today's daily note exists at `{{VAULT_FOLDER}}/daily/YYYY-MM-DD.md`, add a mention of the new course there.
6. Confirm creation and show the file path.
