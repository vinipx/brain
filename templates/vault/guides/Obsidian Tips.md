---
type: guide
tags: [guide, obsidian, tips]
---

# Obsidian Tips & Tricks

Practical tips for getting the most out of this vault in Obsidian.

## Graph View

The graph is color-coded by folder:
- **Blue** -- Daily notes
- **Green** -- Projects
- **Yellow** -- Presales
- **Purple** -- Coding references
- **Red** -- MOC index notes
- **Orange** -- Meetings
- **Cyan** -- People

**Tip**: A well-connected graph means your notes are properly cross-linked. If you see isolated nodes, add `[[links]]` to connect them.

## Quick Navigation

| Shortcut | Action |
|----------|--------|
| `Cmd+O` / `Ctrl+O` | Quick switcher -- type any note name to jump to it |
| `Cmd+Shift+F` / `Ctrl+Shift+F` | Search across all notes |
| `Cmd+P` / `Ctrl+P` | Command palette |
| `Cmd+E` / `Ctrl+E` | Toggle edit/preview mode |

**Tip**: Type `tag:#project` in search to find all project notes. Use `path:daily` to narrow to daily notes.

## Daily Notes in Obsidian

Click the **calendar icon** in the left sidebar (or use `Cmd+P` / `Ctrl+P` then "Open today's daily note") to create/open today's note. Obsidian is configured to:
- Save daily notes in `daily/`
- Use `_templates/daily-note` as the template
- Format filenames as `YYYY-MM-DD`

## Linking Best Practices

- **Always link projects** when mentioning them: `discussed [[Dashboard Redesign]] timeline`
- **Link people**: `met with [[John Smith]] about the proposal`
- **Link from daily notes**: Your daily note should be a hub that links to everything you touched that day
- **Use the MOCs**: When creating a new project/presale/coding note, add it to the relevant MOC

## Frontmatter Searches

Use Obsidian's search or the Properties panel to filter by metadata:

```
[status: active]                --> all active items
[type: project]                 --> all projects
[client: Acme Corp]             --> everything related to Acme Corp
[type: presale][status: active] --> active presales only
```

## Tags vs Links

- Use **tags** for categorization: `#project`, `#presale`, `#meeting`
- Use **links** for relationships: `[[Project Name]]`, `[[Person Name]]`
- Tags group similar notes; links create navigable connections

## Backlinks Panel

Open the right sidebar and check **Backlinks** for any note. This shows every other note that links to the current one. For example, opening a project note shows all daily notes and meetings that reference it -- a complete activity history without manual tracking.

## Templates

When creating notes manually in Obsidian (not via Claude Code commands):
1. Create a new note in the appropriate folder
2. Use `Cmd+P` / `Ctrl+P` then "Insert template"
3. Select the matching template (daily-note, meeting, project, presale, coding-project)
4. Fill in the frontmatter and content
