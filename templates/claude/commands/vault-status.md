---
description: Summarize vault state — recent notes, active projects, upcoming items, open tasks
allowed-tools: [Read, Glob, Grep, "Bash(ls:*)", "Bash(wc:*)", "Bash(date:*)"]
---

Provide a summary of the Obsidian vault's current state.

## Instructions

1. Count notes per folder: daily, projects, presales, coding, meetings, people.
2. Read the 3 most recent daily notes (sorted by filename descending) and summarize key meetings and tasks.
3. Find all notes with `status: active` in frontmatter across projects and presales. List them.
4. Scan recent notes for open tasks (`- [ ]`) and list them with their source note.
5. Check if today's daily note exists — if not, suggest creating one with `/daily`.
6. Present a clean summary in this format:

```
## Vault Summary

**Notes**: X daily | Y projects | Z presales | W coding refs | V meetings | U people

### Recent Activity
- [last 3 daily notes summarized briefly]

### Active Projects
- [[project]] — brief status

### Active Presales
- [[presale]] — client, brief status

### Open Tasks
- [ ] task description (from [[source note]])

### Suggestions
- [any maintenance suggestions: missing daily note, orphan notes, stale projects, etc.]
```
