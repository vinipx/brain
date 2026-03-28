---
description: Summarize vault state — notes per folder across all work and personal domains, active items, open tasks
allowed-tools: [Read, Glob, Grep, "Bash(ls:*)", "Bash(wc:*)", "Bash(date:*)"]
---

Provide a summary of the Obsidian vault's current state across all domains.

## Instructions

1. Count notes per folder: daily, projects, commercials, coding, meetings, people, study, courses, health, finances, family, hobby.
2. Read the 3 most recent daily notes (sorted by filename descending) and summarize key activities, meetings, and tasks.
3. Find all notes with `status: active` in frontmatter across projects, commercials, study, and courses. List them.
4. Scan recent notes for open tasks (`- [ ]`) and list them with their source note.
5. Check if today's daily note exists — if not, suggest creating one with `/daily`.
6. Present a clean summary in this format:

```
## Vault Summary

**Work Notes**: X daily | Y projects | Z commercials | W coding refs | V meetings | U people
**Personal Notes**: A study | B courses | C health | D finances | E family | F hobby

### Recent Activity
- [last 3 daily notes summarized briefly]

---

### Work

#### Active Projects
- [[project]] — brief status

#### Active Commercials
- [[commercial]] — client, brief status

---

### Personal

#### Active Studies
- [[subject]] — topic, progress

#### Active Courses
- [[course]] — platform, progress

#### Health Tracking
- <most recent health entries or habit streaks>

#### Financial Status
- <active budgets, recent entries>

---

### Open Tasks
- [ ] task description (from [[source note]])

### Suggestions
- [any maintenance suggestions: missing daily note, orphan notes, stale projects, courses not updated recently, commercial gone cold, health tracking gaps, etc.]
```
