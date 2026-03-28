# Brain

A scaffolding tool that sets up an **Obsidian vault** integrated with **Claude Code** for knowledge management. Run a single script to get a structured vault with daily notes, project tracking, presale management, coding project references, and 7 Claude Code slash commands.

## What You Get

```
your-vault/
├── CLAUDE.md                    # Claude Code context (auto-generated)
├── .claude/commands/            # 7 slash commands for Claude Code
└── vault/                       # Obsidian vault root
    ├── _templates/              # 5 note templates (daily, meeting, project, presale, coding)
    ├── daily/                   # Daily notes (YYYY-MM-DD.md)
    ├── projects/                # Work project tracking
    ├── presales/                # Presale engagement tracking
    ├── coding/                  # Lightweight pointers to local code repos
    ├── meetings/                # Standalone meeting notes
    ├── people/                  # Contact/person notes
    ├── maps/                    # Map of Content index notes (navigation hubs)
    ├── guides/                  # How-to guides for the system
    └── .obsidian/               # Pre-configured (graph colors, templates, CSS snippets)
```

## Prerequisites

- [Obsidian](https://obsidian.md) (free)
- [Claude Code](https://claude.ai/code) (for slash commands)

## Quick Start

```bash
git clone https://github.com/vinipx/brain.git
cd brain
./setup.sh
```

The script prompts for:

| Prompt | Default | Description |
|--------|---------|-------------|
| Vault name | `brain` | Name for your knowledge base |
| Install directory | `~/Documents/brain` | Where to create the vault |
| Vault folder name | `vault` | Obsidian root folder inside install dir |
| Coding projects dir | *(skip)* | Optional path to your coding repos |

After setup:

1. Open Obsidian -> "Open folder as vault" -> select the vault folder
2. Enable CSS snippet: Settings -> Appearance -> CSS snippets -> enable `tag-colors`
3. Start Claude Code: `cd ~/Documents/brain && claude`
4. Type `/daily` to create your first daily note

## Slash Commands

All commands run inside Claude Code from the vault's root directory.

| Command | What it does |
|---------|-------------|
| `/daily` | Create or open today's daily note |
| `/add-meeting` | Record a meeting (appends to daily note or creates standalone) |
| `/new-project` | Scaffold a project note with metadata, update Projects MOC |
| `/new-presale` | Create a presale engagement, auto-create contact notes |
| `/link-coding` | Create a reference note from a local coding repo |
| `/vault-status` | Dashboard: recent activity, active work, open tasks |
| `/weekly-review` | Summarize the past 5 work days |

## How It Works

### Notes connect through wiki-links

```
Daily Note --> Meeting --> Project --> Coding Repo
     |                       |
  People               Presale
```

Every note has YAML frontmatter with `type` and `tags` fields. Claude Code reads `CLAUDE.md` to understand the vault structure and conventions.

### Maps of Content (MOC)

Three index notes in `maps/` serve as navigation hubs:
- **Projects MOC** — Active, On Hold, Completed projects
- **Presales MOC** — Active, Won, Lost engagements
- **Coding MOC** — References to local repositories

### Coding project references

Notes in `coding/` are lightweight pointers (~20 tokens each) with a `repo-path` field. Claude only reads the actual repository when you ask a specific question, keeping token usage minimal.

### Graph view

The Obsidian graph is color-coded by folder:

| Color | Folder |
|-------|--------|
| Blue | daily |
| Green | projects |
| Yellow | presales |
| Purple | coding |
| Red | maps |
| Orange | meetings |
| Cyan | people |

## Customization

### Adding your own templates

Add `.md` files to `vault/_templates/`. Use Obsidian's `{{date}}` and `{{title}}` placeholders.

### Adding slash commands

Add `.md` files to `.claude/commands/`. Use YAML frontmatter for `description` and `allowed-tools`. See existing commands for the pattern.

### CSS snippets

Add `.css` files to `vault/.obsidian/snippets/`. Enable them in Obsidian Settings -> Appearance -> CSS snippets.

## Architecture

```
setup.sh reads from:                  and creates:

templates/                            ~/Documents/brain/
├── obsidian/     ─── configs ───>    └── vault/.obsidian/
├── vault/        ─── content ───>        ├── _templates/
│   ├── _templates/                       ├── maps/
│   ├── maps/                             └── guides/
│   └── guides/
└── claude/       ── commands ──>     └── .claude/commands/
    └── commands/
                                      CLAUDE.md  (generated with your paths)
```

Placeholders (`{{VAULT_FOLDER}}`, `{{CODING_DIR}}`) in command templates are substituted with your values during setup.

## License

MIT
