---
type: guide
tags: [guide, getting-started]
---

# Getting Started

How to use this Obsidian vault with Claude Code for daily knowledge management.

## Your First Day

1. Open a terminal in your vault's root directory (where `CLAUDE.md` lives)
2. Run `claude` to start Claude Code
3. Type `/daily` — Claude creates today's daily note with a ready-to-fill structure
4. Open Obsidian and navigate to `daily/` to see your note

## Core Workflow

```
Morning:  /daily            --> Create today's note
Meeting:  /add-meeting      --> Record outcomes, decisions, action items
New work: /new-project      --> Track a new project assignment
Presale:  /new-presale      --> Log a new client engagement
Friday:   /weekly-review    --> Summarize your week
Anytime:  /vault-status     --> See what's active and what needs attention
```

## How Notes Connect

Everything links together through `[[wiki-links]]`:

```
Daily Note --> mentions a Meeting --> references a Project --> links to a Coding Repo
     |                                       |
  Person notes                      Presale (if originated from one)
```

The **Maps of Content** (MOC) in `maps/` are your navigation hubs. Start there when browsing.

## Where Things Live

| What you're looking for | Where to find it |
|------------------------|-----------------|
| Today's notes | `daily/YYYY-MM-DD.md` |
| A project | `projects/` or `maps/Projects MOC` |
| A presale | `presales/` or `maps/Presales MOC` |
| A coding repo reference | `coding/` or `maps/Coding MOC` |
| A person/contact | `people/` |
| A standalone meeting | `meetings/` |
| Templates | `_templates/` (don't edit — used by commands) |
