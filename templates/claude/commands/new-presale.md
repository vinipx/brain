---
description: Create a presale engagement note and update the Presales MOC
argument-hint: <presale-name>
allowed-tools: [Read, Write, Glob, Grep, Edit]
---

Create a new presale engagement tracking note.

## Instructions

Arguments: $ARGUMENTS

1. Ask for any missing information:
   - Engagement/opportunity name (may be in $ARGUMENTS)
   - Client name
   - Primary contact
   - Brief description

2. Create file at `{{VAULT_FOLDER}}/presales/<kebab-case-name>.md`:

```markdown
---
type: presale
status: active
client: "<client>"
contact: "<contact>"
start-date: "YYYY-MM-DD"
value: ""
probability: ""
tags: [presale]
---

# Presale: <Name>

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

3. Add a link in `{{VAULT_FOLDER}}/maps/Presales MOC.md` under **Active**.
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
