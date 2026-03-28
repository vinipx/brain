---
type: guide
tags: [guide, commands, claude-code]
---

# Slash Commands Reference

All commands are run inside Claude Code from your vault's root directory.

## /daily

**Creates or opens today's daily note.**

```
/daily                    --> Create today's note (or show it if it exists)
/daily Sprint Planning    --> Create today's note with a "Sprint Planning" meeting pre-filled
```

- Creates `daily/YYYY-MM-DD.md` with sections for Meetings, Tasks, Notes
- If the note already exists, reads it and asks what to add

## /add-meeting

**Records a meeting outcome.**

```
/add-meeting Design Review
/add-meeting
```

- Asks for attendees, discussion points, decisions, action items
- Appends to today's daily note under `## Meetings`
- For substantial meetings (many decisions/actions), also creates a standalone note in `meetings/`
- Automatically creates `people/` notes for new attendees
- Cross-links to related projects and presales

## /new-project

**Scaffolds a new project tracking note.**

```
/new-project Dashboard Redesign
/new-project
```

- Asks for client, description, priority
- Creates `projects/<kebab-name>.md` with full template
- Adds a link to `maps/Projects MOC.md`
- Mentions the project in today's daily note if it exists

## /new-presale

**Creates a presale engagement note.**

```
/new-presale Acme Corp Test Automation
/new-presale
```

- Asks for client, contact, description
- Creates `presales/<kebab-name>.md` with timeline table
- Adds to `maps/Presales MOC.md`
- Creates `people/` notes for contacts

## /link-coding

**Creates a vault reference note from a coding repository.**

```
/link-coding my-project
/link-coding /path/to/repo
```

- Searches your configured coding directory for the repo
- Reads README and config files to detect language, framework, description
- Creates `coding/<repo-name>.md` with extracted metadata
- Updates `maps/Coding MOC.md`

## /vault-status

**Dashboard showing current vault state.**

```
/vault-status
```

- Counts notes per folder
- Summarizes the 3 most recent daily notes
- Lists all active projects and presales
- Shows open tasks across notes
- Suggests maintenance actions (missing daily note, stale projects)

## /weekly-review

**Generates a weekly summary.**

```
/weekly-review
```

- Reads the last 5 daily notes
- Aggregates meetings, completed tasks, open tasks, project/presale activity
- Creates `daily/YYYY-WNN-review.md`
