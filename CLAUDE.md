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
│   │   ├── shared/       # Configs for all architectures
│   │   ├── professional/ # Professional graph colors, tag colors
│   │   ├── personal/     # Personal graph colors, tag colors
│   │   └── both/         # Combined graph colors, tag colors
│   ├── vault/            # Vault content (templates, MOCs, guides)
│   │   ├── _templates/
│   │   │   ├── shared/       # daily-note.md (minimal version)
│   │   │   ├── professional/ # project, commercial, coding-project, meeting
│   │   │   └── personal/     # personal-project, study, course, health-log, finance, family-event, hobby, daily-note (extended)
│   │   ├── maps/
│   │   │   ├── professional/ # Projects, Commercials, Coding MOCs
│   │   │   └── personal/     # Projects, Study, Courses, Health, Finance, Family, Hobbies MOCs
│   │   └── guides/
│   │       ├── shared/       # Claude Code Tips, Obsidian Tips
│   │       ├── professional/ # Getting Started, Slash Commands Reference, Use Cases
│   │       ├── personal/     # Getting Started, Slash Commands Reference, Use Cases
│   │       └── both/         # Getting Started, Slash Commands Reference, Use Cases
│   └── claude/
│       └── commands/
│           ├── shared/       # 5 architecture-agnostic commands (daily, challenge, ghost, trace, connect)
│           ├── professional/ # 14 professional commands (entity + arch-variant)
│           ├── personal/     # 17 personal commands (entity + arch-variant)
│           └── both/         # 10 combined-mode variants (scan all folders)
├── .gitignore
└── LICENSE
```

## Architecture Branching

setup.sh offers 3 architecture choices:

- **Professional**: projects, commercials, coding, meetings, people
- **Personal**: projects, study, courses, finances, health, family, hobby, people
- **Both**: all folders from both architectures combined

Templates, MOCs, commands, guides, and Obsidian configs are organized into `shared/`, `professional/`, `personal/`, and `both/` subdirectories. setup.sh selects and copies the right files based on the user's choice.

## How setup.sh Works

1. Prompts user for: architecture (professional/personal/both), vault name, install directory, vault folder name, coding projects dir (professional/both only)
2. Creates directory structure at the install location based on architecture
3. Copies shared + architecture-specific template files from `templates/`
4. Substitutes `{{VAULT_FOLDER}}` and `{{CODING_DIR}}` placeholders in command files
5. Generates a `CLAUDE.md` at the install location with architecture-specific content

## Conventions

- Command templates use `{{VAULT_FOLDER}}` where the vault folder name goes
- Command templates use `{{CODING_DIR}}` where the coding directory path goes
- Obsidian configs are static (no substitution needed)
- Vault content files (templates, MOCs, guides) are copied as-is
- Guide files use generic examples (no user-specific content)
- Each template type has `shared/` (all architectures), `professional/`, `personal/`, and optionally `both/` subdirectories

## When Modifying

- To add a new slash command: create a `.md` file in the appropriate `templates/claude/commands/{shared,professional,personal}/` directory
- To add a new note template: create a `.md` file in `templates/vault/_templates/{shared,professional,personal}/`
- To add a new guide: create a `.md` file in the appropriate `templates/vault/guides/{shared,professional,personal,both}/` directory
- To add a new MOC: create a `.md` file in `templates/vault/maps/{professional,personal}/`
- To change Obsidian defaults: edit the JSON/CSS files in `templates/obsidian/{shared,professional,personal,both}/`
- Always test changes by running `./setup.sh` for each architecture and verifying the output
