---
description: Track how a specific idea has evolved over time across your vault
argument-hint: <topic>
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Trace the evolution of an idea across my vault.

## Instructions

Arguments: $ARGUMENTS

1. If $ARGUMENTS is empty, ask the user: "What topic or idea would you like me to trace?"

2. Search the entire vault for mentions of the topic:
   - Grep `{{VAULT_FOLDER}}/` recursively for the topic and related terms.
   - Search across all note types: daily notes, projects, commercials, meetings, people, coding refs.
   - Also search for wiki-links containing the topic (`[[*topic*]]`).

3. For each matching note, extract:
   - **Date**: From frontmatter or filename.
   - **Context**: The paragraph or section where the topic appears.
   - **Note type**: daily, project, meeting, etc.
   - **Connections**: Other wiki-links in the same section.

4. Sort all mentions **chronologically** (earliest to latest).

5. Analyze the arc:
   - When did the idea first appear?
   - How did the language or framing change over time?
   - What events or meetings influenced it?
   - What is it connected to now that it wasn't at the start?
   - Is the idea growing, stalling, or shifting direction?

6. Present the trace:

```
## Trace: <Topic>

### Timeline

**First mention**: YYYY-MM-DD in [[note]]
> <original context>

**YYYY-MM-DD** — [[note]] (type)
> <how it appeared here, what changed>

**YYYY-MM-DD** — [[note]] (type)
> <evolution>

... (continue chronologically)

**Most recent**: YYYY-MM-DD in [[note]]
> <current state>

### Evolution Summary
- **Origin**: <how the idea started>
- **Key shifts**: <turning points, decisions, or meetings that changed direction>
- **Current state**: <where the idea stands now>
- **Connections**: <what it's linked to — projects, people, other ideas>

### Observations
- <patterns you notice in how this idea evolved>
- <suggestions: is this ready to become a project? needs more exploration? contradicts something?>
```

7. Use wiki-links throughout so the user can click into any note for full context.
