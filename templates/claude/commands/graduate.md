---
description: Extract undeveloped ideas from daily notes and promote them into standalone files
allowed-tools: [Read, Write, Glob, Grep, Edit, "Bash(date:*)"]
---

Scan recent daily notes for ideas that deserve their own note.

## Instructions

1. Determine today's date and calculate the date 14 days ago.
2. Read all daily notes from the last 14 days in `{{VAULT_FOLDER}}/daily/`.
3. For each daily note, scan for:
   - Ideas or insights that go beyond a simple task or meeting record.
   - Observations, hypotheses, or questions that could develop further.
   - Recurring themes that appear across multiple days.
   - Notes that are long enough to suggest depth but lack their own file.
   - Anything prefixed with "idea:", "thought:", "what if", "I wonder", or similar markers.

4. For each idea worth graduating, evaluate:
   - Is it mentioned more than once across different days? (stronger candidate)
   - Does it connect to existing projects, presales, or coding work?
   - Is it developed enough to stand on its own, or does it need more context?

5. Present the candidates to the user before creating files:

```
## Ideas Ready to Graduate

### 1. <Idea Title>
- **First appeared**: [[YYYY-MM-DD]] — "<original phrasing>"
- **Also mentioned**: [[YYYY-MM-DD]], [[YYYY-MM-DD]]
- **Core claim**: <the idea distilled into one sentence>
- **Connections**: [[project]], [[topic]]
- **Maturity**: Ready to develop / Needs more thinking

### 2. ...
```

6. Ask the user which ideas they want to promote. For each approved idea, create a standalone note at `{{VAULT_FOLDER}}/projects/<kebab-case-title>.md`:

```markdown
---
type: project
status: active
origin: graduated from daily notes
tags: [project, idea]
created: "YYYY-MM-DD"
---

# <Idea Title>

## Core Claim
<the idea in 1-2 sentences>

## Context
<where this came from — daily notes, conversations, observations>
- First noted in [[YYYY-MM-DD]]: "<original context>"

## Development
<expanded thinking, implications, next steps>

## Connections
- [[related note]]
- [[related project]]

## Open Questions
- <what needs to be resolved or explored>
```

7. Update the **Projects MOC** to include the new notes.
8. Add a wiki-link back to the new note from the original daily notes under `## Links Created Today`.
9. Summarize what was created.
