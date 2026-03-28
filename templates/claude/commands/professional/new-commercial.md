---
description: Create a commercial engagement note and update the Commercials MOC
argument-hint: <commercial-name>
allowed-tools: [Read, Write, Glob, Grep, Edit]
---

Create a new commercial engagement tracking note.

## Instructions

Arguments: $ARGUMENTS

1. Ask for any missing information:
   - Engagement/opportunity name (may be in $ARGUMENTS)
   - Client name
   - Primary contact
   - Brief description

2. Create file at `{{VAULT_FOLDER}}/commercials/<kebab-case-name>.md`:

```markdown
---
type: commercial
status: active
client: "<client>"
contact: "<contact>"
start-date: "YYYY-MM-DD"
value: ""
probability: ""
tags: [commercial]
---

# Commercial: <Name>

## Client
<client details>

## Engagement Summary
<description>

## Key Contacts
- [[<contact>]]

## Timeline
| Date | Event | Notes |
|------|-------|-------|
| YYYY-MM-DD | Initiated | |

## Deliverables
- [ ]

## Related
- **Project** (if converted): [[]]
- **Meetings**: [[]]

## Notes
```

3. Add a link in `{{VAULT_FOLDER}}/maps/Commercials MOC.md` under **Active**.
4. Create a person note in `{{VAULT_FOLDER}}/people/<contact-name>.md` if one does not already exist, using this structure:

```markdown
---
type: person
company: "<client>"
role: ""
tags: [person]
---

# <Contact Name>

## Contact Info

## Notes
```

5. Confirm creation.
