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

# Globals set by prompt_config
ARCHITECTURE=""
VAULT_NAME=""
INSTALL_DIR=""
VAULT_FOLDER=""
CODING_DIR=""

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

  # Architecture choice
  echo -e "  ${BOLD}Choose your vault architecture:${NC}"
  echo -e "    ${CYAN}1)${NC} Professional — projects, commercials, coding, meetings, people"
  echo -e "    ${CYAN}2)${NC} Personal — projects, study, courses, finances, health, family, hobby, people"
  echo -e "    ${CYAN}3)${NC} Both — combined personal and professional vault"
  echo ""
  read -rp "  Architecture [1]: " ARCH_CHOICE
  case "${ARCH_CHOICE:-1}" in
    1) ARCHITECTURE="professional" ;;
    2) ARCHITECTURE="personal" ;;
    3) ARCHITECTURE="both" ;;
    *)
      print_error "Invalid choice. Please enter 1, 2, or 3."
      exit 1
      ;;
  esac
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

  # Coding projects directory (only for professional and both)
  CODING_DIR=""
  if [ "$ARCHITECTURE" = "professional" ] || [ "$ARCHITECTURE" = "both" ]; then
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
  fi

  # Confirm
  echo ""
  echo -e "${BOLD}Summary:${NC}"
  echo -e "  Architecture:      ${GREEN}$ARCHITECTURE${NC}"
  echo -e "  Vault name:        ${GREEN}$VAULT_NAME${NC}"
  echo -e "  Install directory: ${GREEN}$INSTALL_DIR${NC}"
  echo -e "  Obsidian root:     ${GREEN}$INSTALL_DIR/$VAULT_FOLDER${NC}"
  if [ "$ARCHITECTURE" = "professional" ] || [ "$ARCHITECTURE" = "both" ]; then
    if [ -n "$CODING_DIR" ]; then
      echo -e "  Coding projects:   ${GREEN}$CODING_DIR${NC}"
    else
      echo -e "  Coding projects:   ${YELLOW}skipped${NC}"
    fi
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
  mkdir -p "$vault_root/maps"
  mkdir -p "$vault_root/guides"
  mkdir -p "$vault_root/_analytics/sessions"

  # Architecture-specific folders
  if [ "$ARCHITECTURE" = "professional" ] || [ "$ARCHITECTURE" = "both" ]; then
    mkdir -p "$vault_root/projects"
    mkdir -p "$vault_root/commercials"
    mkdir -p "$vault_root/coding"
    mkdir -p "$vault_root/meetings"
    mkdir -p "$vault_root/people"
  fi

  if [ "$ARCHITECTURE" = "personal" ] || [ "$ARCHITECTURE" = "both" ]; then
    mkdir -p "$vault_root/projects"
    mkdir -p "$vault_root/study"
    mkdir -p "$vault_root/courses"
    mkdir -p "$vault_root/finances"
    mkdir -p "$vault_root/health"
    mkdir -p "$vault_root/family"
    mkdir -p "$vault_root/hobby"
    mkdir -p "$vault_root/people"
  fi

  print_success "Created vault at $vault_root"
  print_success "Created Claude commands at $INSTALL_DIR/.claude/commands"
}

install_obsidian_config() {
  print_step 2 "Installing Obsidian configuration"

  local obsidian_dir="$INSTALL_DIR/$VAULT_FOLDER/.obsidian"

  # Shared configs (same for all architectures)
  cp "$TEMPLATES_DIR/obsidian/shared/"*.json "$obsidian_dir/"

  # Architecture-specific configs
  if [ "$ARCHITECTURE" = "both" ]; then
    cp "$TEMPLATES_DIR/obsidian/both/"*.json "$obsidian_dir/"
    cp "$TEMPLATES_DIR/obsidian/both/snippets/tag-colors.css" "$obsidian_dir/snippets/"
    cp "$TEMPLATES_DIR/obsidian/both/snippets/folder-styles.css" "$obsidian_dir/snippets/"
  else
    cp "$TEMPLATES_DIR/obsidian/$ARCHITECTURE/"*.json "$obsidian_dir/"
    cp "$TEMPLATES_DIR/obsidian/$ARCHITECTURE/snippets/tag-colors.css" "$obsidian_dir/snippets/"
    cp "$TEMPLATES_DIR/obsidian/$ARCHITECTURE/snippets/folder-styles.css" "$obsidian_dir/snippets/"
  fi

  print_success "Obsidian config, graph colors, and CSS snippets installed"
}

install_vault_content() {
  print_step 3 "Installing vault templates, MOCs, and guides"

  local vault_root="$INSTALL_DIR/$VAULT_FOLDER"
  local template_count=0
  local moc_count=0

  # Templates — shared first, then architecture-specific
  if [ "$ARCHITECTURE" = "both" ]; then
    # For "both", use the personal extended daily note (richer template)
    cp "$TEMPLATES_DIR/vault/_templates/personal/daily-note.md" "$vault_root/_templates/"
    cp "$TEMPLATES_DIR/vault/_templates/professional/"*.md "$vault_root/_templates/"
    cp "$TEMPLATES_DIR/vault/_templates/personal/"*.md "$vault_root/_templates/"
    template_count=$(ls -1 "$vault_root/_templates/"*.md 2>/dev/null | wc -l | tr -d ' ')
  elif [ "$ARCHITECTURE" = "personal" ]; then
    # Personal daily note overrides the shared one
    cp "$TEMPLATES_DIR/vault/_templates/personal/"*.md "$vault_root/_templates/"
    template_count=$(ls -1 "$vault_root/_templates/"*.md 2>/dev/null | wc -l | tr -d ' ')
  else
    # Professional uses the shared daily note + professional templates
    cp "$TEMPLATES_DIR/vault/_templates/shared/"*.md "$vault_root/_templates/"
    cp "$TEMPLATES_DIR/vault/_templates/professional/"*.md "$vault_root/_templates/"
    template_count=$(ls -1 "$vault_root/_templates/"*.md 2>/dev/null | wc -l | tr -d ' ')
  fi
  print_success "$template_count note templates installed"

  # MOCs
  if [ "$ARCHITECTURE" = "both" ]; then
    cp "$TEMPLATES_DIR/vault/maps/professional/"*.md "$vault_root/maps/"
    cp "$TEMPLATES_DIR/vault/maps/personal/"*.md "$vault_root/maps/"
  else
    cp "$TEMPLATES_DIR/vault/maps/$ARCHITECTURE/"*.md "$vault_root/maps/"
  fi
  moc_count=$(ls -1 "$vault_root/maps/"*.md 2>/dev/null | wc -l | tr -d ' ')
  print_success "$moc_count Maps of Content installed"

  # Guides — shared + architecture-specific
  cp "$TEMPLATES_DIR/vault/guides/shared/"*.md "$vault_root/guides/"
  if [ "$ARCHITECTURE" = "both" ]; then
    cp "$TEMPLATES_DIR/vault/guides/both/"*.md "$vault_root/guides/"
  else
    cp "$TEMPLATES_DIR/vault/guides/$ARCHITECTURE/"*.md "$vault_root/guides/"
  fi
  local guide_count
  guide_count=$(ls -1 "$vault_root/guides/"*.md 2>/dev/null | wc -l | tr -d ' ')
  print_success "$guide_count guide files installed"

  # Analytics — token pricing config
  cp "$TEMPLATES_DIR/vault/_templates/shared/token-pricing.md" "$vault_root/_analytics/"
  print_success "Analytics folder with token pricing config installed"
}

install_claude_commands() {
  print_step 4 "Installing Claude Code slash commands"

  local commands_dir="$INSTALL_DIR/.claude/commands"

  # Helper: copy and substitute placeholders in command files from a source dir
  install_commands_from() {
    local src_dir="$1"
    for cmd_file in "$src_dir/"*.md; do
      [ -f "$cmd_file" ] || continue
      local filename
      filename="$(basename "$cmd_file")"
      sed \
        -e "s|{{VAULT_FOLDER}}|$VAULT_FOLDER|g" \
        -e "s|{{CODING_DIR}}|${CODING_DIR:-\$HOME/coding}|g" \
        "$cmd_file" > "$commands_dir/$filename"
    done
  }

  # Shared commands (always installed)
  install_commands_from "$TEMPLATES_DIR/claude/commands/shared"

  # Architecture-specific commands
  if [ "$ARCHITECTURE" = "both" ]; then
    # Install professional-only and personal-only entity commands
    install_commands_from "$TEMPLATES_DIR/claude/commands/professional"
    install_commands_from "$TEMPLATES_DIR/claude/commands/personal"
    # Install combined variants that scan all folders (overrides overlapping commands)
    install_commands_from "$TEMPLATES_DIR/claude/commands/both"
  else
    install_commands_from "$TEMPLATES_DIR/claude/commands/$ARCHITECTURE"
  fi

  local cmd_count
  cmd_count=$(ls -1 "$commands_dir"/*.md 2>/dev/null | wc -l | tr -d ' ')
  print_success "$cmd_count slash commands installed"

  if [ "$ARCHITECTURE" = "professional" ]; then
    print_success "  Core: /daily, /add-meeting, /new-project, /new-commercial, /link-coding, /vault-status, /weekly-review"
    print_success "  Thinking: /context, /today, /closeday, /trace, /connect, /ghost, /challenge"
    print_success "  Analytics: /session-stats"
    print_success "  Discovery: /ideas, /graduate, /drift, /emerge, /schedule"
  elif [ "$ARCHITECTURE" = "personal" ]; then
    print_success "  Core: /daily, /new-personal-project, /new-study, /new-course, /log-health, /new-finance, /new-family-event, /new-hobby, /vault-status, /weekly-review"
    print_success "  Thinking: /context, /today, /closeday, /trace, /connect, /ghost, /challenge"
    print_success "  Analytics: /session-stats"
    print_success "  Discovery: /ideas, /graduate, /drift, /emerge, /schedule"
  else
    print_success "  Professional: /new-project, /new-commercial, /link-coding, /add-meeting"
    print_success "  Personal: /new-personal-project, /new-study, /new-course, /log-health, /new-finance, /new-family-event, /new-hobby"
    print_success "  Shared: /daily, /vault-status, /weekly-review, /trace, /connect, /ghost, /challenge"
    print_success "  Thinking: /context, /today, /closeday"
    print_success "  Analytics: /session-stats"
    print_success "  Discovery: /ideas, /graduate, /drift, /emerge, /schedule"
  fi
}

generate_claude_md() {
  print_step 5 "Generating CLAUDE.md"

  # Build vault structure diagram based on architecture
  local vault_structure=""
  case "$ARCHITECTURE" in
    professional)
      vault_structure="$VAULT_FOLDER/
├── _templates/       # Note templates — do not edit directly, use slash commands
├── _analytics/       # Claude Code session analytics and cost tracking
│   └── sessions/     # Daily session notes with token/cost breakdowns
├── daily/            # Daily notes: YYYY-MM-DD.md
├── projects/         # Work project tracking notes
├── commercials/      # Commercial engagement notes
├── coding/           # Reference notes for coding repositories
├── meetings/         # Standalone meeting notes (for significant meetings)
├── people/           # Person/contact notes for cross-referencing
├── maps/             # MOC (Map of Content) index notes — navigation hubs
├── guides/           # How-to guides for using this vault with Obsidian + Claude Code
└── .obsidian/        # App config — do not edit unless updating plugin settings"
      ;;
    personal)
      vault_structure="$VAULT_FOLDER/
├── _templates/       # Note templates — do not edit directly, use slash commands
├── _analytics/       # Claude Code session analytics and cost tracking
│   └── sessions/     # Daily session notes with token/cost breakdowns
├── daily/            # Daily notes: YYYY-MM-DD.md
├── projects/         # Personal project tracking notes
├── study/            # School and university subject notes
├── courses/          # Online courses, workshops, and self-study
├── finances/         # Budget, expenses, and investment tracking
├── health/           # Workouts, appointments, and habit tracking
├── family/           # Family events, milestones, and notes
├── hobby/            # Hobby projects and activities
├── people/           # Person/contact notes for cross-referencing
├── maps/             # MOC (Map of Content) index notes — navigation hubs
├── guides/           # How-to guides for using this vault with Obsidian + Claude Code
└── .obsidian/        # App config — do not edit unless updating plugin settings"
      ;;
    both)
      vault_structure="$VAULT_FOLDER/
├── _templates/       # Note templates — do not edit directly, use slash commands
├── _analytics/       # Claude Code session analytics and cost tracking
│   └── sessions/     # Daily session notes with token/cost breakdowns
├── daily/            # Daily notes: YYYY-MM-DD.md
├── projects/         # Project tracking notes (work and personal)
├── commercials/      # Commercial engagement notes
├── coding/           # Reference notes for coding repositories
├── meetings/         # Standalone meeting notes (for significant meetings)
├── study/            # School and university subject notes
├── courses/          # Online courses, workshops, and self-study
├── finances/         # Budget, expenses, and investment tracking
├── health/           # Workouts, appointments, and habit tracking
├── family/           # Family events, milestones, and notes
├── hobby/            # Hobby projects and activities
├── people/           # Person/contact notes for cross-referencing
├── maps/             # MOC (Map of Content) index notes — navigation hubs
├── guides/           # How-to guides for using this vault with Obsidian + Claude Code
└── .obsidian/        # App config — do not edit unless updating plugin settings"
      ;;
  esac

  # Build conventions based on architecture
  local tags_line=""
  local types_line=""
  case "$ARCHITECTURE" in
    professional)
      tags_line="daily, meeting, project, commercial, coding, moc, person, weekly-review"
      types_line="daily, meeting, project, commercial, coding-project, person, moc, weekly-review"
      ;;
    personal)
      tags_line="daily, project, study, course, health, finance, family, hobby, moc, person, weekly-review"
      types_line="daily, personal-project, study, course, health-log, finance, family-event, hobby, person, moc, weekly-review"
      ;;
    both)
      tags_line="daily, meeting, project, commercial, coding, study, course, health, finance, family, hobby, moc, person, weekly-review"
      types_line="daily, meeting, project, personal-project, commercial, coding-project, study, course, health-log, finance, family-event, hobby, person, moc, weekly-review"
      ;;
  esac

  # Build coding section (only for professional and both)
  local coding_section=""
  if [ "$ARCHITECTURE" = "professional" ] || [ "$ARCHITECTURE" = "both" ]; then
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
  fi

  # Build MOC reference based on architecture
  local moc_reference=""
  case "$ARCHITECTURE" in
    professional)
      moc_reference="Projects MOC, Commercials MOC, or Coding MOC"
      ;;
    personal)
      moc_reference="Projects MOC, Study MOC, Courses MOC, Health MOC, Finance MOC, Family MOC, or Hobbies MOC"
      ;;
    both)
      moc_reference="the relevant MOC (Projects, Commercials, Coding, Study, Courses, Health, Finance, Family, or Hobbies)"
      ;;
  esac

  # Build command table based on architecture
  local command_table=""
  case "$ARCHITECTURE" in
    professional)
      command_table="| Command | Purpose |
|---------|---------|
| \`/daily\` | Create or open today's daily note |
| \`/add-meeting\` | Record a meeting in today's daily or as standalone |
| \`/new-project\` | Scaffold a project note, update Projects MOC |
| \`/new-commercial\` | Scaffold a commercial engagement, create people notes |
| \`/link-coding\` | Create a reference note from a local repository |
| \`/vault-status\` | Dashboard: recent activity, active projects/commercials, open tasks |
| \`/weekly-review\` | Summarize the past 5 work days |
| \`/context\` | Load your full life and work state into Claude |
| \`/today\` | Generate a prioritized plan for today |
| \`/closeday\` | End-of-day summary — progress, carry-overs, reflections |
| \`/session-stats\` | Show today's Claude Code token usage and estimated costs |
| \`/trace\` | Track how an idea evolved over time across your vault |
| \`/connect\` | Find unexpected connections between two topics |
| \`/ghost\` | Answer a question in your voice, based on your writing |
| \`/challenge\` | Pressure-test your beliefs — find contradictions and weak points |
| \`/ideas\` | Generate ideas: tools to build, people to meet, topics to explore |
| \`/graduate\` | Promote undeveloped ideas from daily notes into standalone files |
| \`/drift\` | Surface recurring themes you might not be aware of |
| \`/emerge\` | Find idea clusters coalescing into potential projects |
| \`/schedule\` | Suggest a weekly schedule aligned with your priorities |"
      ;;
    personal)
      command_table="| Command | Purpose |
|---------|---------|
| \`/daily\` | Create or open today's daily note |
| \`/new-personal-project\` | Scaffold a personal project note, update Projects MOC |
| \`/new-study\` | Create a study subject note, update Study MOC |
| \`/new-course\` | Create a course tracking note, update Courses MOC |
| \`/log-health\` | Log a health entry (workout, appointment, or habit) |
| \`/new-finance\` | Create a finance tracking note, update Finance MOC |
| \`/new-family-event\` | Create a family event note, update Family MOC |
| \`/new-hobby\` | Create a hobby tracking note, update Hobbies MOC |
| \`/vault-status\` | Dashboard: recent activity, active items, open tasks |
| \`/weekly-review\` | Summarize the past 7 days |
| \`/context\` | Load your full personal state into Claude |
| \`/today\` | Generate a prioritized plan for today |
| \`/closeday\` | End-of-day summary — progress, reflections, gratitude |
| \`/session-stats\` | Show today's Claude Code token usage and estimated costs |
| \`/trace\` | Track how an idea evolved over time across your vault |
| \`/connect\` | Find unexpected connections between two topics |
| \`/ghost\` | Answer a question in your voice, based on your writing |
| \`/challenge\` | Pressure-test your beliefs — find contradictions and weak points |
| \`/ideas\` | Generate ideas: skills to learn, health goals, hobbies to try |
| \`/graduate\` | Promote undeveloped ideas from daily notes into standalone files |
| \`/drift\` | Surface recurring themes you might not be aware of |
| \`/emerge\` | Find idea clusters coalescing into potential projects |
| \`/schedule\` | Suggest a weekly schedule aligned with your priorities |"
      ;;
    both)
      command_table="| Command | Purpose |
|---------|---------|
| \`/daily\` | Create or open today's daily note |
| \`/add-meeting\` | Record a meeting in today's daily or as standalone |
| \`/new-project\` | Scaffold a work project note, update Projects MOC |
| \`/new-commercial\` | Scaffold a commercial engagement, create people notes |
| \`/link-coding\` | Create a reference note from a local repository |
| \`/new-personal-project\` | Scaffold a personal project note, update Projects MOC |
| \`/new-study\` | Create a study subject note, update Study MOC |
| \`/new-course\` | Create a course tracking note, update Courses MOC |
| \`/log-health\` | Log a health entry (workout, appointment, or habit) |
| \`/new-finance\` | Create a finance tracking note, update Finance MOC |
| \`/new-family-event\` | Create a family event note, update Family MOC |
| \`/new-hobby\` | Create a hobby tracking note, update Hobbies MOC |
| \`/vault-status\` | Dashboard: recent activity, active items, open tasks |
| \`/weekly-review\` | Summarize the past week |
| \`/context\` | Load your full life and work state into Claude |
| \`/today\` | Generate a prioritized plan for today |
| \`/closeday\` | End-of-day summary — progress, carry-overs, reflections |
| \`/session-stats\` | Show today's Claude Code token usage and estimated costs |
| \`/trace\` | Track how an idea evolved over time across your vault |
| \`/connect\` | Find unexpected connections between two topics |
| \`/ghost\` | Answer a question in your voice, based on your writing |
| \`/challenge\` | Pressure-test your beliefs — find contradictions and weak points |
| \`/ideas\` | Generate ideas: tools, skills, health goals, hobbies, people |
| \`/graduate\` | Promote undeveloped ideas from daily notes into standalone files |
| \`/drift\` | Surface recurring themes you might not be aware of |
| \`/emerge\` | Find idea clusters coalescing into potential projects |
| \`/schedule\` | Suggest a weekly schedule aligned with your priorities |"
      ;;
  esac

  # Build meeting note instructions (only for professional and both)
  local meeting_line=""
  if [ "$ARCHITECTURE" = "professional" ] || [ "$ARCHITECTURE" = "both" ]; then
    meeting_line="
5. For meetings within a daily note, use inline headings; for major meetings, create a separate note in \`meetings/\`"
  fi

  cat > "$INSTALL_DIR/CLAUDE.md" << CLAUDEEOF
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

An **Obsidian vault** for knowledge management. All content is Markdown inside \`$VAULT_FOLDER/\`. There is no build system, test runner, or linting pipeline.

## Vault Structure

\`\`\`
$vault_structure
\`\`\`

## Conventions

- **Frontmatter**: Every note MUST have YAML frontmatter with at least \`type\` and \`tags\` fields
- **Links**: Use Obsidian wiki-links \`[[Note Title]]\`. Always link to related notes
- **Tags**: Use frontmatter \`tags: [tag1, tag2]\`. Common tags: $tags_line
- **Status values**: active, on-hold, completed, cancelled, won, lost
- **Filenames**: kebab-case for most notes, \`YYYY-MM-DD\` for daily notes, \`YYYY-WNN-review\` for weekly reviews
- **Type values**: $types_line

$coding_section

## When Creating Notes

1. Use the appropriate template structure (see \`_templates/\`)
2. Always add cross-reference wiki-links to related notes
3. Update the relevant MOC in \`maps/\` ($moc_reference)
4. For daily notes, name them \`YYYY-MM-DD.md\` in \`daily/\`$meeting_line
6. For new people/contacts, create a note in \`people/\`

## When Searching / Navigating

- Use \`type\` frontmatter to filter notes: \`type: project\`, \`type: daily\`, etc.
- Grep for \`status: active\` to find active items
- MOC notes in \`maps/\` are the best entry points for browsing by domain
- Daily notes are sorted chronologically by filename

## Slash Commands

Available project-level commands in \`.claude/commands/\`:

$command_table
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
  echo -e "  2. ${CYAN}Enable CSS snippets:${NC}"
  echo -e "     Settings → Appearance → CSS snippets → enable ${BOLD}tag-colors${NC} and ${BOLD}folder-styles${NC}"
  echo ""
  echo -e "  3. ${CYAN}Start Claude Code:${NC}"
  echo -e "     ${GREEN}cd $INSTALL_DIR && claude${NC}"
  echo ""
  echo -e "  4. ${CYAN}Create your first daily note:${NC}"
  echo -e "     Type ${BOLD}/daily${NC} in Claude Code"
  echo ""

  if [ "$ARCHITECTURE" = "professional" ] || [ "$ARCHITECTURE" = "both" ]; then
    if [ -n "$CODING_DIR" ]; then
      echo -e "  5. ${CYAN}Link a coding project:${NC}"
      echo -e "     Type ${BOLD}/link-coding <repo-name>${NC} in Claude Code"
      echo ""
    fi
  fi

  # Count installed items
  local vault_root="$INSTALL_DIR/$VAULT_FOLDER"
  local folder_count
  folder_count=$(find "$vault_root" -maxdepth 1 -type d ! -name ".*" ! -name "_*" ! -path "$vault_root" | wc -l | tr -d ' ')
  local template_count
  template_count=$(ls -1 "$vault_root/_templates/"*.md 2>/dev/null | wc -l | tr -d ' ')
  local moc_count
  moc_count=$(ls -1 "$vault_root/maps/"*.md 2>/dev/null | wc -l | tr -d ' ')
  local guide_count
  guide_count=$(ls -1 "$vault_root/guides/"*.md 2>/dev/null | wc -l | tr -d ' ')
  local cmd_count
  cmd_count=$(ls -1 "$INSTALL_DIR/.claude/commands/"*.md 2>/dev/null | wc -l | tr -d ' ')

  echo -e "${BOLD}Installed (${ARCHITECTURE}):${NC}"

  case "$ARCHITECTURE" in
    professional)
      echo -e "  • $folder_count vault folders (daily, projects, commercials, coding, meetings, people, maps, guides)"
      ;;
    personal)
      echo -e "  • $folder_count vault folders (daily, projects, study, courses, finances, health, family, hobby, people, maps, guides)"
      ;;
    both)
      echo -e "  • $folder_count vault folders (daily, projects, commercials, coding, meetings, study, courses, finances, health, family, hobby, people, maps, guides)"
      ;;
  esac

  echo -e "  • $template_count note templates"
  echo -e "  • $moc_count Maps of Content (navigation hubs)"
  echo -e "  • $guide_count how-to guides"
  echo -e "  • $cmd_count Claude Code slash commands"
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
