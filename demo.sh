#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────────────────────────────────────
# Brain Demo — Populate vault with realistic synthetic data
# https://github.com/vinipx/brain
# Usage: ./demo.sh [INSTALL_DIR] [VAULT_FOLDER] [ARCHITECTURE]
# ──────────────────────────────────────────────────────────────────────────────

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Globals
ARCHITECTURE=""
INSTALL_DIR=""
VAULT_FOLDER=""
VAULT_ROOT=""
CREATED=0
SKIPPED=0

# Date arrays — populated by compute_dates()
DAYS=()          # 20 business days (YYYY-MM-DD), oldest first

print_header() {
  echo ""
  echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}${BOLD}║        🧠 Brain — Demo Data Population           ║${NC}"
  echo -e "${CYAN}${BOLD}║     Realistic synthetic vault for showcase        ║${NC}"
  echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════╝${NC}"
  echo ""
}

print_step() { echo -e "${BLUE}▶${NC} ${BOLD}${1}${NC}"; }
print_success() { echo -e "  ${GREEN}✓${NC} ${1}"; CREATED=$((CREATED + 1)); }
print_warn() { echo -e "  ${YELLOW}~${NC} ${1}"; SKIPPED=$((SKIPPED + 1)); }
print_error() { echo -e "  ${RED}✗${NC} ${1}"; }

# ──────────────────────────────────────────────────────────────────────────────
# Config
# ──────────────────────────────────────────────────────────────────────────────

prompt_config() {
  # Non-interactive mode: accept positional args
  if [ $# -ge 3 ]; then
    INSTALL_DIR="${1/#\~/$HOME}"
    VAULT_FOLDER="$2"
    ARCHITECTURE="$3"
    return
  fi

  echo -e "${BOLD}Configure demo target:${NC}"
  echo ""

  local default_dir="$HOME/Documents/brain"
  read -rp "  Install directory [$default_dir]: " INSTALL_DIR
  INSTALL_DIR="${INSTALL_DIR:-$default_dir}"
  INSTALL_DIR="${INSTALL_DIR/#\~/$HOME}"

  read -rp "  Obsidian vault folder name [vault]: " VAULT_FOLDER
  VAULT_FOLDER="${VAULT_FOLDER:-vault}"

  echo ""
  echo -e "  ${BOLD}Architecture:${NC}"
  echo -e "    ${CYAN}1)${NC} Professional"
  echo -e "    ${CYAN}2)${NC} Personal"
  echo -e "    ${CYAN}3)${NC} Both"
  read -rp "  Choice [1]: " ARCH_CHOICE
  case "${ARCH_CHOICE:-1}" in
    1) ARCHITECTURE="professional" ;;
    2) ARCHITECTURE="personal" ;;
    3) ARCHITECTURE="both" ;;
    *) print_error "Invalid choice."; exit 1 ;;
  esac
}

validate() {
  VAULT_ROOT="$INSTALL_DIR/$VAULT_FOLDER"
  if [ ! -d "$VAULT_ROOT" ]; then
    print_error "Vault not found at: $VAULT_ROOT"
    print_error "Run setup.sh first, then demo.sh."
    exit 1
  fi
  if [ ! -f "$INSTALL_DIR/CLAUDE.md" ]; then
    print_error "CLAUDE.md not found at: $INSTALL_DIR/CLAUDE.md"
    print_error "Run setup.sh first, then demo.sh."
    exit 1
  fi
  echo -e "  ${GREEN}✓${NC} Vault found at $VAULT_ROOT"
  echo -e "  ${GREEN}✓${NC} Architecture: $ARCHITECTURE"
  echo ""
}

# ──────────────────────────────────────────────────────────────────────────────
# Date Helpers
# ──────────────────────────────────────────────────────────────────────────────

safe_write() {
  local filepath="$1"
  local content="$2"
  if [ -f "$filepath" ]; then
    print_warn "Skipping (exists): $(basename "$filepath")"
  else
    printf '%s\n' "$content" > "$filepath"
    print_success "Created: $(basename "$filepath")"
  fi
}

force_write() {
  local filepath="$1"
  local content="$2"
  printf '%s\n' "$content" > "$filepath"
  print_success "Updated MOC: $(basename "$filepath")"
}

# Generate array of 20 business day dates (Mon-Fri) ending yesterday
# Output: space-separated YYYY-MM-DD dates, oldest first
get_business_days() {
  local dates=()
  local count=0
  local offset=1

  # Detect macOS vs Linux date
  if date -v-1d +%Y-%m-%d > /dev/null 2>&1; then
    # macOS
    while [ ${#dates[@]} -lt 20 ]; do
      local d
      d=$(date -v-"${offset}"d +%Y-%m-%d)
      local dow
      dow=$(date -v-"${offset}"d +%u)  # 1=Mon 7=Sun
      if [ "$dow" -le 5 ]; then
        dates=("$d" ${dates[@]+"${dates[@]}"})
      fi
      offset=$((offset + 1))
    done
  else
    # Linux/GNU date
    while [ ${#dates[@]} -lt 20 ]; do
      local d
      d=$(date -d "${offset} days ago" +%Y-%m-%d)
      local dow
      dow=$(date -d "${offset} days ago" +%u)
      if [ "$dow" -le 5 ]; then
        dates=("$d" ${dates[@]+"${dates[@]}"})
      fi
      offset=$((offset + 1))
    done
  fi

  echo "${dates[@]}"
}

# Offset a YYYY-MM-DD date by N calendar days (positive = future, negative = past)
# Usage: offset_date "2026-03-10" -30
offset_date() {
  local base="$1"
  local n="$2"
  if date -v-1d +%Y-%m-%d > /dev/null 2>&1; then
    # macOS — requires explicit +/- sign for -v flag
    local sign=""
    if [[ "$n" =~ ^[0-9] ]]; then sign="+"; fi
    date -v"${sign}${n}d" -jf "%Y-%m-%d" "$base" +%Y-%m-%d 2>/dev/null
  else
    # Linux
    date -d "$base ${n} days" +%Y-%m-%d
  fi
}

# Format YYYY-MM-DD to "Monday, March 3, 2026"
format_date_long() {
  local d="$1"
  if date -v-1d +%Y-%m-%d > /dev/null 2>&1; then
    date -jf "%Y-%m-%d" "$d" +"%A, %B %-d, %Y" 2>/dev/null || echo "$d"
  else
    date -d "$d" +"%A, %B %-d, %Y" 2>/dev/null || echo "$d"
  fi
}

# Format YYYY-MM-DD to "March 3, 2026"
format_date_short() {
  local d="$1"
  if date -v-1d +%Y-%m-%d > /dev/null 2>&1; then
    date -jf "%Y-%m-%d" "$d" +"%B %-d, %Y" 2>/dev/null || echo "$d"
  else
    date -d "$d" +"%B %-d, %Y" 2>/dev/null || echo "$d"
  fi
}

# Format YYYY-MM-DD to "March 2026"
format_month_year() {
  local d="$1"
  if date -v-1d +%Y-%m-%d > /dev/null 2>&1; then
    date -jf "%Y-%m-%d" "$d" +"%B %Y" 2>/dev/null || echo "$d"
  else
    date -d "$d" +"%B %Y" 2>/dev/null || echo "$d"
  fi
}

# Get quarter label, e.g. "Q1 2026"
get_quarter() {
  local d="$1"
  local month year q
  if date -v-1d +%Y-%m-%d > /dev/null 2>&1; then
    month=$(date -jf "%Y-%m-%d" "$d" +%-m 2>/dev/null)
    year=$(date -jf "%Y-%m-%d" "$d" +%Y 2>/dev/null)
  else
    month=$(date -d "$d" +%-m)
    year=$(date -d "$d" +%Y)
  fi
  if [ "$month" -le 3 ]; then q=1
  elif [ "$month" -le 6 ]; then q=2
  elif [ "$month" -le 9 ]; then q=3
  else q=4; fi
  echo "Q${q} ${year}"
}

# Get next quarter label
get_next_quarter() {
  local d="$1"
  local month year q
  if date -v-1d +%Y-%m-%d > /dev/null 2>&1; then
    month=$(date -jf "%Y-%m-%d" "$d" +%-m 2>/dev/null)
    year=$(date -jf "%Y-%m-%d" "$d" +%Y 2>/dev/null)
  else
    month=$(date -d "$d" +%-m)
    year=$(date -d "$d" +%Y)
  fi
  if [ "$month" -le 3 ]; then q=2
  elif [ "$month" -le 6 ]; then q=3
  elif [ "$month" -le 9 ]; then q=4
  else q=1; year=$((year + 1)); fi
  echo "Q${q} ${year}"
}

# ──────────────────────────────────────────────────────────────────────────────
# Date Computation — all dates derived from DAYS[] array
# ──────────────────────────────────────────────────────────────────────────────

compute_dates() {
  print_step "Computing dynamic dates"

  # D1=DAYS[0] through D20=DAYS[19] — 20 business days ending yesterday
  local raw_days
  raw_days=$(get_business_days)
  read -ra DAYS <<< "$raw_days"

  local D1="${DAYS[0]}"

  # Today's date (always current day, for /closeday demo)
  if date -v-1d +%Y-%m-%d > /dev/null 2>&1; then
    TODAY=$(date +%Y-%m-%d)
  else
    TODAY=$(date +%Y-%m-%d)
  fi
  TODAY_LONG=$(format_date_long "$TODAY")

  # ── Relative offset dates ──────────────────────────────────────────────
  # Past dates (before the 20-day window) — used in progress logs, project starts
  PAST_12W=$(offset_date "$D1" -84)   # ~12 weeks before D1
  PAST_10W=$(offset_date "$D1" -70)   # ~10 weeks before D1
  PAST_9W=$(offset_date "$D1" -63)    # ~9 weeks before D1
  PAST_8W=$(offset_date "$D1" -56)    # ~8 weeks before D1
  PAST_7W=$(offset_date "$D1" -49)    # ~7 weeks before D1
  PAST_6W=$(offset_date "$D1" -42)    # ~6 weeks before D1
  PAST_5W=$(offset_date "$D1" -35)    # ~5 weeks before D1
  PAST_4W=$(offset_date "$D1" -28)    # ~4 weeks before D1
  PAST_3W=$(offset_date "$D1" -21)    # ~3 weeks before D1
  PAST_2W=$(offset_date "$D1" -14)    # ~2 weeks before D1
  PAST_1W=$(offset_date "$D1" -7)     # ~1 week before D1
  PAST_1D=$(offset_date "$D1" -1)     # day before D1

  # Future dates (after the 20-day window) — used in target dates, events
  local D20="${DAYS[19]}"
  FUTURE_1W=$(offset_date "$D20" 7)    # ~1 week after D20
  FUTURE_3W=$(offset_date "$D20" 21)   # ~3 weeks after D20
  FUTURE_7W=$(offset_date "$D20" 49)   # ~7 weeks after D20
  FUTURE_11W=$(offset_date "$D20" 77)  # ~11 weeks after D20
  FUTURE_14W=$(offset_date "$D20" 98)  # ~14 weeks after D20
  FUTURE_18W=$(offset_date "$D20" 126) # ~18 weeks after D20
  FUTURE_22W=$(offset_date "$D20" 154) # ~22 weeks after D20

  # ── Named dates for specific content ───────────────────────────────────
  # Meeting dates — tied to specific DAYS indices
  # D4=DAYS[3], D7=DAYS[6], D12=DAYS[11], D15=DAYS[14], D17=DAYS[16], D18=DAYS[17]
  MEETING_ARCH_DATE="${DAYS[3]}"        # Architecture Review
  MEETING_KICKOFF_DATE="${DAYS[6]}"     # Client Kickoff
  MEETING_SPRINT_DATE="${DAYS[11]}"     # Sprint Planning
  MEETING_1ON1_DATE="${DAYS[14]}"       # Team 1:1
  MEETING_QUARTERLY_DATE="${DAYS[17]}"  # Quarterly Review

  # Project dates
  PROJ_API_START="$PAST_7W"
  PROJ_API_TARGET="$FUTURE_14W"
  PROJ_DASH_START="$PAST_5W"
  PROJ_DASH_TARGET="$FUTURE_7W"
  PROJ_DEVOPS_START="$PAST_8W"
  PROJ_DEVOPS_TARGET="$FUTURE_18W"

  # Personal project dates
  PROJ_SERVER_START="$PAST_3W"
  PROJ_SERVER_TARGET="$FUTURE_7W"
  PROJ_PHOTO_START="$PAST_9W"
  PROJ_LANG_START="$PAST_1D"
  PROJ_LANG_TARGET="$FUTURE_22W"

  # Commercial dates
  COMM_TECHCORP_DISCOVERY="$PAST_12W"
  COMM_TECHCORP_SOW="$PAST_8W"
  COMM_FINTECH_INITIAL="$PAST_10W"    # relative; pre-dates are approximate
  COMM_FINTECH_DELIVERY="$PAST_1W"
  COMM_RETAIL_RFP="$PAST_7W"
  COMM_RETAIL_PROPOSAL="$PAST_5W"
  COMM_RETAIL_DECISION="$PAST_4W"

  # Event dates
  EVENT_GRADUATION="$FUTURE_7W"
  EVENT_ANNIVERSARY="$FUTURE_1W"

  # Study dates
  STUDY_A2_DATE="$PAST_7W"
  STUDY_B1_TARGET="$FUTURE_22W"
  STUDY_A1_DATE="$PAST_10W"
  COURSE_SYSDES_START="$PAST_3W"

  # Health dates
  HEALTH_STR1_DATE="${DAYS[1]}"
  HEALTH_RUN_DATE="${DAYS[6]}"
  HEALTH_CHECKUP_DATE="${DAYS[8]}"
  HEALTH_STR3_DATE="${DAYS[11]}"

  # Finance dates
  FINANCE_RENT_DATE="${DAYS[0]}"
  FINANCE_GYM_DATE="${DAYS[3]}"
  FINANCE_CONF_DATE="${DAYS[14]}"
  FINANCE_FREELANCE_DATE="$PAST_1W"

  # Hobby progress dates
  HOBBY_PHOTO1_DATE="$PAST_8W"
  HOBBY_PHOTO2_DATE="$PAST_4W"
  HOBBY_PHOTO3_DATE="${DAYS[4]}"
  HOBBY_ITAL1_DATE="$PAST_8W"
  HOBBY_ITAL2_DATE="$PAST_3W"
  HOBBY_ITAL3_DATE="${DAYS[13]}"

  # Progress log dates
  PROG_API_AUDIT="$PAST_4W"
  PROG_API_CONTRACTS="$PAST_1W"
  PROG_DASH_REACT="$PAST_3W"
  PROG_DEVOPS_ACTIONS="$PAST_3W"
  PROG_DEVOPS_HOLD="$PAST_1D"
  PROG_SERVER_PROX="$PAST_3W"
  PROG_SERVER_NEXT="$PAST_2W"
  PROG_LANG_SRS="${DAYS[9]}"

  # Quarter labels
  QUARTER_CURRENT=$(get_quarter "$D1")
  QUARTER_NEXT=$(get_next_quarter "$D1")

  # Month labels
  MONTH_CURRENT=$(format_month_year "$D1")

  echo -e "  ${GREEN}✓${NC} Date range: ${DAYS[0]} to ${DAYS[19]}"
  echo -e "  ${GREEN}✓${NC} Quarter: $QUARTER_CURRENT"
  echo ""
}

# ──────────────────────────────────────────────────────────────────────────────
# People Notes
# ──────────────────────────────────────────────────────────────────────────────

create_people_professional() {
  print_step "Creating people notes (professional)"
  local dir="$VAULT_ROOT/people"

  safe_write "$dir/sarah-morgan.md" "---
type: person
role: Engineering Manager
company: TechCorp
tags: [person, client]
---

# Sarah Morgan

Engineering Manager at TechCorp. Main point of contact for the [[TechCorp Enterprise Deal]] engagement.

## Contact
- **Company**: TechCorp
- **Role**: Engineering Manager
- **LinkedIn**: linkedin.com/in/sarah-morgan

## Notes
- Prefers async communication via Slack
- Very focused on delivery timelines and milestones
- Champions the API migration project internally

## Related
- [[TechCorp Enterprise Deal]]
- [[API Platform Migration]]
- [[${MEETING_KICKOFF_DATE} Client Kickoff]]"

  safe_write "$dir/james-liu.md" "---
type: person
role: CTO
company: FinTech Startup
tags: [person, client]
---

# James Liu

CTO at the fintech startup behind [[FinTech SaaS Integration]]. Technical co-founder, very hands-on.

## Contact
- **Company**: FinStack Inc.
- **Role**: CTO & Co-founder
- **Email**: james@finstackinc.com

## Notes
- Prefers direct Zoom calls over async
- Deep knowledge of payments infrastructure
- Was the main decision-maker for the won deal

## Related
- [[FinTech SaaS Integration]]
- [[${MEETING_ARCH_DATE} Architecture Review]]"

  safe_write "$dir/priya-patel.md" "---
type: person
role: Product Manager
company: Internal
tags: [person, team]
---

# Priya Patel

Senior PM on the Client Dashboard project. Excellent at stakeholder communication.

## Contact
- **Company**: Axiom Digital (internal)
- **Role**: Senior Product Manager

## Notes
- Runs weekly sprint reviews
- Excellent at translating business requirements to eng specs
- Organised the ${QUARTER_CURRENT} quarterly review

## Related
- [[Client Dashboard V2]]
- [[${MEETING_SPRINT_DATE} Sprint Planning]]
- [[${MEETING_QUARTERLY_DATE} Quarterly Review]]"

  safe_write "$dir/david-okafor.md" '---
type: person
role: DevOps Lead
company: Internal
tags: [person, team]
---

# David Okafor

DevOps lead. Owns the CI/CD pipelines and cloud infrastructure at Axiom Digital.

## Contact
- **Company**: Axiom Digital (internal)
- **Role**: Senior DevOps Engineer

## Notes
- Kubernetes expert, strong AWS background
- Collaborating on [[DevOps Pipeline Overhaul]]
- Introduced the GitOps workflow proposal

## Related
- [[DevOps Pipeline Overhaul]]
- [[infra-as-code]]'
}

create_people_personal() {
  print_step "Creating people notes (personal)"
  local dir="$VAULT_ROOT/people"

  safe_write "$dir/maya-chen.md" '---
type: person
role: Partner
tags: [person, family]
---

# Maya Chen

Partner. UX designer at a fintech company.

## Notes
- Runs half marathons, inspired the [[strength-training-month]] habit log
- Planning a trip to Italy in September — motivation for [[Italian B1]]
- Input on UI/UX for [[Language Learning App]]

## Related
- [[Italian B1]]
- [[Language Learning App]]'

  safe_write "$dir/lily-chen.md" "---
type: person
role: Sister
tags: [person, family]
---

# Lily Chen

Younger sister. Graduating from UC Berkeley around $(format_date_short "$EVENT_GRADUATION").

## Notes
- Computer Science major, interested in ML
- Graduation ceremony: $(format_date_short "$EVENT_GRADUATION") — see [[Lily Graduation Ceremony]]

## Related
- [[Lily Graduation Ceremony]]"

  safe_write "$dir/mom-chen.md" "---
type: person
role: Parent
tags: [person, family]
---

# Mom Chen

## Notes
- Anniversary dinner with Dad planned for $(format_date_short "$EVENT_ANNIVERSARY") — see [[Parents Anniversary Dinner]]
- Visiting SF in a few months

## Related
- [[Parents Anniversary Dinner]]"
}

# ──────────────────────────────────────────────────────────────────────────────
# Professional Notes
# ──────────────────────────────────────────────────────────────────────────────

create_projects_professional() {
  print_step "Creating project notes"
  local dir="$VAULT_ROOT/projects"

  safe_write "$dir/api-platform-migration.md" "---
type: project
status: active
priority: high
client: TechCorp
start-date: ${PROJ_API_START}
target-date: ${PROJ_API_TARGET}
tags: [project]
---

# API Platform Migration

Migrating TechCorp's legacy REST API layer to a modern GraphQL + gRPC hybrid platform. High-impact, client-critical delivery.

## Overview
TechCorp runs 14 internal microservices communicating over a fragile SOAP/REST mix from 2018. This project replaces the integration layer with a versioned GraphQL gateway and gRPC service mesh.

## Objectives
- Replace SOAP endpoints with gRPC service contracts
- Deploy GraphQL gateway with schema stitching
- Zero-downtime migration with feature flags
- Deliver OpenAPI + Protobuf documentation

## Key Contacts
- [[Sarah Morgan]] — Engineering Manager, TechCorp
- [[James Liu]] — CTO, technical advisor

## Related
- **Commercial**: [[TechCorp Enterprise Deal]]
- **Coding**: [[payments-api]]
- **Meetings**: [[${MEETING_KICKOFF_DATE} Client Kickoff]], [[${MEETING_ARCH_DATE} Architecture Review]]

## Progress Log

| Date | Update |
|------|--------|
| ${PROJ_API_START} | Project kicked off, discovery phase started |
| ${PROG_API_AUDIT} | SOAP audit complete — 47 endpoints identified |
| ${PROG_API_CONTRACTS} | gRPC protobuf contracts drafted (v0.1) |
| ${MEETING_KICKOFF_DATE} | Client kickoff — TechCorp approved phase 1 scope |
| ${MEETING_QUARTERLY_DATE} | GraphQL gateway spike complete, performance benchmarks green |

## Tasks
- [x] Complete SOAP endpoint audit
- [x] Draft gRPC protobuf contracts v0.1
- [x] Deploy GraphQL gateway to staging
- [ ] Migrate first 5 microservices to gRPC
- [ ] Load testing at 10k RPS
- [ ] Client UAT sign-off"

  safe_write "$dir/client-dashboard-v2.md" "---
type: project
status: active
priority: medium
client: Internal
start-date: ${PROJ_DASH_START}
target-date: ${PROJ_DASH_TARGET}
tags: [project]
---

# Client Dashboard V2

Complete redesign of the internal client-facing reporting dashboard. React 18 + new data pipeline.

## Overview
The current dashboard is a 2022 Vue.js app with a slow ETL pipeline. V2 rebuilds the frontend in React 18 with a Kafka-based streaming pipeline for near-realtime reporting.

## Objectives
- Migrate from Vue 2 to React 18
- Replace nightly ETL with Kafka streaming pipeline
- Sub-2s page load for P95
- Role-based access control for enterprise clients

## Key Contacts
- [[Priya Patel]] — Product Manager
- [[David Okafor]] — Infrastructure review

## Related
- **Commercial**: N/A (internal)
- **Coding**: [[brain-vault]]
- **Meetings**: [[${MEETING_SPRINT_DATE} Sprint Planning]]

## Progress Log

| Date | Update |
|------|--------|
| ${PROJ_DASH_START} | Kickoff — design specs approved |
| ${PROG_DASH_REACT} | React component library bootstrapped |
| ${DAYS[3]} | Kafka pipeline POC — 340ms avg latency |
| ${MEETING_SPRINT_DATE} | Sprint 4 planning, RBAC stories in backlog |

## Tasks
- [x] React 18 component library setup
- [x] Kafka pipeline POC
- [ ] Implement RBAC layer
- [ ] Performance testing (P95 target)
- [ ] Beta rollout to 3 pilot clients"

  safe_write "$dir/devops-pipeline-overhaul.md" "---
type: project
status: on-hold
priority: low
client: Internal
start-date: ${PROJ_DEVOPS_START}
target-date: ${PROJ_DEVOPS_TARGET}
tags: [project]
---

# DevOps Pipeline Overhaul

Modernise CI/CD pipelines from Jenkins to GitHub Actions + ArgoCD GitOps.

## Overview
Legacy Jenkins pipelines have 45-minute build times and frequent flaky tests. Moving to GitHub Actions for CI and ArgoCD for CD on Kubernetes.

## Objectives
- Replace Jenkins with GitHub Actions
- Implement ArgoCD GitOps for Kubernetes deployments
- Reduce average build time to under 8 minutes
- Implement environment promotion gates

## Key Contacts
- [[David Okafor]] — DevOps Lead (owner)

## Related
- **Coding**: [[infra-as-code]]

## Progress Log

| Date | Update |
|------|--------|
| ${PROJ_DEVOPS_START} | Jenkins audit — 23 pipelines identified |
| ${PROG_DEVOPS_ACTIONS} | GitHub Actions migration plan drafted |
| ${PROG_DEVOPS_HOLD} | Put on hold — resources redirected to API Migration |

## Tasks
- [x] Jenkins pipeline audit
- [x] GitHub Actions migration plan
- [ ] Migrate first 5 pipelines
- [ ] ArgoCD cluster setup
- [ ] Team training on GitOps workflow"
}

create_commercials() {
  print_step "Creating commercial notes"
  local dir="$VAULT_ROOT/commercials"

  safe_write "$dir/techcorp-enterprise-deal.md" "---
type: commercial
status: active
client: TechCorp
contact: sarah-morgan
start-date: ${COMM_TECHCORP_DISCOVERY}
value: \"320000\"
probability: \"80\"
tags: [commercial]
---

# Commercial: TechCorp Enterprise Deal

12-month enterprise engagement for API platform modernisation. Largest active deal in ${QUARTER_CURRENT}.

## Client
TechCorp — mid-size B2B SaaS company, 400 engineers. Engineering Manager [[Sarah Morgan]] is our main contact.

## Engagement Summary
Full-stack API migration from legacy SOAP/REST to GraphQL + gRPC. Includes 6 months of post-migration support and documentation.

## Key Contacts
- [[Sarah Morgan]] — Engineering Manager
- [[James Liu]] — Technical Advisor (external)

## Timeline

| Date | Event | Notes |
|------|-------|-------|
| ${COMM_TECHCORP_DISCOVERY} | Discovery call | Confirmed budget and scope |
| ${COMM_TECHCORP_SOW} | SOW signed | \$320k, 12 months |
| ${PROJ_API_START} | Project kickoff | See [[API Platform Migration]] |
| ${MEETING_KICKOFF_DATE} | Phase 1 review | On track |

## Deliverables
- [x] SOW signed
- [x] Phase 1: SOAP audit and gRPC contracts
- [ ] Phase 2: GraphQL gateway deployment
- [ ] Phase 3: Microservice migration (5 services)
- [ ] Phase 4: Documentation and handover

## Related
- **Project**: [[API Platform Migration]]
- **Meetings**: [[${MEETING_KICKOFF_DATE} Client Kickoff]]

## Notes
Strong renewal signal. Sarah mentioned budget approval for a follow-on data platform project in ${QUARTER_NEXT}."

  safe_write "$dir/fintech-saas-integration.md" "---
type: commercial
status: won
client: FinStack Inc.
contact: james-liu
start-date: ${COMM_FINTECH_INITIAL}
value: \"95000\"
probability: \"100\"
tags: [commercial]
---

# Commercial: FinTech SaaS Integration

Payment gateway integration for FinStack. Closed recently.

## Client
FinStack Inc. — payments infrastructure startup, 40 engineers. CTO [[James Liu]] was the decision-maker.

## Engagement Summary
3-month integration project to connect FinStack's payment engine to 4 enterprise banking partners via API adapters.

## Key Contacts
- [[James Liu]] — CTO & Co-founder

## Timeline

| Date | Event | Notes |
|------|-------|-------|
| ${COMM_FINTECH_INITIAL} | Initial meeting | Referral via David |
| $(offset_date "$COMM_FINTECH_INITIAL" 17) | Proposal submitted | \$95k fixed-price |
| $(offset_date "$COMM_FINTECH_INITIAL" 36) | Contract signed | |
| $(offset_date "$COMM_FINTECH_INITIAL" 47) | Project start | |
| ${COMM_FINTECH_DELIVERY} | Delivery and sign-off | All 4 integrations live |

## Deliverables
- [x] API adapter for Chase Bank
- [x] API adapter for Wells Fargo
- [x] API adapter for Stripe Connect
- [x] API adapter for Plaid
- [x] Integration test suite
- [x] Handover documentation

## Related
- **Meetings**: [[${MEETING_ARCH_DATE} Architecture Review]]

## Notes
Delivered on time, client very happy. James mentioned Series A closing in ${QUARTER_NEXT} — potential follow-on."

  safe_write "$dir/retail-analytics-proposal.md" "---
type: commercial
status: lost
client: RetailCo
contact: \"\"
start-date: ${COMM_RETAIL_RFP}
value: \"150000\"
probability: \"0\"
tags: [commercial]
---

# Commercial: Retail Analytics Platform

Data analytics platform proposal for RetailCo. Lost to competitor.

## Client
RetailCo — regional retail chain, 200 stores. Procurement team was the main contact.

## Engagement Summary
6-month build of a customer behaviour analytics platform using Databricks + dbt + Looker.

## Key Contacts
- Procurement Team (no personal contact established)

## Timeline

| Date | Event | Notes |
|------|-------|-------|
| ${COMM_RETAIL_RFP} | RFP received | \$150k budget indicated |
| ${COMM_RETAIL_PROPOSAL} | Proposal submitted | Full data platform scope |
| ${COMM_RETAIL_DECISION} | Decision meeting | Lost — competitor undercut by \$40k |

## Deliverables
- [x] RFP response
- [x] Technical proposal
- [ ] ~~Project delivery~~ — not awarded

## Notes
Lost on price. Competitor (DataBridge) offered a templated solution. Lesson: need a pre-packaged retail analytics offering to compete in this segment."
}

create_meetings() {
  print_step "Creating meeting notes"
  local dir="$VAULT_ROOT/meetings"
  local d17_plus7
  d17_plus7=$(offset_date "${MEETING_QUARTERLY_DATE}" 7)

  safe_write "$dir/${MEETING_ARCH_DATE}-architecture-review.md" "---
date: ${MEETING_ARCH_DATE}
time: \"14:00\"
type: meeting
attendees: [Alex Chen, James Liu, Sarah Morgan]
project: api-platform-migration
tags: [meeting]
---

# Meeting: Architecture Review — API Gateway Options

## Context
- **Project**: [[API Platform Migration]]
- **Attendees**: Alex Chen, [[James Liu]], [[Sarah Morgan]]
- **Goal**: Align on GraphQL gateway architecture before Phase 2 begins

## Discussion
Reviewed three gateway options: Apollo Federation, Hasura, and a custom Node.js gateway. James pushed for Apollo Federation given the existing team familiarity. Sarah requested a latency benchmark before final decision.

Key concern raised: schema versioning strategy for the 14 existing microservices.

## Decisions
- Proceed with Apollo Federation for the GraphQL gateway
- Alex to run latency benchmarks at 5k and 10k RPS by ${MEETING_SPRINT_DATE}
- Schema versioning will use \`@deprecated\` directives + a parallel-run period

## Action Items
- [x] Alex: Apollo Federation POC in staging
- [x] Alex: Latency benchmark report
- [ ] James: Review and approve protobuf contracts v0.2
- [ ] Sarah: Confirm microservice migration order with TechCorp eng team

## Follow-ups
- [[${MEETING_KICKOFF_DATE} Client Kickoff]]
- [[API Platform Migration]]"

  safe_write "$dir/${MEETING_KICKOFF_DATE}-client-kickoff.md" "---
date: ${MEETING_KICKOFF_DATE}
time: \"10:00\"
type: meeting
attendees: [Alex Chen, Sarah Morgan, Priya Patel]
project: api-platform-migration
tags: [meeting]
---

# Meeting: TechCorp Phase 1 Client Kickoff

## Context
- **Project**: [[API Platform Migration]]
- **Attendees**: Alex Chen, [[Sarah Morgan]], [[Priya Patel]]
- **Goal**: Formal phase 1 kickoff — review deliverables, timeline, and communication cadence

## Discussion
Walked through the phase 1 scope: SOAP audit complete (47 endpoints), gRPC contracts drafted. Sarah confirmed the TechCorp eng team has reviewed and approved the contracts.

Agreed on bi-weekly sync cadence. Sarah will send calendar invites.

## Decisions
- Phase 1 officially signed off — moving to Phase 2
- Bi-weekly syncs on Tuesdays at 10am PT
- Slack channel \`#api-migration\` created for async comms

## Action Items
- [x] Alex: Set up \`#api-migration\` Slack channel
- [x] Priya: Update project tracker with Phase 2 milestones
- [ ] Sarah: Introduce TechCorp infra team to David by ${MEETING_SPRINT_DATE}
- [ ] Alex: Deploy GraphQL gateway to staging by ${MEETING_QUARTERLY_DATE}

## Follow-ups
- [[API Platform Migration]]
- [[TechCorp Enterprise Deal]]"

  safe_write "$dir/${MEETING_SPRINT_DATE}-sprint-planning.md" "---
date: ${MEETING_SPRINT_DATE}
time: \"09:30\"
type: meeting
attendees: [Alex Chen, Priya Patel, David Okafor]
project: client-dashboard-v2
tags: [meeting]
---

# Meeting: Sprint 4 Planning — Dashboard V2

## Context
- **Project**: [[Client Dashboard V2]]
- **Attendees**: Alex Chen, [[Priya Patel]], [[David Okafor]]
- **Goal**: Plan Sprint 4 stories — RBAC layer and performance testing

## Discussion
Sprint 3 velocity: 34 story points (target was 30). Kafka pipeline POC delivered with 340ms P50 latency — well under the 2s P95 target.

Sprint 4 focus: implement RBAC, start beta rollout prep, fix 3 outstanding accessibility issues.

## Decisions
- Sprint 4 goal: RBAC layer complete + beta rollout plan
- David to review Kubernetes resource limits before beta
- Accessibility issues prioritised over new features

## Action Items
- [ ] Alex: Implement RBAC middleware (8 pts)
- [ ] Alex: Write RBAC integration tests (5 pts)
- [ ] Priya: Draft beta rollout communication to 3 pilot clients
- [ ] David: Review K8s resource quotas for dashboard service

## Follow-ups
- [[Client Dashboard V2]]"

  safe_write "$dir/${MEETING_1ON1_DATE}-team-1on1.md" "---
date: ${MEETING_1ON1_DATE}
time: \"11:00\"
type: meeting
attendees: [Alex Chen, David Okafor]
project: devops-pipeline-overhaul
tags: [meeting]
---

# Meeting: 1:1 with David — DevOps Pipeline Status

## Context
- **Project**: [[DevOps Pipeline Overhaul]]
- **Attendees**: Alex Chen, [[David Okafor]]
- **Goal**: Check in on pipeline overhaul status, plan when to resume

## Discussion
Project is on hold since ${PROG_DEVOPS_HOLD} due to resource reallocation to the API Migration. David has been keeping a backlog of Jenkins issues. Estimated 3 Jenkins pipelines could fail in the next 6 weeks without intervention.

## Decisions
- Quick patch: David will fix the 3 at-risk Jenkins pipelines independently
- Full overhaul to resume after API Migration Phase 2 is delivered (target: late ${QUARTER_NEXT})
- David will use downtime to set up GitHub Actions on a non-critical repo as a proof of concept

## Action Items
- [ ] David: Patch 3 at-risk Jenkins pipelines by ${DAYS[19]}
- [ ] David: GitHub Actions POC on \`utils-lib\` repo
- [ ] Alex: Add DevOps overhaul back to roadmap for ${QUARTER_NEXT}

## Follow-ups
- [[DevOps Pipeline Overhaul]]
- [[infra-as-code]]"

  safe_write "$dir/${MEETING_QUARTERLY_DATE}-quarterly-review.md" "---
date: ${MEETING_QUARTERLY_DATE}
time: \"14:00\"
type: meeting
attendees: [Alex Chen, Priya Patel, Sarah Morgan, David Okafor]
project: \"\"
tags: [meeting]
---

# Meeting: ${QUARTER_CURRENT} Quarterly Review

## Context
- **Project**: Cross-team review
- **Attendees**: Alex Chen, [[Priya Patel]], [[Sarah Morgan]] (guest), [[David Okafor]]
- **Goal**: Review ${QUARTER_CURRENT} OKRs, celebrate wins, identify blockers for ${QUARTER_NEXT}

## Discussion
${QUARTER_CURRENT} highlights:
- [[FinTech SaaS Integration]] delivered on time and budget ✓
- [[API Platform Migration]] Phase 1 complete ✓
- [[Client Dashboard V2]] on track for delivery ✓

Blocker: [[DevOps Pipeline Overhaul]] slipped — need to replan for ${QUARTER_NEXT}.

Revenue: ${QUARTER_CURRENT} bookings 112% of target. [[TechCorp Enterprise Deal]] is the anchor.

## Decisions
- ${QUARTER_NEXT} priority order: API Migration Phase 2 > Dashboard Beta > DevOps Overhaul
- Hire 1 additional mid-level backend engineer by end of next month
- Monthly revenue review to be added to team calendar

## Action Items
- [ ] Alex: Post ${QUARTER_CURRENT} summary to team Notion by ${DAYS[19]}
- [ ] Priya: Start hiring JD for backend engineer
- [ ] David: DevOps ${QUARTER_NEXT} plan by ${d17_plus7}

## Follow-ups
- [[API Platform Migration]]
- [[Client Dashboard V2]]
- [[DevOps Pipeline Overhaul]]"
}

create_coding_projects() {
  print_step "Creating coding project notes"
  local dir="$VAULT_ROOT/coding"

  safe_write "$dir/payments-api.md" '---
type: coding-project
repo-path: ~/coding/payments-api
language: Go
framework: gRPC / Protobuf
status: active
tags: [coding]
---

# payments-api

Core payment processing API used in the [[FinTech SaaS Integration]] and [[API Platform Migration]] projects.

## Repository
- **Path**: `~/coding/payments-api`
- **Language**: Go 1.22
- **Framework**: gRPC + Protobuf

## Description
High-throughput payment processing service. Handles card authorisation, settlement, and reconciliation. Exposes gRPC endpoints consumed by the GraphQL gateway.

## Key Files
- `proto/payments.proto` — service contracts
- `internal/authorise/` — authorisation logic
- `internal/settle/` — settlement pipeline
- `cmd/server/main.go` — entry point

## Related
- [[Coding MOC]]
- [[API Platform Migration]]
- [[FinTech SaaS Integration]]'

  safe_write "$dir/brain-vault.md" '---
type: coding-project
repo-path: ~/coding/brain
language: Bash
framework: ""
status: active
tags: [coding]
---

# brain-vault

The Brain scaffolding tool itself — this vault was generated by it.

## Repository
- **Path**: `~/coding/brain`
- **Language**: Bash
- **Framework**: N/A

## Description
Obsidian + Claude Code vault scaffold. Generates opinionated vault structures with slash commands, note templates, and MOCs. Three architecture modes: Professional, Personal, Both.

## Key Files
- `setup.sh` — main setup script
- `demo.sh` — demo data population
- `templates/claude/commands/` — slash command definitions
- `templates/vault/` — note templates and MOCs

## Related
- [[Coding MOC]]
- [[Client Dashboard V2]]'

  safe_write "$dir/infra-as-code.md" '---
type: coding-project
repo-path: ~/coding/infra-as-code
language: HCL / YAML
framework: Terraform / ArgoCD
status: active
tags: [coding]
---

# infra-as-code

Infrastructure-as-code repository for Axiom Digital. Terraform for cloud resources, ArgoCD manifests for Kubernetes workloads.

## Repository
- **Path**: `~/coding/infra-as-code`
- **Language**: HCL (Terraform), YAML (K8s/ArgoCD)
- **Framework**: Terraform 1.7, ArgoCD 2.9

## Description
Single source of truth for all cloud infrastructure. Manages AWS resources across dev/staging/prod environments. ArgoCD watches this repo for GitOps deployments.

## Key Files
- `terraform/environments/` — per-environment configs
- `k8s/apps/` — ArgoCD application manifests
- `k8s/base/` — shared Kubernetes base configs
- `.github/workflows/` — Atlantis-like Terraform PR automation

## Related
- [[Coding MOC]]
- [[DevOps Pipeline Overhaul]]
- [[David Okafor]]'
}

# ──────────────────────────────────────────────────────────────────────────────
# Personal Notes
# ──────────────────────────────────────────────────────────────────────────────

create_personal_projects() {
  print_step "Creating personal project notes"
  local dir="$VAULT_ROOT/projects"

  safe_write "$dir/home-server-setup.md" "---
type: personal-project
status: active
priority: medium
start-date: ${PROJ_SERVER_START}
target-date: ${PROJ_SERVER_TARGET}
tags: [project]
---

# Home Server Setup

Build a home lab server for self-hosting: Nextcloud, Plex, and a local LLM inference endpoint.

## Overview
Repurposing an old desktop (i7-9700K, 32GB RAM) as a home server. Running Proxmox as the hypervisor with Ubuntu Server VMs.

## Goals
- Self-host Nextcloud for file sync (replace Google Drive)
- Run Plex Media Server for home media
- Host Ollama for local LLM inference (llama3, mistral)
- Set up VPN (Tailscale) for remote access

## Tasks
- [x] Install Proxmox on old desktop
- [x] Set up Ubuntu Server VM for Nextcloud
- [x] Nextcloud install and initial sync
- [ ] Set up Plex VM and import media library
- [ ] Install Ollama + pull llama3 model
- [ ] Configure Tailscale exit node
- [ ] Set up automated Proxmox backups

## Related
- [[Italian B1]] — Ollama useful for language practice prompts

## Progress Log

| Date | Update |
|------|--------|
| ${PROG_SERVER_PROX} | Proxmox installed, first VM up |
| ${PROG_SERVER_NEXT} | Nextcloud running, 180GB synced |
| ${DAYS[3]} | Explored Ollama — llama3 runs well at q4_K_M |"

  safe_write "$dir/photography-portfolio.md" "---
type: personal-project
status: on-hold
priority: low
start-date: ${PROJ_PHOTO_START}
target-date: \"\"
tags: [project]
---

# Photography Portfolio Website

Build a minimal portfolio site to showcase street photography work.

## Overview
A static site (Astro or Hugo) hosted on Vercel. Clean, photo-first design. No social features — just a curated gallery.

## Goals
- Curate best 40 photos from the past year
- Design minimal gallery layout
- Write short captions / context for each series
- Custom domain: alexchen.photos

## Tasks
- [ ] Shortlist 40 photos from Lightroom
- [ ] Choose framework (Astro vs Hugo)
- [ ] Design wireframe
- [ ] Build site skeleton
- [ ] Write captions
- [ ] Deploy to Vercel

## Related
- [[street-photography]]

## Progress Log

| Date | Update |
|------|--------|
| ${PROJ_PHOTO_START} | Idea captured, on hold until API Migration pressure eases |"

  safe_write "$dir/language-learning-app.md" "---
type: personal-project
status: active
priority: high
start-date: ${PROJ_LANG_START}
target-date: ${PROJ_LANG_TARGET}
tags: [project]
---

# Language Learning App

Side project: a spaced-repetition vocabulary app with Claude-powered conversation practice, built for Italian learners.

## Overview
Scratching my own itch. Existing apps (Duolingo, Anki) feel disconnected. This app integrates vocabulary SRS with open-ended conversation practice via the Claude API.

## Goals
- SRS algorithm for vocabulary review
- Claude API integration for conversation practice
- Simple iOS-friendly PWA
- 100 beta users by end of summer

## Tasks
- [x] Tech stack decision: Next.js + Supabase + Claude API
- [x] SRS algorithm prototype (TypeScript)
- [ ] Claude conversation API integration
- [ ] Basic UI — vocabulary review screen
- [ ] User auth (Supabase)
- [ ] Beta landing page

## Related
- [[Italian B1]]
- [[Maya Chen]] — UX feedback
- [[System Design Masterclass]] — architecture patterns

## Progress Log

| Date | Update |
|------|--------|
| ${PROJ_LANG_START} | Decided to build it. Stack: Next.js + Supabase |
| ${PROG_LANG_SRS} | SRS algorithm prototype working in tests |"
}

create_study_notes() {
  print_step "Creating study notes"
  local dir="$VAULT_ROOT/study"
  local current_semester
  current_semester=$(format_month_year "$DAYS[0]")

  safe_write "$dir/advanced-algorithms.md" "---
type: study
subject: Advanced Algorithms
semester: ${current_semester}
institution: Stanford Online
status: active
tags: [study]
---

# Advanced Algorithms

Stanford Online — CS161 equivalent. Refreshing fundamentals for interview prep and curiosity.

## Subject Info
- **Subject**: Advanced Algorithms (CS161)
- **Institution**: Stanford Online
- **Semester**: ${current_semester}

## Schedule

| Day | Time |
|-----|------|
| Tuesday | 19:00 – 20:30 |
| Saturday | 10:00 – 12:00 |

## Assignments
- [x] Problem Set 1 — Divide and Conquer
- [x] Problem Set 2 — Dynamic Programming
- [ ] Problem Set 3 — Graph Algorithms
- [ ] Final project — Algorithm analysis paper

## Grades

| Assignment | Grade | Weight |
|------------|-------|--------|
| Problem Set 1 | 95/100 | 15% |
| Problem Set 2 | 88/100 | 15% |
| Midterm | – | 30% |
| Final Project | – | 40% |

## Notes
Dynamic programming module clicked after implementing coin-change from scratch. Bellman-Ford is more intuitive than I remembered.

## Resources
- [[System Design Masterclass]] — complements the algorithms work
- Sedgewick & Wayne \"Algorithms\" (4th ed)"

  safe_write "$dir/italian-b1.md" "---
type: study
subject: Italian Language
semester: Self-directed
institution: Self-directed
status: active
tags: [study]
---

# Italian B1

Working toward B1 proficiency for a trip to Italy with [[Maya Chen]].

## Subject Info
- **Subject**: Italian (CEFR B1 target)
- **Institution**: Self-directed + iTalki tutors
- **Semester**: Ongoing

## Schedule

| Day | Time |
|-----|------|
| Monday | 07:30 – 08:00 (Duolingo + Anki) |
| Wednesday | 19:00 – 20:00 (iTalki lesson) |
| Saturday | 10:00 – 11:00 (grammar review) |

## Assignments
- [x] Complete \"Italian in 3 Months\" workbook Part 1
- [x] Reach A2 on CEFR self-assessment
- [ ] Pass Mondly B1 practice test
- [ ] Hold 10-minute unscripted conversation with tutor
- [ ] Complete \"Italian in 3 Months\" workbook Part 2

## Grades

| Milestone | Result | Date |
|-----------|--------|------|
| A1 self-test | Pass | ${STUDY_A1_DATE} |
| A2 self-test | Pass | ${STUDY_A2_DATE} |
| B1 target | – | ${STUDY_B1_TARGET} |

## Notes
Subjunctive mood is the hardest so far. Tutor Francesca recommends watching RAI news with Italian subtitles.

## Resources
- [[italian-conversation-practice]] hobby note
- [[Language Learning App]] — side project inspired by this"
}

create_courses() {
  print_step "Creating course notes"
  local dir="$VAULT_ROOT/courses"

  safe_write "$dir/system-design-masterclass.md" "---
type: course
platform: Udemy
instructor: Clement Mihailescu
url: \"\"
start-date: ${COURSE_SYSDES_START}
status: active
tags: [course]
---

# System Design Masterclass

Comprehensive system design course covering distributed systems, databases, and infrastructure at scale.

## Course Info
- **Platform**: Udemy
- **Instructor**: Clement Mihailescu (AlgoExpert)
- **URL**: udemy.com (enrolled)

## Modules
1. [x] Foundations of System Design
2. [x] Databases: SQL vs NoSQL, indexing, replication
3. [x] Distributed Systems: CAP theorem, consensus
4. [x] API Design: REST, gRPC, GraphQL
5. [ ] Caching Strategies
6. [ ] Message Queues and Event Streaming
7. [ ] Real-world Case Studies

## Progress
4 of 7 modules complete. ~60% through the course. Paused briefly for work projects.

## Notes
Module 4 on API design directly applicable to [[API Platform Migration]]. GraphQL vs gRPC trade-off discussion was exactly what I needed before the architecture review.

## Certificate
Will attempt certificate after completing all modules."

  safe_write "$dir/photography-lighting.md" '---
type: course
platform: Domestika
instructor: Miguel Quiles
url: ""
start-date: 2025-10-01
status: completed
tags: [course]
---

# Photography Lighting Masterclass

Off-camera flash and natural light techniques for portrait and street photography.

## Course Info
- **Platform**: Domestika
- **Instructor**: Miguel Quiles
- **URL**: domestika.org (completed)

## Modules
1. [x] Natural Light Fundamentals
2. [x] Introduction to Flash
3. [x] Off-Camera Flash Techniques
4. [x] Mixing Ambient and Artificial Light
5. [x] Location Scouting for Portraits

## Progress
Completed October 2025. Certificate issued.

## Notes
Module 3 transformed my approach to [[street-photography]]. Learning to read ambient light vs flash balance was the biggest unlock.

## Certificate
Issued: 2025-12-15 (Domestika certificate #4821)'
}

create_health_logs() {
  print_step "Creating health log notes"
  local dir="$VAULT_ROOT/health"
  local month_label
  month_label=$(format_month_year "${DAYS[0]}")

  safe_write "$dir/strength-training-month.md" "---
type: health-log
category: workout
date: ${HEALTH_STR1_DATE}
tags: [health]
---

# Strength Training — ${month_label} Habit Log

## Details
- **Category**: workout
- **Date**: ${HEALTH_STR1_DATE}

## Measurements

| Metric | Value |
|--------|-------|
| Squat (3x5) | 115 kg |
| Deadlift (1x5) | 140 kg |
| Bench Press (3x5) | 82.5 kg |
| Overhead Press (3x5) | 57.5 kg |

## Notes
Returning to StrongLifts 5x5 after a 3-week break. Weight slightly down from pre-break PRs. Goal: hit 120kg squat by end of month.

## Follow-up
- [ ] Increase squat by 2.5kg next session
- [ ] Check form on deadlift — lower back rounding slightly"

  safe_write "$dir/run-log.md" "---
type: health-log
category: workout
date: ${HEALTH_RUN_DATE}
tags: [health]
---

# Morning Run — ${HEALTH_RUN_DATE}

## Details
- **Category**: workout
- **Date**: ${HEALTH_RUN_DATE}

## Measurements

| Metric | Value |
|--------|-------|
| Distance | 8.2 km |
| Time | 42:30 |
| Pace | 5:11 /km |
| HR Average | 158 bpm |

## Notes
Easy aerobic run along the Embarcadero. Feeling good after the week of heavy lifts. [[Maya Chen]] joined for the last 3km.

## Follow-up
- [ ] Plan long run for Sunday (12km target)"

  safe_write "$dir/annual-checkup.md" "---
type: health-log
category: appointment
date: ${HEALTH_CHECKUP_DATE}
tags: [health]
---

# Annual Physical — ${HEALTH_CHECKUP_DATE}

## Details
- **Category**: appointment
- **Date**: ${HEALTH_CHECKUP_DATE}

## Measurements

| Metric | Value |
|--------|-------|
| Blood Pressure | 118/76 |
| Resting Heart Rate | 58 bpm |
| Weight | 78 kg |
| Blood Glucose | 4.9 mmol/L |
| Cholesterol (LDL) | 2.1 mmol/L |

## Notes
All results in healthy ranges. Dr. Yamamoto recommended continuing current exercise routine. Vitamin D slightly low (42 nmol/L) — suggested 1000 IU supplement daily.

## Follow-up
- [ ] Start Vitamin D 1000 IU supplement
- [ ] Book dentist appointment (overdue 6 months)"

  safe_write "$dir/sleep-habit-month.md" "---
type: health-log
category: habit
date: ${DAYS[0]}
tags: [health]
---

# Sleep Tracking — ${month_label}

## Details
- **Category**: habit
- **Date**: ${DAYS[0]}

## Measurements

| Metric | Value |
|--------|-------|
| Average sleep (wk 1) | 7h 12m |
| Average sleep (wk 2) | 6h 48m |
| Average sleep (wk 3) | 7h 30m |
| Target | 7h 30m+ |

## Notes
Week 2 was rough — late nights on the [[API Platform Migration]] deadline. Oura ring data shows deep sleep improves significantly when I stop screens at 10pm.

## Follow-up
- [ ] Set phone \"wind down\" mode to 21:45 daily
- [ ] Experiment with magnesium glycinate before bed"

  safe_write "$dir/strength-training-month-wk3.md" "---
type: health-log
category: workout
date: ${HEALTH_STR3_DATE}
tags: [health]
---

# Strength Training — Week 3

## Details
- **Category**: workout
- **Date**: ${HEALTH_STR3_DATE}

## Measurements

| Metric | Value |
|--------|-------|
| Squat (3x5) | 120 kg |
| Deadlift (1x5) | 145 kg |
| Bench Press (3x5) | 85 kg |
| Overhead Press (3x5) | 60 kg |

## Notes
Hit the 120kg squat target! Form felt solid — no lower back rounding. Deadlift is moving well. Considering moving to 3x3 at higher weight now.

## Follow-up
- [ ] Test 1RM squat next Saturday
- [ ] Look into Texas Method for next training block"

  safe_write "$dir/meditation-habit.md" "---
type: health-log
category: habit
date: ${DAYS[0]}
tags: [health]
---

# Meditation — ${month_label} Habit Tracking

## Details
- **Category**: habit
- **Date**: ${DAYS[0]}

## Measurements

| Metric | Value |
|--------|-------|
| Sessions completed (wk 1) | 5/7 |
| Sessions completed (wk 2) | 4/7 |
| Sessions completed (wk 3) | 6/7 |
| Average session length | 12 min |

## Notes
Using Waking Up app — Sam Harris' 30-day course. Noticing less reactive during stressful work conversations. Will track alongside [[sleep-habit-month]] to see correlation.

## Follow-up
- [ ] Complete 30-day Waking Up course
- [ ] Try a longer 20-minute session"
}

create_finance_notes() {
  print_step "Creating finance notes"
  local dir="$VAULT_ROOT/finances"
  local month_label
  month_label=$(format_month_year "${DAYS[0]}")
  local prev_month_label
  prev_month_label=$(format_month_year "$PAST_1W")

  safe_write "$dir/rent.md" "---
type: finance
category: housing
amount: \"3200\"
date: ${FINANCE_RENT_DATE}
recurring: true
tags: [finance]
---

# ${month_label} — Rent

## Details
- **Category**: housing
- **Amount**: \$3,200
- **Date**: ${FINANCE_RENT_DATE}
- **Recurring**: true (monthly, 1st)

## Notes
Mission District apartment. Split equally with [[Maya Chen]] (\$1,600 each). Lease renewed at same rate — good outcome given SF market.

## Related
- [[Finance MOC]]"

  safe_write "$dir/gym-membership.md" "---
type: finance
category: health
amount: \"85\"
date: ${FINANCE_GYM_DATE}
recurring: true
tags: [finance]
---

# Gym Membership — Monthly

## Details
- **Category**: health
- **Amount**: \$85
- **Date**: ${FINANCE_GYM_DATE}
- **Recurring**: true (monthly)

## Notes
Equinox Fillmore. Pricy but the squat racks are always free before 7am. Directly tied to [[strength-training-month]] habit.

## Related
- [[Health MOC]]"

  safe_write "$dir/conference-ticket.md" "---
type: finance
category: professional development
amount: \"1299\"
date: ${FINANCE_CONF_DATE}
recurring: false
tags: [finance]
---

# Conference Ticket — QCon SF

## Details
- **Category**: professional development
- **Amount**: \$1,299
- **Date**: ${FINANCE_CONF_DATE}
- **Recurring**: false

## Notes
QCon San Francisco. Sessions on distributed systems, platform engineering, and AI/LLM integration in production. Directly relevant to [[API Platform Migration]] and [[Language Learning App]].

Expensing \$800 through Axiom Digital; paying \$499 out of pocket.

## Related
- [[API Platform Migration]]
- [[System Design Masterclass]]"

  safe_write "$dir/freelance-income.md" "---
type: finance
category: income
amount: \"3500\"
date: ${FINANCE_FREELANCE_DATE}
recurring: false
tags: [finance]
---

# Freelance Income — ${prev_month_label}

## Details
- **Category**: income
- **Amount**: \$3,500
- **Date**: ${FINANCE_FREELANCE_DATE}
- **Recurring**: false

## Notes
Consulting hours for [[FinTech SaaS Integration]] — final milestone payment. Invoiced through personal LLC. Allocated: \$1,500 to emergency fund, \$2,000 to brokerage (VTSAX).

## Related
- [[FinTech SaaS Integration]]
- [[Finance MOC]]"
}

create_family_events() {
  print_step "Creating family event notes"
  local dir="$VAULT_ROOT/family"
  local grad_short
  grad_short=$(format_date_short "$EVENT_GRADUATION")
  local anniv_short
  anniv_short=$(format_date_short "$EVENT_ANNIVERSARY")
  local grad_night
  grad_night=$(offset_date "$EVENT_GRADUATION" -1)

  safe_write "$dir/lilys-graduation.md" "---
type: family-event
date: ${EVENT_GRADUATION}
participants: [Alex Chen, Maya Chen, Mom Chen, Dad Chen]
tags: [family]
---

# Lily Graduation Ceremony

## Event
- **Date**: ${grad_short}
- **Location**: UC Berkeley, Haas Pavilion

## Participants
- Alex Chen
- [[Maya Chen]]
- [[Mom Chen]]
- Dad Chen
- [[Lily Chen]] (graduate!)

## Notes
[[Lily Chen]] graduates from UC Berkeley with a BS in Computer Science. Planning to drive down the night before and stay at a hotel in Berkeley.

Looking into restaurants for a post-ceremony dinner — Chez Panisse is the dream but needs booking soon.

## Follow-up
- [ ] Book hotel in Berkeley for $(format_date_short "$grad_night") – $(format_date_short "$EVENT_GRADUATION")
- [ ] Make dinner reservation (Chez Panisse or Rivoli)
- [ ] Buy graduation gift — consider a MacBook Pro"

  safe_write "$dir/parents-anniversary-dinner.md" "---
type: family-event
date: ${EVENT_ANNIVERSARY}
participants: [Alex Chen, Maya Chen, Mom Chen, Dad Chen]
tags: [family]
---

# Parents Anniversary Dinner

## Event
- **Date**: ${anniv_short}
- **Location**: Atelier Crenn, San Francisco

## Participants
- Alex Chen
- [[Maya Chen]]
- [[Mom Chen]]
- Dad Chen

## Notes
35th wedding anniversary. Booked Atelier Crenn — 3-star Michelin, Mom has always wanted to go. Reservation at 7pm. Splitting cost with [[Lily Chen]].

## Follow-up
- [x] Make reservation at Atelier Crenn
- [ ] Buy flowers to bring
- [ ] Arrange Lyft (no parking near restaurant)"
}

create_hobbies() {
  print_step "Creating hobby notes"
  local dir="$VAULT_ROOT/hobby"

  safe_write "$dir/street-photography.md" "---
type: hobby
hobby-name: Street Photography
status: active
tags: [hobby]
---

# Street Photography

Urban photography — candid moments, architectural details, light and shadow in city environments.

## Description
Shooting with a Fuji X100VI. Primarily Mission District, Chinatown, and the Embarcadero. Inspired by Vivian Maier and Garry Winogrand. Black and white is my preferred edit style.

## Goals
- Shoot at least once a week
- Build a portfolio of 40 selects for [[photography-portfolio]]
- Submit to one juried exhibition this year
- Complete [[Photography Lighting Masterclass]] learnings in the field

## Progress Log

| Date | Update |
|------|--------|
| ${HOBBY_PHOTO1_DATE} | New Fuji X100VI arrived — first outing in Mission |
| ${HOBBY_PHOTO2_DATE} | Shot the Lunar New Year parade in Chinatown — 800 frames, 12 selects |
| ${HOBBY_PHOTO3_DATE} | Saturday dawn shoot at the Ferry Building — best light of the year so far |

## Resources
- [[Photography Lighting Masterclass]]
- [[photography-portfolio]]

## Related
- [[photography-portfolio]]"

  safe_write "$dir/italian-conversation-practice.md" "---
type: hobby
hobby-name: Italian Conversation
status: active
tags: [hobby]
---

# Italian Conversation Practice

Weekly iTalki lessons and independent practice to reach B1 conversational fluency.

## Description
Working with a native Italian tutor (Francesca, from Rome) for weekly 55-minute conversation lessons. Supplemented with Anki vocabulary, RAI news listening, and the [[Language Learning App]] I'm building.

## Goals
- Hold a 10-minute unscripted conversation by ${QUARTER_NEXT}
- Order food, give directions, and discuss current events in Italian
- Reach B1 on CEFR self-assessment before the Italy trip (see [[Italian B1]])

## Progress Log

| Date | Update |
|------|--------|
| ${HOBBY_ITAL1_DATE} | Started iTalki lessons with Francesca |
| ${HOBBY_ITAL2_DATE} | First full conversation about daily routine — slow but complete |
| ${HOBBY_ITAL3_DATE} | Discussed the news for 5 minutes with minimal prompting — progress! |

## Resources
- [[Italian B1]]
- [[Language Learning App]]

## Related
- [[Maya Chen]] — planning Italy trip together"
}

# ──────────────────────────────────────────────────────────────────────────────
# Daily Notes
# ──────────────────────────────────────────────────────────────────────────────

write_daily() {
  # write_daily <filepath> <content>
  local filepath="$1"
  local content="$2"
  if [ -f "$filepath" ]; then
    print_warn "Skipping (exists): $(basename "$filepath")"
    SKIPPED=$((SKIPPED + 1))
  else
    printf '%s\n' "$content" > "$filepath"
    print_success "Created: $(basename "$filepath")"
    CREATED=$((CREATED + 1))
  fi
}

create_daily_notes() {
  print_step "Creating daily notes"
  local dir="$VAULT_ROOT/daily"
  local arch="$1"  # professional | personal | both

  # Per-day content as parallel arrays, indexed 0..19
  local -a DN_TASKS DN_NOTES DN_HEALTH DN_GRAT DN_LINKS DN_MEETING

  DN_MEETING=( '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' )

  DN_TASKS[0]='- [x] Review gRPC contracts v0.1
- [ ] Update [[API Platform Migration]] progress log
- [ ] Reply to Sarah on phase 2 timeline'
  DN_NOTES[0]='GraphQL gateway POC is promising. Apollo Federation docs are excellent.'
  DN_HEALTH[0]='Morning walk 20 min. StrongLifts — squat 115 kg.'
  DN_GRAT[0]='Grateful for a technically interesting project with clear scope.'
  DN_LINKS[0]='[[API Platform Migration]], [[payments-api]]'

  DN_TASKS[1]='- [x] Write unit tests for payments-api authorise handler
- [x] Italian vocab review with Anki
- [ ] Book hotel for [[Lily Graduation Ceremony]]'
  DN_NOTES[1]='Algorithms problem set 2 harder than expected — spent 2h on DP table design.'
  DN_HEALTH[1]='Rest day. 8k steps.'
  DN_GRAT[1]='Grateful for the algorithms course — makes evening learning feel like play.'
  DN_LINKS[1]='[[Advanced Algorithms]], [[Lily Graduation Ceremony]]'

  DN_TASKS[2]='- [x] Deploy GraphQL gateway POC to staging
- [ ] Load test at 1k RPS
- [ ] Street photography walk after work'
  DN_NOTES[2]='Staging benchmark results better than expected. Will share with Sarah tomorrow.'
  DN_HEALTH[2]='Strength training — bench press 82.5 kg.'
  DN_GRAT[2]='Grateful the gateway POC worked first try.'
  DN_LINKS[2]='[[API Platform Migration]], [[Client Dashboard V2]]'

  DN_MEETING[3]="- 14:00 [[${MEETING_ARCH_DATE}-architecture-review]] with [[James Liu]] and [[Sarah Morgan]]"
  DN_TASKS[3]='- [x] Prepare architecture comparison doc for review
- [x] Apollo Federation spike complete
- [ ] Send meeting notes to James and Sarah'
  DN_NOTES[3]='Architecture review went well. Apollo Federation decision made. Notes sent.'
  DN_HEALTH[3]='Walk after work — 6k steps.'
  DN_GRAT[3]='Grateful for a clear architecture decision — momentum restored.'
  DN_LINKS[3]="[[${MEETING_ARCH_DATE}-architecture-review]], [[TechCorp Enterprise Deal]]"

  DN_TASKS[4]='- [x] Friday retro notes
- [ ] [[photography-portfolio]] — cull last weekend shoot
- [ ] Grocery run with [[Maya Chen]]'
  DN_NOTES[4]='Good end to the week. Quarter is shaping up. Taking Saturday morning to shoot.'
  DN_HEALTH[4]='8.2 km run along Embarcadero — 42:30.'
  DN_GRAT[4]='Grateful for Friday photography time — brain recharge.'
  DN_LINKS[4]='[[street-photography]], [[photography-portfolio]]'

  DN_TASKS[5]='- [x] Weekly planning session
- [ ] Read 2 chapters of Sedgewick algorithms
- [ ] [[Advanced Algorithms]] problem set 2'
  DN_NOTES[5]='Slow start after the weekend. Algorithms book is genuinely enjoyable.'
  DN_HEALTH[5]='Rest day — legs sore from Friday run.'
  DN_GRAT[5]='Grateful for a quiet Monday morning to plan the week.'
  DN_LINKS[5]='[[Advanced Algorithms]]'

  DN_MEETING[6]="- 10:00 [[${MEETING_KICKOFF_DATE}-client-kickoff]] with [[Sarah Morgan]] and [[Priya Patel]]"
  DN_TASKS[6]='- [x] Phase 1 sign-off docs prepared
- [x] Set up #api-migration Slack channel
- [ ] Update [[TechCorp Enterprise Deal]] timeline'
  DN_NOTES[6]='Phase 1 officially signed off. Big milestone for the TechCorp deal.'
  DN_HEALTH[6]='Strength training — squat 117.5 kg.'
  DN_GRAT[6]='Grateful for the partnership with Sarah — phase 1 sign-off felt earned.'
  DN_LINKS[6]="[[${MEETING_KICKOFF_DATE}-client-kickoff]], [[API Platform Migration]]"

  DN_TASKS[7]='- [x] GraphQL gateway latency benchmark — 340ms P50
- [ ] React RBAC component research
- [ ] Waking Up meditation — 12 min'
  DN_NOTES[7]='Kafka latency numbers are excellent. Dashboard V2 is looking strong.'
  DN_HEALTH[7]='Morning walk 20 min. Felt low energy.'
  DN_GRAT[7]='Grateful for the Kafka results — technical risk resolved.'
  DN_LINKS[7]='[[Client Dashboard V2]]'

  DN_MEETING[8]='- 09:30 Annual physical — Dr. Yamamoto'
  DN_TASKS[8]='- [x] Annual checkup — all good, start Vitamin D
- [ ] Order Vitamin D supplements
- [ ] [[italian-conversation-practice]] prep for Wednesday lesson'
  DN_NOTES[8]='Annual checkup clear — doctor happy with fitness markers. Vitamin D low — starting supplement.'
  DN_HEALTH[8]='Annual physical — all markers good.'
  DN_GRAT[8]='Grateful for good health markers. Annual checkup always a relief.'
  DN_LINKS[8]="[[annual-checkup]], [[Italian B1]]"

  DN_TASKS[9]='- [x] Kafka pipeline POC refactor
- [x] PR review for David infra change
- [ ] Friday photography walk — Chinatown'
  DN_NOTES[9]='Productive Friday. David infra PR was clean — approved quickly.'
  DN_HEALTH[9]='Street photography walk — 12k steps.'
  DN_GRAT[9]='Grateful for the Chinatown light this evening — golden hour exceptional.'
  DN_LINKS[9]='[[payments-api]], [[street-photography]]'

  DN_TASKS[10]='- [x] Weekly review — milestone check
- [ ] [[Advanced Algorithms]] problem set 3
- [ ] Plan parents anniversary dinner logistics'
  DN_NOTES[10]='Final month of quarter. API migration and dashboard both on track.'
  DN_HEALTH[10]='Strength training — squat 120 kg target hit!'
  DN_GRAT[10]='Grateful for a team delivering without drama.'
  DN_LINKS[10]='[[Advanced Algorithms]], [[Parents Anniversary Dinner]]'

  DN_MEETING[11]="- 09:30 [[${MEETING_SPRINT_DATE}-sprint-planning]] with [[Priya Patel]] and [[David Okafor]]"
  DN_TASKS[11]='- [x] Sprint 4 stories groomed and pointed
- [ ] RBAC middleware implementation start
- [ ] [[System Design Masterclass]] module 5 — caching'
  DN_NOTES[11]='Sprint 4 is well-planned. RBAC is the critical path item this sprint.'
  DN_HEALTH[11]='Rest day.'
  DN_GRAT[11]="Grateful for Priya's calm energy in sprint planning."
  DN_LINKS[11]="[[${MEETING_SPRINT_DATE}-sprint-planning]], [[Client Dashboard V2]]"

  DN_TASKS[12]='- [x] RBAC middleware — auth layer complete
- [ ] Write integration tests for RBAC
- [ ] iTalki lesson prep'
  DN_NOTES[12]='RBAC auth layer done in one session — clean design pays off.'
  DN_HEALTH[12]='5 km easy run — 27 min.'
  DN_GRAT[12]='Grateful for clean code that is easy to extend.'
  DN_LINKS[12]='[[Client Dashboard V2]], [[italian-conversation-practice]]'

  DN_TASKS[13]='- [x] PR review x3
- [x] Italian lesson with Francesca — discussed news topics
- [ ] Morning run — Embarcadero route'
  DN_NOTES[13]='Italian lesson was the best yet — held 5 minutes of unscripted conversation.'
  DN_HEALTH[13]='Strength training — OHP 60 kg.'
  DN_GRAT[13]='Grateful for Francesca — the Italian lessons are genuinely fun.'
  DN_LINKS[13]='[[Italian B1]], [[italian-conversation-practice]]'

  DN_MEETING[14]="- 11:00 [[${MEETING_1ON1_DATE}-team-1on1]] with [[David Okafor]]"
  DN_TASKS[14]='- [x] 1:1 with David — DevOps pipeline status reviewed
- [x] Patch plan confirmed
- [ ] [[photography-portfolio]] shortlist review'
  DN_NOTES[14]='DevOps situation under control. David has a solid patch plan.'
  DN_HEALTH[14]='Walk — 9k steps.'
  DN_GRAT[14]='Grateful David caught the Jenkins risk before it became a fire.'
  DN_LINKS[14]="[[${MEETING_1ON1_DATE}-team-1on1]], [[DevOps Pipeline Overhaul]]"

  DN_TASKS[15]='- [x] Monday planning — final push
- [ ] Write team summary for Notion
- [ ] [[Advanced Algorithms]] — graph algorithms reading'
  DN_NOTES[15]='Final week of quarter. Feeling good about where things stand.'
  DN_HEALTH[15]='Strength training — deadlift 145 kg.'
  DN_GRAT[15]='Grateful the quarter is ending on a high note.'
  DN_LINKS[15]='[[Advanced Algorithms]], [[API Platform Migration]]'

  DN_TASKS[16]='- [x] Quarterly review prep
- [ ] Update presentation slides
- [ ] [[System Design Masterclass]] module 5 — caching'
  DN_NOTES[16]='Quarter in review looks strong. Team delivered well.'
  DN_HEALTH[16]='Rest day.'
  DN_GRAT[16]='Grateful for a productive quarter to review.'
  DN_LINKS[16]='[[API Platform Migration]], [[Client Dashboard V2]]'

  DN_MEETING[17]="- 14:00 [[${MEETING_QUARTERLY_DATE}-quarterly-review]]"
  DN_TASKS[17]="- [x] ${QUARTER_CURRENT} quarterly review prep
- [x] Quarterly review meeting
- [ ] Post summary to team Notion by Friday"
  DN_NOTES[17]="${QUARTER_CURRENT} quarterly review was energising. Team delivered well."
  DN_HEALTH[17]='Rest day after heavy week.'
  DN_GRAT[17]='Grateful for an honest quarterly review — the team was candid.'
  DN_LINKS[17]="[[${MEETING_QUARTERLY_DATE}-quarterly-review]], [[API Platform Migration]]"

  DN_TASKS[18]='- [x] RBAC integration tests complete
- [ ] Performance test run — P95 target
- [ ] Book restaurant for [[Lily Graduation Ceremony]] dinner'
  DN_NOTES[18]='Almost at the finish line for Sprint 4 RBAC work.'
  DN_HEALTH[18]='5 km run — 26:30.'
  DN_GRAT[18]='Grateful that the hard RBAC work is almost done.'
  DN_LINKS[18]='[[Client Dashboard V2]], [[Lily Graduation Ceremony]]'

  DN_TASKS[19]="- [x] ${QUARTER_CURRENT} wrap — sent summary to team
- [x] [[payments-api]] v1.4 tagged and released
- [ ] Weekend plan: long run and photography"
  DN_NOTES[19]='Closed the quarter strong. Looking forward to conference next month.'
  DN_HEALTH[19]='Long run planned for weekend — saved energy today.'
  DN_GRAT[19]='Grateful for [[Maya Chen]] — this quarter was intense, and she was steady throughout.'
  DN_LINKS[19]='[[Language Learning App]], [[photography-portfolio]]'

  for i in "${!DAYS[@]}"; do
    local d="${DAYS[$i]}"
    local tasks="${DN_TASKS[$i]}"
    local notes="${DN_NOTES[$i]}"
    local health="${DN_HEALTH[$i]}"
    local gratitude="${DN_GRAT[$i]}"
    local links="${DN_LINKS[$i]}"
    local meeting="${DN_MEETING[$i]}"
    local long_date
    long_date=$(format_date_long "$d")

    if [ "$arch" = "professional" ]; then
      local mtg_block
      if [ -n "$meeting" ]; then
        mtg_block="## Meetings

${meeting}"
      else
        mtg_block="## Meetings

— no meetings"
      fi
      write_daily "$dir/$d.md" "---
date: $d
type: daily
tags: [daily]
---

# ${long_date}

${mtg_block}

## Tasks

${tasks}

## Notes

${notes}

## Links Created Today

${links}"

    elif [ "$arch" = "personal" ]; then
      write_daily "$dir/$d.md" "---
date: $d
type: daily
tags: [daily]
---

# ${long_date}

## Health

${health}

## Tasks

${tasks}

## Study / Learning

See [[Advanced Algorithms]] and [[Italian B1]] for ongoing tracks.

## Notes

${notes}

## Gratitude

${gratitude}

## Links Created Today

${links}"

    else  # both
      local mtg_block
      if [ -n "$meeting" ]; then
        mtg_block="## Meetings

${meeting}"
      else
        mtg_block="## Meetings

— no meetings"
      fi
      write_daily "$dir/$d.md" "---
date: $d
type: daily
tags: [daily]
---

# ${long_date}

${mtg_block}

## Health

${health}

## Tasks

${tasks}

## Study / Learning

See [[Advanced Algorithms]] and [[Italian B1]] for ongoing tracks.

## Notes

${notes}

## Gratitude

${gratitude}

## Links Created Today

${links}"
    fi
  done
}

# ──────────────────────────────────────────────────────────────────────────────
# Today's Notes — enables /closeday demo
# ──────────────────────────────────────────────────────────────────────────────

create_today_notes() {
  print_step "Creating today's notes (for /closeday demo)"
  local arch="$1"  # professional | personal | both

  # ── Today's daily note ───────────────────────────────────────────────
  local dir="$VAULT_ROOT/daily"

  if [ "$arch" = "professional" ]; then
    write_daily "$dir/$TODAY.md" "---
date: $TODAY
type: daily
tags: [daily]
---

# ${TODAY_LONG}

## Meetings

- 10:00 Sprint standup — quick status sync with [[Priya Patel]]
- 14:30 [[Sarah Morgan]] async follow-up on Phase 2 deployment plan

## Tasks

- [x] Review PR for GraphQL gateway schema changes
- [x] Update [[API Platform Migration]] progress log
- [ ] Draft Phase 2 deployment timeline
- [ ] Respond to Sarah on infra team onboarding
- [ ] Review [[David Okafor]] Jenkins patch results

## Notes

Good progress day. Gateway schema review went smoothly — approved with minor comments. Phase 2 deployment planning is the main focus this week.

## Links Created Today

[[API Platform Migration]], [[TechCorp Enterprise Deal]]"

  elif [ "$arch" = "personal" ]; then
    write_daily "$dir/$TODAY.md" "---
date: $TODAY
type: daily
tags: [daily]
---

# ${TODAY_LONG}

## Health

Morning strength training — squat 120 kg, bench 85 kg. Feeling strong.

## Tasks

- [x] [[Advanced Algorithms]] — graph algorithms chapter reading
- [x] Italian vocab review (30 min Anki)
- [ ] [[Language Learning App]] — Claude API integration spike
- [ ] Book hotel for [[Lily Graduation Ceremony]]
- [ ] Reply to Francesca about rescheduling iTalki lesson

## Study / Learning

See [[Advanced Algorithms]] and [[Italian B1]] for ongoing tracks.

## Notes

Graph algorithms chapter was excellent — Dijkstra's makes much more sense now with the priority queue visualisation. Language app Claude integration is exciting but need to timebox it.

## Gratitude

Grateful for a focused morning — gym + study before 9am sets the whole day up right.

## Links Created Today

[[Advanced Algorithms]], [[Language Learning App]], [[Italian B1]]"

  else  # both
    write_daily "$dir/$TODAY.md" "---
date: $TODAY
type: daily
tags: [daily]
---

# ${TODAY_LONG}

## Meetings

- 10:00 Sprint standup — quick status sync with [[Priya Patel]]
- 14:30 [[Sarah Morgan]] async follow-up on Phase 2 deployment plan

## Health

Morning strength training — squat 120 kg, bench 85 kg. Feeling strong.

## Tasks

- [x] Review PR for GraphQL gateway schema changes
- [x] Update [[API Platform Migration]] progress log
- [x] [[Advanced Algorithms]] — graph algorithms chapter reading
- [x] Italian vocab review (30 min Anki)
- [ ] Draft Phase 2 deployment timeline
- [ ] [[Language Learning App]] — Claude API integration spike
- [ ] Book hotel for [[Lily Graduation Ceremony]]
- [ ] Review [[David Okafor]] Jenkins patch results

## Study / Learning

See [[Advanced Algorithms]] and [[Italian B1]] for ongoing tracks.

## Notes

Good progress day. Gateway schema review went smoothly — approved with minor comments. Graph algorithms chapter was excellent. Language app Claude integration is exciting but need to timebox it.

## Gratitude

Grateful for a focused morning — gym + study before 9am sets the whole day up right.

## Links Created Today

[[API Platform Migration]], [[Advanced Algorithms]], [[Language Learning App]], [[TechCorp Enterprise Deal]]"
  fi

  # ── Today's meeting note (professional & both only) ────────────────
  if [ "$arch" = "professional" ] || [ "$arch" = "both" ]; then
    local mdir="$VAULT_ROOT/meetings"
    safe_write "$mdir/${TODAY}-standup.md" "---
date: ${TODAY}
time: \"10:00\"
type: meeting
attendees: [Alex Chen, Priya Patel]
project: client-dashboard-v2
tags: [meeting]
---

# Meeting: Sprint Standup

## Context
- **Project**: [[Client Dashboard V2]]
- **Attendees**: Alex Chen, [[Priya Patel]]
- **Goal**: Quick status sync on Sprint 4 progress

## Discussion
RBAC integration tests passing. Beta rollout comms drafted by Priya — ready for review. Performance testing scheduled for this week.

## Decisions
- Beta rollout email goes out tomorrow after Alex reviews
- Performance test target: P95 under 2s with 100 concurrent users

## Action Items
- [ ] Alex: Review beta rollout communication draft
- [ ] Alex: Run P95 performance test
- [ ] Priya: Prepare pilot client onboarding checklist"
  fi
}

# ──────────────────────────────────────────────────────────────────────────────
# MOC Updates
# ──────────────────────────────────────────────────────────────────────────────

update_mocs_professional() {
  print_step "Updating professional MOCs"
  local maps="$VAULT_ROOT/maps"

  force_write "$maps/Projects MOC.md" "---
type: moc
tags: [moc, project]
---

# Projects

## Active

- [[API Platform Migration]] — TechCorp, GraphQL + gRPC migration, due $(format_date_short "$PROJ_API_TARGET")
- [[Client Dashboard V2]] — Internal, React 18 + Kafka pipeline, due $(format_date_short "$PROJ_DASH_TARGET")

## On Hold

- [[DevOps Pipeline Overhaul]] — Jenkins to GitHub Actions + ArgoCD"

  force_write "$maps/Commercials MOC.md" '---
type: moc
tags: [moc, commercial]
---

# Commercials

## Active

- [[TechCorp Enterprise Deal]] — $320k, API platform modernisation

## Won

- [[FinTech SaaS Integration]] — $95k, payment gateway integration

## Lost

- [[Retail Analytics Platform]] — $150k, lost on price'

  force_write "$maps/Coding MOC.md" '---
type: moc
tags: [moc, coding]
---

# Coding Projects

## Active Repositories

- [[payments-api]] — Go/gRPC, payment processing service
- [[brain-vault]] — Bash, this vault scaffold
- [[infra-as-code]] — Terraform/ArgoCD, infrastructure-as-code'
}

update_mocs_personal() {
  print_step "Updating personal MOCs"
  local maps="$VAULT_ROOT/maps"

  # Only write personal Projects MOC if not "both" (both gets combined version)
  if [ "$ARCHITECTURE" != "both" ]; then
    force_write "$maps/Projects MOC.md" '---
type: moc
tags: [moc, project]
---

# Projects

## Active

- [[Home Server Setup]] — Proxmox home lab, Nextcloud + Ollama
- [[Language Learning App]] — Next.js + Claude API, Italian SRS app

## On Hold

- [[Photography Portfolio]] — Static portfolio site, paused'
  fi

  force_write "$maps/Study MOC.md" '---
type: moc
tags: [moc, study]
---

# Study

## Current

- [[Advanced Algorithms]] — Stanford Online, CS161 equivalent
- [[Italian B1]] — Self-directed + iTalki, CEFR B1 target'

  force_write "$maps/Courses MOC.md" '---
type: moc
tags: [moc, course]
---

# Courses

## In Progress

- [[System Design Masterclass]] — Udemy, 60% complete

## Completed

- [[Photography Lighting Masterclass]] — Domestika, completed Oct 2025'

  force_write "$maps/Health MOC.md" '---
type: moc
tags: [moc, health]
---

# Health

## Fitness

- [[strength-training-month]] — StrongLifts 5x5, current cycle
- [[run-log]] — Running log

## Medical

- [[annual-checkup]] — Annual physical

## Habits

- [[sleep-habit-month]] — Sleep tracking
- [[meditation-habit]] — Waking Up app, 30-day course'

  force_write "$maps/Finance MOC.md" '---
type: moc
tags: [moc, finance]
---

# Finance

## Recurring

- [[rent]] — $3,200/mo (split with Maya)
- [[gym-membership]] — $85/mo, Equinox

## Recent

- [[conference-ticket]] — QCon SF, $1,299
- [[freelance-income]] — $3,500, FinTech milestone'

  force_write "$maps/Family MOC.md" '---
type: moc
tags: [moc, family]
---

# Family

## Upcoming Events

- [[Lily Graduation Ceremony]] — UC Berkeley
- [[Parents Anniversary Dinner]] — Atelier Crenn

## People

- [[Maya Chen]] — Partner
- [[Lily Chen]] — Sister
- [[Mom Chen]] — Mom'

  force_write "$maps/Hobbies MOC.md" '---
type: moc
tags: [moc, hobby]
---

# Hobbies

## Active

- [[street-photography]] — Fuji X100VI, urban photography
- [[italian-conversation-practice]] — Weekly iTalki lessons'
}

# ──────────────────────────────────────────────────────────────────────────────
# Session Analytics
# ──────────────────────────────────────────────────────────────────────────────

create_session_analytics() {
  print_step "Creating session analytics data"
  local dir="$VAULT_ROOT/_analytics/sessions"
  mkdir -p "$dir"

  # Copy token-pricing config if not present
  local pricing="$VAULT_ROOT/_analytics/token-pricing.md"
  if [ ! -f "$pricing" ]; then
    safe_write "$pricing" '---
type: config
tags: [analytics, config]
---

# Token Pricing

Reference pricing for Claude Code session cost estimates. Update these values when Anthropic changes pricing.

| Model | Input $/1M | Output $/1M | Cache Read $/1M | Cache Write $/1M |
|-------|-----------|------------|----------------|-----------------|
| claude-opus-4-6 | 15.00 | 75.00 | 1.50 | 18.75 |
| claude-sonnet-4-6 | 3.00 | 15.00 | 0.30 | 3.75 |
| claude-haiku-4-5 | 0.80 | 4.00 | 0.08 | 1.00 |

> Pricing source: [Anthropic Pricing](https://www.anthropic.com/pricing)
> Last updated: 2025-05'
  fi

  # Per-day session analytics data (parallel arrays indexed 0..19)
  # Varying sessions (1-4 per day), tokens, and costs for realistic patterns
  local -a SA_SESSIONS SA_INPUT SA_OUTPUT SA_CACHE_R SA_CACHE_W SA_COST SA_MODELS
  local -a SA_DETAIL  # per-session breakdown markdown

  SA_SESSIONS=( 2 3 1 4 1 3 2 2 3 1 4 2 3 2 1 3 2 3 2 1 )
  SA_INPUT=(    38420 52100 18500 89200 15200 64800 42300 35400 71500 21800 95600 44100 58200 32800 16400 72400 38900 62100 41200 19800 )
  SA_OUTPUT=(   12850 18900 6200 34500 4800 22100 15600 11200 28400 7100 38200 16800 21500 10500 5200 29800 14200 24600 15800 6400 )
  SA_CACHE_R=(  524000 892000 310000 1450000 245000 980000 678000 520000 1180000 345000 1620000 710000 920000 485000 260000 1240000 620000 1050000 690000 312000 )
  SA_CACHE_W=(  18200 24500 9800 42000 7500 31000 19800 16500 35200 10200 48000 21500 28600 15200 8100 36500 18800 30200 20100 9600 )
  SA_COST=(     2.05 3.12 0.98 5.87 0.72 3.94 2.68 1.89 4.62 1.12 6.34 2.82 3.68 1.74 0.82 4.78 2.42 4.18 2.58 1.02 )
  SA_MODELS=(
    'claude-opus-4-6'
    'claude-opus-4-6, claude-sonnet-4-6'
    'claude-sonnet-4-6'
    'claude-opus-4-6'
    'claude-sonnet-4-6'
    'claude-opus-4-6'
    'claude-opus-4-6, claude-sonnet-4-6'
    'claude-sonnet-4-6'
    'claude-opus-4-6'
    'claude-sonnet-4-6'
    'claude-opus-4-6'
    'claude-opus-4-6, claude-sonnet-4-6'
    'claude-opus-4-6'
    'claude-sonnet-4-6'
    'claude-sonnet-4-6'
    'claude-opus-4-6'
    'claude-opus-4-6, claude-sonnet-4-6'
    'claude-opus-4-6'
    'claude-opus-4-6'
    'claude-sonnet-4-6'
  )

  # Session detail blocks (per-session breakdowns)
  SA_DETAIL[0]='### Session 1 — 09:15 to 10:42
| Metric | Value |
|--------|-------|
| Messages | 18 |
| Input Tokens | 22,100 |
| Output Tokens | 8,350 |
| Cost | $1.29 |

### Session 2 — 14:30 to 15:15
| Metric | Value |
|--------|-------|
| Messages | 11 |
| Input Tokens | 16,320 |
| Output Tokens | 4,500 |
| Cost | $0.76 |'

  SA_DETAIL[1]='### Session 1 — 08:45 to 10:20
| Metric | Value |
|--------|-------|
| Messages | 22 |
| Input Tokens | 28,400 |
| Output Tokens | 9,600 |
| Cost | $1.48 |

### Session 2 — 11:00 to 11:45
| Metric | Value |
|--------|-------|
| Messages | 8 |
| Input Tokens | 12,300 |
| Output Tokens | 5,100 |
| Cost | $0.89 |

### Session 3 — 15:15 to 16:00
| Metric | Value |
|--------|-------|
| Messages | 14 |
| Input Tokens | 11,400 |
| Output Tokens | 4,200 |
| Cost | $0.75 |'

  SA_DETAIL[2]='### Session 1 — 10:00 to 11:30
| Metric | Value |
|--------|-------|
| Messages | 15 |
| Input Tokens | 18,500 |
| Output Tokens | 6,200 |
| Cost | $0.98 |'

  SA_DETAIL[3]='### Session 1 — 08:30 to 09:45
| Metric | Value |
|--------|-------|
| Messages | 20 |
| Input Tokens | 24,800 |
| Output Tokens | 9,100 |
| Cost | $1.52 |

### Session 2 — 10:15 to 11:40
| Metric | Value |
|--------|-------|
| Messages | 28 |
| Input Tokens | 31,200 |
| Output Tokens | 12,400 |
| Cost | $2.08 |

### Session 3 — 13:00 to 14:10
| Metric | Value |
|--------|-------|
| Messages | 16 |
| Input Tokens | 18,700 |
| Output Tokens | 7,800 |
| Cost | $1.30 |

### Session 4 — 16:00 to 16:35
| Metric | Value |
|--------|-------|
| Messages | 9 |
| Input Tokens | 14,500 |
| Output Tokens | 5,200 |
| Cost | $0.97 |'

  SA_DETAIL[4]='### Session 1 — 09:30 to 10:15
| Metric | Value |
|--------|-------|
| Messages | 10 |
| Input Tokens | 15,200 |
| Output Tokens | 4,800 |
| Cost | $0.72 |'

  SA_DETAIL[5]='### Session 1 — 08:30 to 10:00
| Metric | Value |
|--------|-------|
| Messages | 24 |
| Input Tokens | 28,300 |
| Output Tokens | 10,200 |
| Cost | $1.72 |

### Session 2 — 11:15 to 12:30
| Metric | Value |
|--------|-------|
| Messages | 18 |
| Input Tokens | 21,500 |
| Output Tokens | 7,400 |
| Cost | $1.30 |

### Session 3 — 14:00 to 14:45
| Metric | Value |
|--------|-------|
| Messages | 12 |
| Input Tokens | 15,000 |
| Output Tokens | 4,500 |
| Cost | $0.92 |'

  SA_DETAIL[6]='### Session 1 — 09:00 to 10:30
| Metric | Value |
|--------|-------|
| Messages | 20 |
| Input Tokens | 26,800 |
| Output Tokens | 10,100 |
| Cost | $1.72 |

### Session 2 — 14:30 to 15:20
| Metric | Value |
|--------|-------|
| Messages | 12 |
| Input Tokens | 15,500 |
| Output Tokens | 5,500 |
| Cost | $0.96 |'

  SA_DETAIL[7]='### Session 1 — 09:15 to 10:30
| Metric | Value |
|--------|-------|
| Messages | 16 |
| Input Tokens | 20,100 |
| Output Tokens | 6,800 |
| Cost | $1.12 |

### Session 2 — 15:00 to 16:00
| Metric | Value |
|--------|-------|
| Messages | 14 |
| Input Tokens | 15,300 |
| Output Tokens | 4,400 |
| Cost | $0.77 |'

  SA_DETAIL[8]='### Session 1 — 08:45 to 10:15
| Metric | Value |
|--------|-------|
| Messages | 26 |
| Input Tokens | 32,400 |
| Output Tokens | 12,800 |
| Cost | $2.08 |

### Session 2 — 11:00 to 12:00
| Metric | Value |
|--------|-------|
| Messages | 15 |
| Input Tokens | 21,600 |
| Output Tokens | 8,900 |
| Cost | $1.42 |

### Session 3 — 14:30 to 15:20
| Metric | Value |
|--------|-------|
| Messages | 12 |
| Input Tokens | 17,500 |
| Output Tokens | 6,700 |
| Cost | $1.12 |'

  SA_DETAIL[9]='### Session 1 — 10:00 to 11:15
| Metric | Value |
|--------|-------|
| Messages | 14 |
| Input Tokens | 21,800 |
| Output Tokens | 7,100 |
| Cost | $1.12 |'

  SA_DETAIL[10]='### Session 1 — 08:15 to 09:45
| Metric | Value |
|--------|-------|
| Messages | 28 |
| Input Tokens | 32,100 |
| Output Tokens | 12,500 |
| Cost | $2.02 |

### Session 2 — 10:15 to 11:30
| Metric | Value |
|--------|-------|
| Messages | 20 |
| Input Tokens | 25,800 |
| Output Tokens | 10,200 |
| Cost | $1.68 |

### Session 3 — 13:00 to 14:00
| Metric | Value |
|--------|-------|
| Messages | 16 |
| Input Tokens | 22,200 |
| Output Tokens | 9,100 |
| Cost | $1.52 |

### Session 4 — 15:30 to 16:20
| Metric | Value |
|--------|-------|
| Messages | 12 |
| Input Tokens | 15,500 |
| Output Tokens | 6,400 |
| Cost | $1.12 |'

  SA_DETAIL[11]='### Session 1 — 09:00 to 10:45
| Metric | Value |
|--------|-------|
| Messages | 22 |
| Input Tokens | 28,600 |
| Output Tokens | 10,800 |
| Cost | $1.78 |

### Session 2 — 14:15 to 15:00
| Metric | Value |
|--------|-------|
| Messages | 10 |
| Input Tokens | 15,500 |
| Output Tokens | 6,000 |
| Cost | $1.04 |'

  SA_DETAIL[12]='### Session 1 — 08:30 to 09:50
| Metric | Value |
|--------|-------|
| Messages | 18 |
| Input Tokens | 22,400 |
| Output Tokens | 8,200 |
| Cost | $1.38 |

### Session 2 — 10:30 to 11:45
| Metric | Value |
|--------|-------|
| Messages | 16 |
| Input Tokens | 20,300 |
| Output Tokens | 7,800 |
| Cost | $1.28 |

### Session 3 — 14:00 to 15:00
| Metric | Value |
|--------|-------|
| Messages | 14 |
| Input Tokens | 15,500 |
| Output Tokens | 5,500 |
| Cost | $1.02 |'

  SA_DETAIL[13]='### Session 1 — 09:15 to 10:30
| Metric | Value |
|--------|-------|
| Messages | 16 |
| Input Tokens | 19,200 |
| Output Tokens | 6,400 |
| Cost | $1.02 |

### Session 2 — 14:00 to 14:45
| Metric | Value |
|--------|-------|
| Messages | 10 |
| Input Tokens | 13,600 |
| Output Tokens | 4,100 |
| Cost | $0.72 |'

  SA_DETAIL[14]='### Session 1 — 09:30 to 10:30
| Metric | Value |
|--------|-------|
| Messages | 12 |
| Input Tokens | 16,400 |
| Output Tokens | 5,200 |
| Cost | $0.82 |'

  SA_DETAIL[15]='### Session 1 — 08:30 to 10:00
| Metric | Value |
|--------|-------|
| Messages | 26 |
| Input Tokens | 30,200 |
| Output Tokens | 12,400 |
| Cost | $1.92 |

### Session 2 — 11:00 to 12:15
| Metric | Value |
|--------|-------|
| Messages | 18 |
| Input Tokens | 24,600 |
| Output Tokens | 10,200 |
| Cost | $1.64 |

### Session 3 — 14:30 to 15:30
| Metric | Value |
|--------|-------|
| Messages | 14 |
| Input Tokens | 17,600 |
| Output Tokens | 7,200 |
| Cost | $1.22 |'

  SA_DETAIL[16]='### Session 1 — 09:00 to 10:20
| Metric | Value |
|--------|-------|
| Messages | 18 |
| Input Tokens | 24,200 |
| Output Tokens | 9,100 |
| Cost | $1.52 |

### Session 2 — 14:30 to 15:15
| Metric | Value |
|--------|-------|
| Messages | 10 |
| Input Tokens | 14,700 |
| Output Tokens | 5,100 |
| Cost | $0.90 |'

  SA_DETAIL[17]='### Session 1 — 08:45 to 10:00
| Metric | Value |
|--------|-------|
| Messages | 20 |
| Input Tokens | 24,800 |
| Output Tokens | 9,800 |
| Cost | $1.62 |

### Session 2 — 10:30 to 11:45
| Metric | Value |
|--------|-------|
| Messages | 16 |
| Input Tokens | 21,200 |
| Output Tokens | 8,400 |
| Cost | $1.42 |

### Session 3 — 14:00 to 15:00
| Metric | Value |
|--------|-------|
| Messages | 14 |
| Input Tokens | 16,100 |
| Output Tokens | 6,400 |
| Cost | $1.14 |'

  SA_DETAIL[18]='### Session 1 — 09:00 to 10:30
| Metric | Value |
|--------|-------|
| Messages | 22 |
| Input Tokens | 26,400 |
| Output Tokens | 10,200 |
| Cost | $1.68 |

### Session 2 — 14:15 to 15:00
| Metric | Value |
|--------|-------|
| Messages | 12 |
| Input Tokens | 14,800 |
| Output Tokens | 5,600 |
| Cost | $0.90 |'

  SA_DETAIL[19]='### Session 1 — 10:00 to 11:00
| Metric | Value |
|--------|-------|
| Messages | 14 |
| Input Tokens | 19,800 |
| Output Tokens | 6,400 |
| Cost | $1.02 |'

  # Generate analytics notes using the arrays
  for i in "${!DAYS[@]}"; do
    local d="${DAYS[$i]}"
    local date_label
    date_label=$(format_date_short "$d")
    local input_fmt output_fmt cache_r_fmt cache_w_fmt
    input_fmt=$(printf "%'d" "${SA_INPUT[$i]}")
    output_fmt=$(printf "%'d" "${SA_OUTPUT[$i]}")
    cache_r_fmt=$(printf "%'d" "${SA_CACHE_R[$i]}")
    cache_w_fmt=$(printf "%'d" "${SA_CACHE_W[$i]}")

    safe_write "$dir/$d.md" "---
date: \"$d\"
type: session-analytics
tags: [analytics, sessions]
total_sessions: ${SA_SESSIONS[$i]}
total_input_tokens: ${SA_INPUT[$i]}
total_output_tokens: ${SA_OUTPUT[$i]}
total_cache_read_tokens: ${SA_CACHE_R[$i]}
total_cache_write_tokens: ${SA_CACHE_W[$i]}
total_cost_usd: ${SA_COST[$i]}
models_used: [${SA_MODELS[$i]}]
---

# Session Analytics — ${date_label}

## Summary
| Metric | Value |
|--------|-------|
| Sessions | ${SA_SESSIONS[$i]} |
| Input Tokens | ${input_fmt} |
| Output Tokens | ${output_fmt} |
| Cache Read Tokens | ${cache_r_fmt} |
| Cache Write Tokens | ${cache_w_fmt} |
| Estimated Cost | \$${SA_COST[$i]} |

## Sessions

${SA_DETAIL[$i]}"
  done
}

# ──────────────────────────────────────────────────────────────────────────────
# Architecture Orchestrators
# ──────────────────────────────────────────────────────────────────────────────

run_professional() {
  create_people_professional
  create_projects_professional
  create_commercials
  create_meetings
  create_coding_projects
}

run_personal() {
  create_people_personal
  create_personal_projects
  create_study_notes
  create_courses
  create_health_logs
  create_finance_notes
  create_family_events
  create_hobbies
}

print_completion() {
  echo ""
  echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}${BOLD}║           Demo Data Population Complete!          ║${NC}"
  echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "${BOLD}Results:${NC}"
  echo -e "  ${GREEN}✓${NC} $CREATED notes created"
  if [ "$SKIPPED" -gt 0 ]; then
    echo -e "  ${YELLOW}~${NC} $SKIPPED files skipped (already existed)"
  fi
  echo -e "  ${CYAN}📅${NC} Date range: ${DAYS[0]} to ${DAYS[19]}"
  echo ""
  echo -e "${BOLD}Next steps:${NC}"
  echo ""
  echo -e "  1. ${CYAN}Open in Obsidian:${NC}"
  echo -e "     Open vault: ${GREEN}$VAULT_ROOT${NC}"
  echo ""
  echo -e "  2. ${CYAN}Explore the graph:${NC}"
  echo -e "     Settings → Core plugins → Graph view → Open graph"
  echo ""
  echo -e "  3. ${CYAN}Try a slash command:${NC}"
  echo -e "     ${GREEN}cd $INSTALL_DIR && claude${NC}"
  echo -e "     Then type: ${BOLD}/vault-status${NC}, ${BOLD}/context${NC}, or ${BOLD}/session-stats${NC}"
  echo ""
  echo -e "  4. ${CYAN}Open a MOC to navigate:${NC}"
  echo -e "     ${GREEN}$VAULT_ROOT/maps/${NC}"
  echo ""
}

# ──────────────────────────────────────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────────────────────────────────────

main() {
  print_header

  prompt_config "$@"

  echo -e "${BOLD}Validating target vault...${NC}"
  validate

  # Compute all dynamic dates before generating content
  compute_dates

  echo -e "${BOLD}Populating demo data (architecture: ${CYAN}$ARCHITECTURE${NC}${BOLD})...${NC}"
  echo ""

  case "$ARCHITECTURE" in
    professional)
      run_professional
      create_daily_notes "professional"
      create_today_notes "professional"
      create_session_analytics
      update_mocs_professional
      ;;
    personal)
      run_personal
      create_daily_notes "personal"
      create_today_notes "personal"
      create_session_analytics
      update_mocs_personal
      ;;
    both)
      run_professional
      run_personal
      create_daily_notes "both"
      create_today_notes "both"
      create_session_analytics
      update_mocs_professional
      update_mocs_personal
      # Overwrite Projects MOC with combined version
      force_write "$VAULT_ROOT/maps/Projects MOC.md" "---
type: moc
tags: [moc, project]
---

# Projects

Work and personal projects.

## Work — Active

- [[API Platform Migration]] — TechCorp, GraphQL + gRPC migration, due $(format_date_short "$PROJ_API_TARGET")
- [[Client Dashboard V2]] — Internal, React 18 + Kafka pipeline, due $(format_date_short "$PROJ_DASH_TARGET")

## Work — On Hold

- [[DevOps Pipeline Overhaul]] — Jenkins to GitHub Actions + ArgoCD

## Personal — Active

- [[Home Server Setup]] — Proxmox home lab, Nextcloud + Ollama
- [[Language Learning App]] — Next.js + Claude API, Italian SRS app

## Personal — On Hold

- [[Photography Portfolio]] — Static portfolio site, paused"
      ;;

    *)
      print_error "Unknown architecture: $ARCHITECTURE"
      exit 1
      ;;
  esac

  print_completion
}

main "$@"
