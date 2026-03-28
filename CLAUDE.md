# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A **scaffolding tool** that generates Obsidian vaults integrated with Claude Code. This is the template repository — not a vault itself.

## Repository Structure

```
brain/
├── setup.sh              # Interactive setup script (main entry point)
├── README.md             # User documentation
├── templates/
│   ├── obsidian/         # Obsidian config files (JSON, CSS)
│   ├── vault/            # Vault content (templates, MOCs, guides)
│   │   ├── _templates/   # 5 note templates
│   │   ├── maps/         # 3 MOC index notes
│   │   └── guides/       # 5 how-to guides
│   └── claude/
│       └── commands/     # 19 slash command templates (use {{VAULT_FOLDER}} placeholders)
├── .gitignore
└── LICENSE
```

## How setup.sh Works

1. Prompts user for: vault name, install directory, vault folder name, coding projects dir
2. Creates directory structure at the install location
3. Copies template files from `templates/`
4. Substitutes `{{VAULT_FOLDER}}` and `{{CODING_DIR}}` placeholders in command files
5. Generates a `CLAUDE.md` at the install location with user-specific paths

## Conventions

- Command templates use `{{VAULT_FOLDER}}` where the vault folder name goes
- Command templates use `{{CODING_DIR}}` where the coding directory path goes
- Obsidian configs are static (no substitution needed)
- Vault content files (templates, MOCs, guides) are copied as-is
- Guide files use generic examples (no user-specific content)

## When Modifying

- To add a new slash command: create a `.md` file in `templates/claude/commands/`, use `{{VAULT_FOLDER}}` for vault paths
- To add a new note template: create a `.md` file in `templates/vault/_templates/`
- To add a new guide: create a `.md` file in `templates/vault/guides/`
- To change Obsidian defaults: edit the JSON files in `templates/obsidian/`
- Always test changes by running `./setup.sh` and verifying the output
