#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────────────────────────────────────
# Brain Setup — Obsidian + Claude Code Knowledge Management Scaffold
# https://github.com/vinipx/brain
# ──────────────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/templates"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

print_header() {
  echo ""
  echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}${BOLD}║           🧠 Brain — Knowledge Vault Setup       ║${NC}"
  echo -e "${CYAN}${BOLD}║       Obsidian + Claude Code Integration         ║${NC}"
  echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════╝${NC}"
  echo ""
}

print_step() {
  echo -e "${BLUE}[${1}/${TOTAL_STEPS}]${NC} ${BOLD}${2}${NC}"
}

print_success() {
  echo -e "  ${GREEN}✓${NC} ${1}"
}

print_warn() {
  echo -e "  ${YELLOW}!${NC} ${1}"
}

print_error() {
  echo -e "  ${RED}✗${NC} ${1}"
}

# ──────────────────────────────────────────────────────────────────────────────
# Validation
# ──────────────────────────────────────────────────────────────────────────────

validate_templates() {
  if [ ! -d "$TEMPLATES_DIR" ]; then
    print_error "Templates directory not found at: $TEMPLATES_DIR"
    print_error "Make sure you're running setup.sh from the cloned brain repository."
    exit 1
  fi
}

check_prerequisites() {
  local warnings=0

  if ! command -v claude &> /dev/null; then
    print_warn "Claude Code CLI not found. Install it from: https://claude.ai/code"
    print_warn "The vault will still work, but slash commands require Claude Code."
    warnings=$((warnings + 1))
  else
    print_success "Claude Code CLI found"
  fi

  if ! command -v obsidian &> /dev/null && [ ! -d "/Applications/Obsidian.app" ] && [ ! -d "$HOME/.local/share/obsidian" ]; then
    print_warn "Obsidian not detected. Download from: https://obsidian.md"
    print_warn "The vault files will still be created."
    warnings=$((warnings + 1))
  else
    print_success "Obsidian detected"
  fi

  return $warnings
}

# ──────────────────────────────────────────────────────────────────────────────
# Interactive prompts
# ──────────────────────────────────────────────────────────────────────────────

prompt_config() {
  echo -e "${BOLD}Configure your vault:${NC}"
  echo ""

  # Vault name
  read -rp "  Vault name [brain]: " VAULT_NAME
  VAULT_NAME="${VAULT_NAME:-brain}"

  # Install directory
  local default_dir="$HOME/Documents/$VAULT_NAME"
  read -rp "  Install directory [$default_dir]: " INSTALL_DIR
  INSTALL_DIR="${INSTALL_DIR:-$default_dir}"
  # Expand ~ if present
  INSTALL_DIR="${INSTALL_DIR/#\~/$HOME}"

  # Vault folder name (Obsidian root inside install dir)
  read -rp "  Obsidian vault folder name [vault]: " VAULT_FOLDER
  VAULT_FOLDER="${VAULT_FOLDER:-vault}"

  # Coding projects directory
  echo ""
  echo -e "  ${CYAN}Optional:${NC} Path to your coding projects directory."
  echo -e "  This enables the ${BOLD}/link-coding${NC} command to reference your repos."
  read -rp "  Coding projects directory (press Enter to skip): " CODING_DIR
  if [ -n "$CODING_DIR" ]; then
    CODING_DIR="${CODING_DIR/#\~/$HOME}"
    if [ ! -d "$CODING_DIR" ]; then
      print_warn "Directory '$CODING_DIR' does not exist. You can create it later."
    fi
  fi

  # Confirm
  echo ""
  echo -e "${BOLD}Summary:${NC}"
  echo -e "  Vault name:       ${GREEN}$VAULT_NAME${NC}"
  echo -e "  Install directory: ${GREEN}$INSTALL_DIR${NC}"
  echo -e "  Obsidian root:     ${GREEN}$INSTALL_DIR/$VAULT_FOLDER${NC}"
  if [ -n "$CODING_DIR" ]; then
    echo -e "  Coding projects:   ${GREEN}$CODING_DIR${NC}"
  else
    echo -e "  Coding projects:   ${YELLOW}skipped${NC}"
  fi
  echo ""

  read -rp "  Proceed with installation? [Y/n]: " CONFIRM
  CONFIRM="${CONFIRM:-Y}"
  if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Setup cancelled."
    exit 0
  fi
}

# ──────────────────────────────────────────────────────────────────────────────
# Installation
# ──────────────────────────────────────────────────────────────────────────────

TOTAL_STEPS=6

create_directories() {
  print_step 1 "Creating directory structure"

  local vault_root="$INSTALL_DIR/$VAULT_FOLDER"

  mkdir -p "$INSTALL_DIR/.claude/commands"
  mkdir -p "$vault_root/.obsidian/snippets"
  mkdir -p "$vault_root/_templates"
  mkdir -p "$vault_root/daily"
  mkdir -p "$vault_root/projects"
  mkdir -p "$vault_root/presales"
  mkdir -p "$vault_root/coding"
  mkdir -p "$vault_root/meetings"
  mkdir -p "$vault_root/people"
  mkdir -p "$vault_root/maps"
  mkdir -p "$vault_root/guides"

  print_success "Created vault at $vault_root"
  print_success "Created Claude commands at $INSTALL_DIR/.claude/commands"
}

install_obsidian_config() {
  print_step 2 "Installing Obsidian configuration"

  local obsidian_dir="$INSTALL_DIR/$VAULT_FOLDER/.obsidian"

  cp "$TEMPLATES_DIR/obsidian/app.json" "$obsidian_dir/"
  cp "$TEMPLATES_DIR/obsidian/appearance.json" "$obsidian_dir/"
  cp "$TEMPLATES_DIR/obsidian/core-plugins.json" "$obsidian_dir/"
  cp "$TEMPLATES_DIR/obsidian/daily-notes.json" "$obsidian_dir/"
  cp "$TEMPLATES_DIR/obsidian/graph.json" "$obsidian_dir/"
  cp "$TEMPLATES_DIR/obsidian/templates.json" "$obsidian_dir/"
  cp "$TEMPLATES_DIR/obsidian/snippets/tag-colors.css" "$obsidian_dir/snippets/"

  print_success "Obsidian config, graph colors, and CSS snippets installed"
}

install_vault_content() {
  print_step 3 "Installing vault templates, MOCs, and guides"

  local vault_root="$INSTALL_DIR/$VAULT_FOLDER"

  # Templates
  cp "$TEMPLATES_DIR/vault/_templates/"*.md "$vault_root/_templates/"
  print_success "5 note templates installed"

  # MOCs
  cp "$TEMPLATES_DIR/vault/maps/"*.md "$vault_root/maps/"
  print_success "3 Maps of Content installed"

  # Guides
  cp "$TEMPLATES_DIR/vault/guides/"*.md "$vault_root/guides/"
  print_success "5 guide files installed"
}

install_claude_commands() {
  print_step 4 "Installing Claude Code slash commands"

  local commands_dir="$INSTALL_DIR/.claude/commands"

  for cmd_file in "$TEMPLATES_DIR/claude/commands/"*.md; do
    local filename
    filename="$(basename "$cmd_file")"

    # Substitute placeholders
    sed \
      -e "s|{{VAULT_FOLDER}}|$VAULT_FOLDER|g" \
      -e "s|{{CODING_DIR}}|${CODING_DIR:-\$HOME/coding}|g" \
      "$cmd_file" > "$commands_dir/$filename"
  done

  print_success "7 slash commands installed: /daily, /add-meeting, /new-project, /new-presale, /link-coding, /vault-status, /weekly-review"
}

generate_claude_md() {
  print_step 5 "Generating CLAUDE.md"

  local coding_section=""
  if [ -n "$CODING_DIR" ]; then
    coding_section="## Coding Project References

Notes in \`coding/\` are **lightweight pointers** to repositories under \`$CODING_DIR\`. Each note costs ~20 tokens to read. The actual repo is only accessed when the user asks a specific question.

### Frontmatter Fields
- \`repo-path\` — absolute filesystem path to the repo
- \`org\` — organization or folder grouping
- \`repo\` — hosting platform (github, gitlab, etc.)

### Token Efficiency
- **DO NOT** read the full repo unless the user asks about it specifically
- **DO** read the \`coding/*.md\` reference note first — it has the summary
- **DO** follow \`repo-path\` only to answer specific questions
- When creating new coding refs, read only README + primary config file (package.json, pyproject.toml, etc.)"
  else
    coding_section="## Coding Project References

Notes in \`coding/\` are **lightweight pointers** to local repositories. Use \`/link-coding <path>\` to create reference notes.

### Token Efficiency
- **DO NOT** read the full repo unless the user asks about it specifically
- **DO** read the \`coding/*.md\` reference note first — it has the summary
- **DO** follow \`repo-path\` only to answer specific questions"
  fi

  cat > "$INSTALL_DIR/CLAUDE.md" << CLAUDEEOF
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

An **Obsidian vault** for knowledge management. All content is Markdown inside \`$VAULT_FOLDER/\`. There is no build system, test runner, or linting pipeline.

## Vault Structure

\`\`\`
$VAULT_FOLDER/
├── _templates/       # Note templates — do not edit directly, use slash commands
├── daily/            # Daily notes: YYYY-MM-DD.md
├── projects/         # Work project tracking notes
├── presales/         # Presale engagement notes
├── coding/           # Reference notes for coding repositories
├── meetings/         # Standalone meeting notes (for significant meetings)
├── people/           # Person/contact notes for cross-referencing
├── maps/             # MOC (Map of Content) index notes — navigation hubs
├── guides/           # How-to guides for using this vault with Obsidian + Claude Code
└── .obsidian/        # App config — do not edit unless updating plugin settings
\`\`\`

## Conventions

- **Frontmatter**: Every note MUST have YAML frontmatter with at least \`type\` and \`tags\` fields
- **Links**: Use Obsidian wiki-links \`[[Note Title]]\`. Always link to related projects, people, meetings
- **Tags**: Use frontmatter \`tags: [tag1, tag2]\`. Common tags: daily, meeting, project, presale, coding, moc, person, weekly-review
- **Status values**: active, on-hold, completed, cancelled, won, lost
- **Filenames**: kebab-case for most notes, \`YYYY-MM-DD\` for daily notes, \`YYYY-WNN-review\` for weekly reviews
- **Type values**: daily, meeting, project, presale, coding-project, person, moc, weekly-review

$coding_section

## When Creating Notes

1. Use the appropriate template structure (see \`_templates/\`)
2. Always add cross-reference wiki-links to related notes
3. Update the relevant MOC in \`maps/\` (Projects MOC, Presales MOC, or Coding MOC)
4. For daily notes, name them \`YYYY-MM-DD.md\` in \`daily/\`
5. For meetings within a daily note, use inline headings; for major meetings, create a separate note in \`meetings/\`
6. For new people/contacts, create a note in \`people/\`

## When Searching / Navigating

- Use \`type\` frontmatter to filter notes: \`type: project\`, \`type: presale\`, \`type: daily\`, etc.
- Grep for \`status: active\` to find active items
- MOC notes in \`maps/\` are the best entry points for browsing by domain
- Daily notes are sorted chronologically by filename

## Slash Commands

Available project-level commands in \`.claude/commands/\`:

| Command | Purpose |
|---------|---------|
| \`/daily\` | Create or open today's daily note |
| \`/add-meeting\` | Record a meeting in today's daily or as standalone |
| \`/new-project\` | Scaffold a project note, update Projects MOC |
| \`/new-presale\` | Scaffold a presale engagement, create people notes |
| \`/link-coding\` | Create a reference note from a local repository |
| \`/vault-status\` | Dashboard: recent activity, active projects/presales, open tasks |
| \`/weekly-review\` | Summarize the past 5 work days |
CLAUDEEOF

  print_success "CLAUDE.md generated with vault-specific paths"
}

print_completion() {
  print_step 6 "Setup complete!"

  echo ""
  echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}${BOLD}║              Setup Complete!                      ║${NC}"
  echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "${BOLD}Next steps:${NC}"
  echo ""
  echo -e "  1. ${CYAN}Open in Obsidian:${NC}"
  echo -e "     Open Obsidian → Open folder as vault → select:"
  echo -e "     ${GREEN}$INSTALL_DIR/$VAULT_FOLDER${NC}"
  echo ""
  echo -e "  2. ${CYAN}Enable CSS snippet:${NC}"
  echo -e "     Settings → Appearance → CSS snippets → enable ${BOLD}tag-colors${NC}"
  echo ""
  echo -e "  3. ${CYAN}Start Claude Code:${NC}"
  echo -e "     ${GREEN}cd $INSTALL_DIR && claude${NC}"
  echo ""
  echo -e "  4. ${CYAN}Create your first daily note:${NC}"
  echo -e "     Type ${BOLD}/daily${NC} in Claude Code"
  echo ""
  if [ -n "$CODING_DIR" ]; then
    echo -e "  5. ${CYAN}Link a coding project:${NC}"
    echo -e "     Type ${BOLD}/link-coding <repo-name>${NC} in Claude Code"
    echo ""
  fi
  echo -e "${BOLD}Installed:${NC}"
  echo -e "  • 9 vault folders (daily, projects, presales, coding, meetings, people, maps, guides, _templates)"
  echo -e "  • 5 note templates"
  echo -e "  • 3 Maps of Content (navigation hubs)"
  echo -e "  • 5 how-to guides"
  echo -e "  • 7 Claude Code slash commands"
  echo -e "  • Obsidian config (graph colors, daily notes, templates, CSS snippet)"
  echo -e "  • CLAUDE.md (Claude Code context file)"
  echo ""
}

# ──────────────────────────────────────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────────────────────────────────────

main() {
  print_header
  validate_templates

  echo -e "${BOLD}Checking prerequisites...${NC}"
  check_prerequisites || true
  echo ""

  prompt_config
  echo ""

  create_directories
  install_obsidian_config
  install_vault_content
  install_claude_commands
  generate_claude_md
  print_completion
}

main "$@"
