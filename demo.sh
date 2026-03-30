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
# Helpers
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
        dates=("$d" "${dates[@]}")
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
        dates=("$d" "${dates[@]}")
      fi
      offset=$((offset + 1))
    done
  fi

  echo "${dates[@]}"
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

# ──────────────────────────────────────────────────────────────────────────────
# People Notes
# ──────────────────────────────────────────────────────────────────────────────

create_people_professional() {
  print_step "Creating people notes (professional)"
  local dir="$VAULT_ROOT/people"

  safe_write "$dir/sarah-morgan.md" '---
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
- [[2026-03-10 Client Kickoff]]'

  safe_write "$dir/james-liu.md" '---
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
- [[2026-03-05 Architecture Review]]'

  safe_write "$dir/priya-patel.md" '---
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
- Organised the Q1 quarterly review

## Related
- [[Client Dashboard V2]]
- [[2026-03-17 Sprint Planning]]
- [[2026-03-24 Quarterly Review]]'

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
- Runs half marathons, inspired the [[strength-training-march]] habit log
- Planning a trip to Italy in September — motivation for [[Italian B1]]
- Input on UI/UX for [[Language Learning App]]

## Related
- [[Italian B1]]
- [[Language Learning App]]'

  safe_write "$dir/lily-chen.md" '---
type: person
role: Sister
tags: [person, family]
---

# Lily Chen

Younger sister. Graduating from UC Berkeley in May 2026.

## Notes
- Computer Science major, interested in ML
- Graduation ceremony: May 15, 2026 — see [[Lily Graduation Ceremony]]

## Related
- [[Lily Graduation Ceremony]]'

  safe_write "$dir/mom-chen.md" '---
type: person
role: Parent
tags: [person, family]
---

# Mom Chen

## Notes
- Anniversary dinner with Dad planned for April 5th — see [[Parents Anniversary Dinner]]
- Visiting SF in June

## Related
- [[Parents Anniversary Dinner]]'
}

# ──────────────────────────────────────────────────────────────────────────────
# Professional Notes
# ──────────────────────────────────────────────────────────────────────────────

create_projects_professional() {
  print_step "Creating project notes"
  local dir="$VAULT_ROOT/projects"

  safe_write "$dir/api-platform-migration.md" '---
type: project
status: active
priority: high
client: TechCorp
start-date: 2026-01-15
target-date: 2026-06-30
tags: [project]
---

# API Platform Migration

Migrating TechCorp'"'"'s legacy REST API layer to a modern GraphQL + gRPC hybrid platform. High-impact, client-critical delivery.

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
- **Meetings**: [[2026-03-10 Client Kickoff]], [[2026-03-05 Architecture Review]]

## Progress Log

| Date | Update |
|------|--------|
| 2026-01-15 | Project kicked off, discovery phase started |
| 2026-02-03 | SOAP audit complete — 47 endpoints identified |
| 2026-02-28 | gRPC protobuf contracts drafted (v0.1) |
| 2026-03-10 | Client kickoff — TechCorp approved phase 1 scope |
| 2026-03-24 | GraphQL gateway spike complete, performance benchmarks green |

## Tasks
- [x] Complete SOAP endpoint audit
- [x] Draft gRPC protobuf contracts v0.1
- [x] Deploy GraphQL gateway to staging
- [ ] Migrate first 5 microservices to gRPC
- [ ] Load testing at 10k RPS
- [ ] Client UAT sign-off'

  safe_write "$dir/client-dashboard-v2.md" '---
type: project
status: active
priority: medium
client: Internal
start-date: 2026-02-01
target-date: 2026-05-15
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
- **Meetings**: [[2026-03-17 Sprint Planning]]

## Progress Log

| Date | Update |
|------|--------|
| 2026-02-01 | Kickoff — design specs approved |
| 2026-02-20 | React component library bootstrapped |
| 2026-03-05 | Kafka pipeline POC — 340ms avg latency |
| 2026-03-17 | Sprint 4 planning, RBAC stories in backlog |

## Tasks
- [x] React 18 component library setup
- [x] Kafka pipeline POC
- [ ] Implement RBAC layer
- [ ] Performance testing (P95 target)
- [ ] Beta rollout to 3 pilot clients'

  safe_write "$dir/devops-pipeline-overhaul.md" '---
type: project
status: on-hold
priority: low
client: Internal
start-date: 2026-01-10
target-date: 2026-07-01
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
| 2026-01-10 | Jenkins audit — 23 pipelines identified |
| 2026-02-14 | GitHub Actions migration plan drafted |
| 2026-03-01 | Put on hold — resources redirected to API Migration |

## Tasks
- [x] Jenkins pipeline audit
- [x] GitHub Actions migration plan
- [ ] Migrate first 5 pipelines
- [ ] ArgoCD cluster setup
- [ ] Team training on GitOps workflow'
}

create_commercials() {
  print_step "Creating commercial notes"
  local dir="$VAULT_ROOT/commercials"

  safe_write "$dir/techcorp-enterprise-deal.md" '---
type: commercial
status: active
client: TechCorp
contact: sarah-morgan
start-date: 2025-12-01
value: "320000"
probability: "80"
tags: [commercial]
---

# Commercial: TechCorp Enterprise Deal

12-month enterprise engagement for API platform modernisation. Largest active deal in Q1.

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
| 2025-12-01 | Discovery call | Confirmed budget and scope |
| 2026-01-10 | SOW signed | $320k, 12 months |
| 2026-01-15 | Project kickoff | See [[API Platform Migration]] |
| 2026-03-10 | Phase 1 review | On track |

## Deliverables
- [x] SOW signed
- [x] Phase 1: SOAP audit and gRPC contracts
- [ ] Phase 2: GraphQL gateway deployment
- [ ] Phase 3: Microservice migration (5 services)
- [ ] Phase 4: Documentation and handover

## Related
- **Project**: [[API Platform Migration]]
- **Meetings**: [[2026-03-10 Client Kickoff]]

## Notes
Strong renewal signal. Sarah mentioned budget approval for a follow-on data platform project in Q3.'

  safe_write "$dir/fintech-saas-integration.md" '---
type: commercial
status: won
client: FinStack Inc.
contact: james-liu
start-date: 2025-10-15
value: "95000"
probability: "100"
tags: [commercial]
---

# Commercial: FinTech SaaS Integration

Payment gateway integration for FinStack. Closed December 2025.

## Client
FinStack Inc. — payments infrastructure startup, 40 engineers. CTO [[James Liu]] was the decision-maker.

## Engagement Summary
3-month integration project to connect FinStack'"'"'s payment engine to 4 enterprise banking partners via API adapters.

## Key Contacts
- [[James Liu]] — CTO & Co-founder

## Timeline

| Date | Event | Notes |
|------|-------|-------|
| 2025-10-15 | Initial meeting | Referral via David |
| 2025-11-01 | Proposal submitted | $95k fixed-price |
| 2025-11-20 | Contract signed | |
| 2025-12-01 | Project start | |
| 2026-02-28 | Delivery and sign-off | All 4 integrations live |

## Deliverables
- [x] API adapter for Chase Bank
- [x] API adapter for Wells Fargo
- [x] API adapter for Stripe Connect
- [x] API adapter for Plaid
- [x] Integration test suite
- [x] Handover documentation

## Related
- **Meetings**: [[2026-03-05 Architecture Review]]

## Notes
Delivered on time, client very happy. James mentioned Series A closing in Q2 — potential follow-on.'

  safe_write "$dir/retail-analytics-proposal.md" '---
type: commercial
status: lost
client: RetailCo
contact: ""
start-date: 2026-01-20
value: "150000"
probability: "0"
tags: [commercial]
---

# Commercial: Retail Analytics Platform

Data analytics platform proposal for RetailCo. Lost to competitor in February.

## Client
RetailCo — regional retail chain, 200 stores. Procurement team was the main contact.

## Engagement Summary
6-month build of a customer behaviour analytics platform using Databricks + dbt + Looker.

## Key Contacts
- Procurement Team (no personal contact established)

## Timeline

| Date | Event | Notes |
|------|-------|-------|
| 2026-01-20 | RFP received | $150k budget indicated |
| 2026-02-05 | Proposal submitted | Full data platform scope |
| 2026-02-20 | Decision meeting | Lost — competitor undercut by $40k |

## Deliverables
- [x] RFP response
- [x] Technical proposal
- [ ] ~~Project delivery~~ — not awarded

## Notes
Lost on price. Competitor (DataBridge) offered a templated solution. Lesson: need a pre-packaged retail analytics offering to compete in this segment.'
}

create_meetings() {
  print_step "Creating meeting notes"
  local dir="$VAULT_ROOT/meetings"

  safe_write "$dir/2026-03-05-architecture-review.md" '---
date: 2026-03-05
time: "14:00"
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
- Alex to run latency benchmarks at 5k and 10k RPS by March 17
- Schema versioning will use `@deprecated` directives + a parallel-run period

## Action Items
- [x] Alex: Apollo Federation POC in staging
- [x] Alex: Latency benchmark report
- [ ] James: Review and approve protobuf contracts v0.2
- [ ] Sarah: Confirm microservice migration order with TechCorp eng team

## Follow-ups
- [[2026-03-10 Client Kickoff]]
- [[API Platform Migration]]'

  safe_write "$dir/2026-03-10-client-kickoff.md" '---
date: 2026-03-10
time: "10:00"
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
- Slack channel `#api-migration` created for async comms

## Action Items
- [x] Alex: Set up `#api-migration` Slack channel
- [x] Priya: Update project tracker with Phase 2 milestones
- [ ] Sarah: Introduce TechCorp infra team to David by March 17
- [ ] Alex: Deploy GraphQL gateway to staging by March 24

## Follow-ups
- [[API Platform Migration]]
- [[TechCorp Enterprise Deal]]'

  safe_write "$dir/2026-03-17-sprint-planning.md" '---
date: 2026-03-17
time: "09:30"
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
- [[Client Dashboard V2]]'

  safe_write "$dir/2026-03-20-team-1on1.md" '---
date: 2026-03-20
time: "11:00"
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
Project is on hold since March 1 due to resource reallocation to the API Migration. David has been keeping a backlog of Jenkins issues. Estimated 3 Jenkins pipelines could fail in the next 6 weeks without intervention.

## Decisions
- Quick patch: David will fix the 3 at-risk Jenkins pipelines independently
- Full overhaul to resume after API Migration Phase 2 is delivered (target: late May)
- David will use downtime to set up GitHub Actions on a non-critical repo as a proof of concept

## Action Items
- [ ] David: Patch 3 at-risk Jenkins pipelines by March 27
- [ ] David: GitHub Actions POC on `utils-lib` repo
- [ ] Alex: Add DevOps overhaul back to roadmap for June

## Follow-ups
- [[DevOps Pipeline Overhaul]]
- [[infra-as-code]]'

  safe_write "$dir/2026-03-24-quarterly-review.md" '---
date: 2026-03-24
time: "14:00"
type: meeting
attendees: [Alex Chen, Priya Patel, Sarah Morgan, David Okafor]
project: ""
tags: [meeting]
---

# Meeting: Q1 2026 Quarterly Review

## Context
- **Project**: Cross-team review
- **Attendees**: Alex Chen, [[Priya Patel]], [[Sarah Morgan]] (guest), [[David Okafor]]
- **Goal**: Review Q1 OKRs, celebrate wins, identify blockers for Q2

## Discussion
Q1 highlights:
- [[FinTech SaaS Integration]] delivered on time and budget ✓
- [[API Platform Migration]] Phase 1 complete ✓
- [[Client Dashboard V2]] on track for May delivery ✓

Blocker: [[DevOps Pipeline Overhaul]] slipped — need to replan for Q2.

Revenue: Q1 bookings 112% of target. [[TechCorp Enterprise Deal]] is the anchor.

## Decisions
- Q2 priority order: API Migration Phase 2 > Dashboard Beta > DevOps Overhaul
- Hire 1 additional mid-level backend engineer by end of April
- Monthly revenue review to be added to team calendar

## Action Items
- [ ] Alex: Post Q1 summary to team Notion by March 27
- [ ] Priya: Start hiring JD for backend engineer
- [ ] David: DevOps Q2 plan by April 7

## Follow-ups
- [[API Platform Migration]]
- [[Client Dashboard V2]]
- [[DevOps Pipeline Overhaul]]'
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

  safe_write "$dir/home-server-setup.md" '---
type: personal-project
status: active
priority: medium
start-date: 2026-02-10
target-date: 2026-04-30
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
| 2026-02-10 | Proxmox installed, first VM up |
| 2026-02-20 | Nextcloud running, 180GB synced |
| 2026-03-05 | Explored Ollama — llama3 runs well at q4_K_M |'

  safe_write "$dir/photography-portfolio.md" '---
type: personal-project
status: on-hold
priority: low
start-date: 2026-01-05
target-date: ""
tags: [project]
---

# Photography Portfolio Website

Build a minimal portfolio site to showcase street photography work.

## Overview
A static site (Astro or Hugo) hosted on Vercel. Clean, photo-first design. No social features — just a curated gallery.

## Goals
- Curate best 40 photos from 2025
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
| 2026-01-05 | Idea captured, on hold until API Migration pressure eases |'

  safe_write "$dir/language-learning-app.md" '---
type: personal-project
status: active
priority: high
start-date: 2026-03-01
target-date: 2026-08-01
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
| 2026-03-01 | Decided to build it. Stack: Next.js + Supabase |
| 2026-03-15 | SRS algorithm prototype working in tests |'
}

create_study_notes() {
  print_step "Creating study notes"
  local dir="$VAULT_ROOT/study"

  safe_write "$dir/advanced-algorithms.md" '---
type: study
subject: Advanced Algorithms
semester: Spring 2026
institution: Stanford Online
status: active
tags: [study]
---

# Advanced Algorithms

Stanford Online — CS161 equivalent. Refreshing fundamentals for interview prep and curiosity.

## Subject Info
- **Subject**: Advanced Algorithms (CS161)
- **Institution**: Stanford Online
- **Semester**: Spring 2026

## Schedule

| Day | Time |
|-----|------|
| Tuesday | 19:00 – 20:30 |
| Saturday | 10:00 – 12:00 |

## Assignments
- [x] Problem Set 1 — Divide and Conquer
- [x] Problem Set 2 — Dynamic Programming
- [ ] Problem Set 3 — Graph Algorithms (due April 10)
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
- Sedgewick & Wayne "Algorithms" (4th ed)'

  safe_write "$dir/italian-b1.md" '---
type: study
subject: Italian Language
semester: Self-directed 2026
institution: Self-directed
status: active
tags: [study]
---

# Italian B1

Working toward B1 proficiency for a September trip to Italy with [[Maya Chen]].

## Subject Info
- **Subject**: Italian (CEFR B1 target)
- **Institution**: Self-directed + iTalki tutors
- **Semester**: 2026 (ongoing)

## Schedule

| Day | Time |
|-----|------|
| Monday | 07:30 – 08:00 (Duolingo + Anki) |
| Wednesday | 19:00 – 20:00 (iTalki lesson) |
| Saturday | 10:00 – 11:00 (grammar review) |

## Assignments
- [x] Complete "Italian in 3 Months" workbook Part 1
- [x] Reach A2 on CEFR self-assessment
- [ ] Pass Mondly B1 practice test
- [ ] Hold 10-minute unscripted conversation with tutor
- [ ] Complete "Italian in 3 Months" workbook Part 2

## Grades

| Milestone | Result | Date |
|-----------|--------|------|
| A1 self-test | Pass | 2025-11-01 |
| A2 self-test | Pass | 2026-01-15 |
| B1 target | – | 2026-08-01 |

## Notes
Subjunctive mood is the hardest so far. Tutor Francesca recommends watching RAI news with Italian subtitles.

## Resources
- [[italian-conversation-practice]] hobby note
- [[Language Learning App]] — side project inspired by this'
}

create_courses() {
  print_step "Creating course notes"
  local dir="$VAULT_ROOT/courses"

  safe_write "$dir/system-design-masterclass.md" '---
type: course
platform: Udemy
instructor: Clement Mihailescu
url: ""
start-date: 2026-02-15
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
Will attempt certificate after completing all modules.'

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

  safe_write "$dir/strength-training-march.md" '---
type: health-log
category: workout
date: 2026-03-03
tags: [health]
---

# Strength Training — March Habit Log

## Details
- **Category**: workout
- **Date**: 2026-03-03

## Measurements

| Metric | Value |
|--------|-------|
| Squat (3x5) | 115 kg |
| Deadlift (1x5) | 140 kg |
| Bench Press (3x5) | 82.5 kg |
| Overhead Press (3x5) | 57.5 kg |

## Notes
Returning to StrongLifts 5x5 after a 3-week break. Weight slightly down from pre-break PRs. Goal: hit 120kg squat by end of March.

## Follow-up
- [ ] Increase squat by 2.5kg next session
- [ ] Check form on deadlift — lower back rounding slightly'

  safe_write "$dir/run-20260310.md" '---
type: health-log
category: workout
date: 2026-03-10
tags: [health]
---

# Morning Run — 2026-03-10

## Details
- **Category**: workout
- **Date**: 2026-03-10

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
- [ ] Plan long run for Sunday (12km target)'

  safe_write "$dir/annual-checkup-2026.md" '---
type: health-log
category: appointment
date: 2026-03-12
tags: [health]
---

# Annual Physical — 2026-03-12

## Details
- **Category**: appointment
- **Date**: 2026-03-12

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
- [ ] Book dentist appointment (overdue 6 months)'

  safe_write "$dir/sleep-habit-march.md" '---
type: health-log
category: habit
date: 2026-03-01
tags: [health]
---

# Sleep Tracking — March 2026

## Details
- **Category**: habit
- **Date**: 2026-03-01

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
- [ ] Set phone "wind down" mode to 21:45 daily
- [ ] Experiment with magnesium glycinate before bed'

  safe_write "$dir/strength-training-march-wk3.md" '---
type: health-log
category: workout
date: 2026-03-17
tags: [health]
---

# Strength Training — Week 3 March

## Details
- **Category**: workout
- **Date**: 2026-03-17

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
- [ ] Look into Texas Method for next training block'

  safe_write "$dir/meditation-habit.md" '---
type: health-log
category: habit
date: 2026-03-01
tags: [health]
---

# Meditation — March Habit Tracking

## Details
- **Category**: habit
- **Date**: 2026-03-01

## Measurements

| Metric | Value |
|--------|-------|
| Sessions completed (wk 1) | 5/7 |
| Sessions completed (wk 2) | 4/7 |
| Sessions completed (wk 3) | 6/7 |
| Average session length | 12 min |

## Notes
Using Waking Up app — Sam Harris'"'"' 30-day course. Noticing less reactive during stressful work conversations. Will track alongside [[sleep-habit-march]] to see correlation.

## Follow-up
- [ ] Complete 30-day Waking Up course
- [ ] Try a longer 20-minute session'
}

create_finance_notes() {
  print_step "Creating finance notes"
  local dir="$VAULT_ROOT/finances"

  safe_write "$dir/march-2026-rent.md" '---
type: finance
category: housing
amount: "3200"
date: 2026-03-01
recurring: true
tags: [finance]
---

# March 2026 — Rent

## Details
- **Category**: housing
- **Amount**: $3,200
- **Date**: 2026-03-01
- **Recurring**: true (monthly, 1st)

## Notes
Mission District apartment. Split equally with [[Maya Chen]] ($1,600 each). Lease renewed Jan 2026 at same rate — good outcome given SF market.

## Related
- [[Finance MOC]]'

  safe_write "$dir/gym-membership.md" '---
type: finance
category: health
amount: "85"
date: 2026-03-05
recurring: true
tags: [finance]
---

# Gym Membership — Monthly

## Details
- **Category**: health
- **Amount**: $85
- **Date**: 2026-03-05
- **Recurring**: true (monthly)

## Notes
Equinox Fillmore. Pricy but the squat racks are always free before 7am. Directly tied to [[strength-training-march]] habit.

## Related
- [[Health MOC]]'

  safe_write "$dir/qcon-sf-2026.md" '---
type: finance
category: professional development
amount: "1299"
date: 2026-03-20
recurring: false
tags: [finance]
---

# QCon SF 2026 — Conference Ticket

## Details
- **Category**: professional development
- **Amount**: $1,299
- **Date**: 2026-03-20
- **Recurring**: false

## Notes
QCon San Francisco, April 14-16. Sessions on distributed systems, platform engineering, and AI/LLM integration in production. Directly relevant to [[API Platform Migration]] and [[Language Learning App]].

Expensing $800 through Axiom Digital; paying $499 out of pocket.

## Related
- [[API Platform Migration]]
- [[System Design Masterclass]]'

  safe_write "$dir/freelance-income-feb.md" '---
type: finance
category: income
amount: "3500"
date: 2026-02-28
recurring: false
tags: [finance]
---

# Freelance Income — February 2026

## Details
- **Category**: income
- **Amount**: $3,500
- **Date**: 2026-02-28
- **Recurring**: false

## Notes
Consulting hours for [[FinTech SaaS Integration]] — final milestone payment. Invoiced through personal LLC. Allocated: $1,500 to emergency fund, $2,000 to brokerage (VTSAX).

## Related
- [[FinTech SaaS Integration]]
- [[Finance MOC]]'
}

create_family_events() {
  print_step "Creating family event notes"
  local dir="$VAULT_ROOT/family"

  safe_write "$dir/lilys-graduation.md" '---
type: family-event
date: 2026-05-15
participants: [Alex Chen, Maya Chen, Mom Chen, Dad Chen]
tags: [family]
---

# Lily Graduation Ceremony

## Event
- **Date**: 2026-05-15
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
- [ ] Book hotel in Berkeley for May 14-15
- [ ] Make dinner reservation (Chez Panisse or Rivoli)
- [ ] Buy graduation gift — consider a MacBook Pro'

  safe_write "$dir/parents-anniversary-dinner.md" '---
type: family-event
date: 2026-04-05
participants: [Alex Chen, Maya Chen, Mom Chen, Dad Chen]
tags: [family]
---

# Parents Anniversary Dinner

## Event
- **Date**: 2026-04-05
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
- [ ] Arrange Lyft (no parking near restaurant)'
}

create_hobbies() {
  print_step "Creating hobby notes"
  local dir="$VAULT_ROOT/hobby"

  safe_write "$dir/street-photography.md" '---
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
| 2026-01-10 | New Fuji X100VI arrived — first outing in Mission |
| 2026-02-05 | Shot the Lunar New Year parade in Chinatown — 800 frames, 12 selects |
| 2026-03-08 | Saturday dawn shoot at the Ferry Building — best light of the year so far |

## Resources
- [[Photography Lighting Masterclass]]
- [[photography-portfolio]]

## Related
- [[photography-portfolio]]'

  safe_write "$dir/italian-conversation-practice.md" '---
type: hobby
hobby-name: Italian Conversation
status: active
tags: [hobby]
---

# Italian Conversation Practice

Weekly iTalki lessons and independent practice to reach B1 conversational fluency.

## Description
Working with a native Italian tutor (Francesca, from Rome) for weekly 55-minute conversation lessons. Supplemented with Anki vocabulary, RAI news listening, and the [[Language Learning App]] I'"'"'m building.

## Goals
- Hold a 10-minute unscripted conversation by June 2026
- Order food, give directions, and discuss current events in Italian
- Reach B1 on CEFR self-assessment before the Italy trip (see [[Italian B1]])

## Progress Log

| Date | Update |
|------|--------|
| 2026-01-08 | Started iTalki lessons with Francesca |
| 2026-02-12 | First full conversation about daily routine — slow but complete |
| 2026-03-19 | Discussed the news for 5 minutes with minimal prompting — progress! |

## Resources
- [[Italian B1]]
- [[Language Learning App]]

## Related
- [[Maya Chen]] — planning Italy trip together'
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

  # 20 business days fixed to 2026-03-02..2026-03-27 so data is always consistent
  local dates
  dates="2026-03-02 2026-03-03 2026-03-04 2026-03-05 2026-03-06
2026-03-09 2026-03-10 2026-03-11 2026-03-12 2026-03-13
2026-03-16 2026-03-17 2026-03-18 2026-03-19 2026-03-20
2026-03-23 2026-03-24 2026-03-25 2026-03-26 2026-03-27"

  # Per-day content written via case statement below

  for d in $dates; do
    local tasks notes health gratitude links meeting
    meeting=''

    case "$d" in
      2026-03-02)
        tasks='- [x] Review gRPC contracts v0.1
- [ ] Update [[API Platform Migration]] progress log
- [ ] Reply to Sarah on phase 2 timeline'
        notes='GraphQL gateway POC is promising. Apollo Federation docs are excellent.'
        health='Morning walk 20 min. StrongLifts — squat 115 kg.'
        gratitude='Grateful for a technically interesting project with clear scope.'
        links='[[API Platform Migration]], [[payments-api]]'
        ;;
      2026-03-03)
        tasks='- [x] Write unit tests for payments-api authorise handler
- [x] Italian vocab review with Anki
- [ ] Book hotel for [[Lily Graduation Ceremony]]'
        notes='Algorithms problem set 2 harder than expected — spent 2h on DP table design.'
        health='Rest day. 8k steps.'
        gratitude='Grateful for the algorithms course — makes evening learning feel like play.'
        links='[[Advanced Algorithms]], [[Lily Graduation Ceremony]]'
        ;;
      2026-03-04)
        tasks='- [x] Deploy GraphQL gateway POC to staging
- [ ] Load test at 1k RPS
- [ ] Street photography walk after work'
        notes='Staging benchmark results better than expected. Will share with Sarah tomorrow.'
        health='Strength training — bench press 82.5 kg.'
        gratitude='Grateful the gateway POC worked first try.'
        links='[[API Platform Migration]], [[Client Dashboard V2]]'
        ;;
      2026-03-05)
        meeting='- 14:00 [[2026-03-05-architecture-review]] with [[James Liu]] and [[Sarah Morgan]]'
        tasks='- [x] Prepare architecture comparison doc for review
- [x] Apollo Federation spike complete
- [ ] Send meeting notes to James and Sarah'
        notes='Architecture review went well. Apollo Federation decision made. Notes sent.'
        health='Walk after work — 6k steps.'
        gratitude='Grateful for a clear architecture decision — momentum restored.'
        links='[[2026-03-05-architecture-review]], [[TechCorp Enterprise Deal]]'
        ;;
      2026-03-06)
        tasks='- [x] Friday retro notes
- [ ] [[photography-portfolio]] — cull last weekend shoot
- [ ] Grocery run with [[Maya Chen]]'
        notes='Good end to the week. Q1 is shaping up. Taking Saturday morning to shoot.'
        health='8.2 km run along Embarcadero — 42:30.'
        gratitude='Grateful for Friday photography time — brain recharge.'
        links='[[street-photography]], [[photography-portfolio]]'
        ;;
      2026-03-09)
        tasks='- [x] Weekly planning session
- [ ] Read 2 chapters of Sedgewick algorithms
- [ ] [[Advanced Algorithms]] problem set 2'
        notes='Slow start after the weekend. Algorithms book is genuinely enjoyable.'
        health='Rest day — legs sore from Friday run.'
        gratitude='Grateful for a quiet Monday morning to plan the week.'
        links='[[Advanced Algorithms]]'
        ;;
      2026-03-10)
        meeting='- 10:00 [[2026-03-10-client-kickoff]] with [[Sarah Morgan]] and [[Priya Patel]]'
        tasks='- [x] Phase 1 sign-off docs prepared
- [x] Set up #api-migration Slack channel
- [ ] Update [[TechCorp Enterprise Deal]] timeline'
        notes='Phase 1 officially signed off. Big milestone for the TechCorp deal.'
        health='Strength training — squat 117.5 kg.'
        gratitude='Grateful for the partnership with Sarah — phase 1 sign-off felt earned.'
        links='[[2026-03-10-client-kickoff]], [[API Platform Migration]]'
        ;;
      2026-03-11)
        tasks='- [x] GraphQL gateway latency benchmark — 340ms P50
- [ ] React RBAC component research
- [ ] Waking Up meditation — 12 min'
        notes='Kafka latency numbers are excellent. Dashboard V2 is looking strong.'
        health='Morning walk 20 min. Felt low energy.'
        gratitude='Grateful for the Kafka results — technical risk resolved.'
        links='[[Client Dashboard V2]]'
        ;;
      2026-03-12)
        meeting='- 09:30 Annual physical — Dr. Yamamoto'
        tasks='- [x] Annual checkup — all good, start Vitamin D
- [ ] Order Vitamin D supplements
- [ ] [[italian-conversation-practice]] prep for Wednesday lesson'
        notes='Annual checkup clear — doctor happy with fitness markers. Vitamin D low — starting supplement.'
        health='Annual physical — all markers good.'
        gratitude='Grateful for good health markers. Annual checkup always a relief.'
        links='[[annual-checkup-2026]], [[Italian B1]]'
        ;;
      2026-03-13)
        tasks='- [x] Kafka pipeline POC refactor
- [x] PR review for David infra change
- [ ] Friday photography walk — Chinatown'
        notes='Productive Friday. David infra PR was clean — approved quickly.'
        health='Street photography walk — 12k steps.'
        gratitude='Grateful for the Chinatown light this evening — golden hour exceptional.'
        links='[[payments-api]], [[street-photography]]'
        ;;
      2026-03-16)
        tasks='- [x] Weekly review — Q1 milestone check
- [ ] [[Advanced Algorithms]] problem set 3
- [ ] Plan parents anniversary dinner logistics'
        notes='Q1 final month. API migration and dashboard both on track.'
        health='Strength training — squat 120 kg target hit!'
        gratitude='Grateful for a team delivering without drama.'
        links='[[Advanced Algorithms]], [[Parents Anniversary Dinner]]'
        ;;
      2026-03-17)
        meeting='- 09:30 [[2026-03-17-sprint-planning]] with [[Priya Patel]] and [[David Okafor]]'
        tasks='- [x] Sprint 4 stories groomed and pointed
- [ ] RBAC middleware implementation start
- [ ] [[System Design Masterclass]] module 5 — caching'
        notes='Sprint 4 is well-planned. RBAC is the critical path item this sprint.'
        health='Rest day.'
        gratitude='Grateful for Priya calm energy in sprint planning.'
        links='[[2026-03-17-sprint-planning]], [[Client Dashboard V2]]'
        ;;
      2026-03-18)
        tasks='- [x] RBAC middleware — auth layer complete
- [ ] Write integration tests for RBAC
- [ ] iTalki lesson prep'
        notes='RBAC auth layer done in one session — clean design pays off.'
        health='5 km easy run — 27 min.'
        gratitude='Grateful for clean code that is easy to extend.'
        links='[[Client Dashboard V2]], [[italian-conversation-practice]]'
        ;;
      2026-03-19)
        tasks='- [x] PR review x3
- [x] Italian lesson with Francesca — discussed news topics
- [ ] Morning run — Embarcadero route'
        notes='Italian lesson was the best yet — held 5 minutes of unscripted conversation.'
        health='Strength training — OHP 60 kg.'
        gratitude='Grateful for Francesca — the Italian lessons are genuinely fun.'
        links='[[Italian B1]], [[italian-conversation-practice]]'
        ;;
      2026-03-20)
        meeting='- 11:00 [[2026-03-20-team-1on1]] with [[David Okafor]]'
        tasks='- [x] 1:1 with David — DevOps pipeline status reviewed
- [x] Patch plan confirmed
- [ ] [[photography-portfolio]] shortlist review'
        notes='DevOps situation under control. David has a solid patch plan.'
        health='Walk — 9k steps.'
        gratitude='Grateful David caught the Jenkins risk before it became a fire.'
        links='[[2026-03-20-team-1on1]], [[DevOps Pipeline Overhaul]]'
        ;;
      2026-03-23)
        tasks='- [x] Monday planning — Q1 final push
- [ ] Write Q1 team summary for Notion
- [ ] [[Advanced Algorithms]] — graph algorithms reading'
        notes='Final week of Q1. Feeling good about where things stand.'
        health='Strength training — deadlift 145 kg.'
        gratitude='Grateful the quarter is ending on a high note.'
        links='[[Advanced Algorithms]], [[API Platform Migration]]'
        ;;
      2026-03-24)
        meeting='- 14:00 [[2026-03-24-quarterly-review]]'
        tasks='- [x] Q1 quarterly review prep
- [x] Quarterly review meeting
- [ ] Post Q1 summary to team Notion by Friday'
        notes='Q1 quarterly review was energising. Team delivered well.'
        health='Rest day after heavy Q1 week.'
        gratitude='Grateful for an honest Q1 review — the team was candid.'
        links='[[2026-03-24-quarterly-review]], [[API Platform Migration]]'
        ;;
      2026-03-25)
        tasks='- [x] RBAC integration tests complete
- [ ] Performance test run — P95 target
- [ ] Book restaurant for [[Lily Graduation Ceremony]] dinner'
        notes='Almost at the finish line for Sprint 4 RBAC work.'
        health='5 km run — 26:30.'
        gratitude='Grateful that the hard RBAC work is almost done.'
        links='[[Client Dashboard V2]], [[Lily Graduation Ceremony]]'
        ;;
      2026-03-26)
        tasks='- [x] PR merged — Dashboard beta prep branch
- [x] Finalize Q1 Notion summary
- [ ] Send Q1 summary to team'
        notes='Q1 summary drafted. Highlights: FinTech delivery, TechCorp phase 1, Dashboard on track.'
        health='Strength training — squat 120 kg second time at this weight.'
        gratitude='Grateful for a clear week to wrap Q1 properly.'
        links='[[API Platform Migration]], [[payments-api]]'
        ;;
      2026-03-27)
        tasks='- [x] Q1 wrap — sent summary to team
- [x] [[payments-api]] v1.4 tagged and released
- [ ] Weekend plan: long run and photography'
        notes='Closed Q1 strong. Looking forward to QCon in April.'
        health='Long run planned for weekend — saved energy today.'
        gratitude='Grateful for [[Maya Chen]] — Q1 was intense, and she was steady throughout.'
        links='[[Language Learning App]], [[photography-portfolio]]'
        ;;
    esac

    # Build and write the note
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
# MOC Updates
# ──────────────────────────────────────────────────────────────────────────────

update_mocs_professional() {
  print_step "Updating professional MOCs"
  local maps="$VAULT_ROOT/maps"

  force_write "$maps/Projects MOC.md" '---
type: moc
tags: [moc, project]
---

# Projects

Active work projects and assignments.

## Active

- [[API Platform Migration]] — TechCorp, GraphQL + gRPC migration, due Jun 2026
- [[Client Dashboard V2]] — Internal, React 18 + Kafka pipeline, due May 2026

## On Hold

- [[DevOps Pipeline Overhaul]] — Jenkins → GitHub Actions + ArgoCD

## Completed

*(none this quarter)*

## By Client

**TechCorp**
- [[API Platform Migration]]

**Internal**
- [[Client Dashboard V2]]
- [[DevOps Pipeline Overhaul]]'

  force_write "$maps/Commercials MOC.md" '---
type: moc
tags: [moc, commercial]
---

# Commercials

Commercial engagements and opportunity tracking.

## Active

- [[TechCorp Enterprise Deal]] — $320k, 80% probability, API migration anchor deal

## Won

- [[FinTech SaaS Integration]] — $95k, delivered Feb 2026

## Lost

- [[Retail Analytics Proposal]] — $150k, lost on price to DataBridge Feb 2026

## On Hold

*(none)*'

  force_write "$maps/Coding MOC.md" '---
type: moc
tags: [moc, coding]
---

# Coding Projects

Reference notes for coding repositories.
Each note is a lightweight pointer — Claude reads the actual repo only when you ask about it.

## Projects

- [[payments-api]] — Go / gRPC+Protobuf — payment processing service
- [[brain-vault]] — Bash — this vault scaffold tool
- [[infra-as-code]] — HCL+YAML / Terraform+ArgoCD — cloud infrastructure'
}

update_mocs_personal() {
  print_step "Updating personal MOCs"
  local maps="$VAULT_ROOT/maps"

  force_write "$maps/Projects MOC.md" '---
type: moc
tags: [moc, project]
---

# Projects

Personal projects and side ventures.

## Active

- [[Home Server Setup]] — Proxmox home lab, self-hosted Nextcloud + Ollama
- [[Language Learning App]] — Next.js + Claude API spaced-repetition app for Italian

## On Hold

- [[Photography Portfolio]] — Static portfolio site, waiting for time after work projects

## Completed

*(none yet this year)*

## Ideas

- Recipe manager app (Claude-powered ingredient substitutions)
- Personal finance dashboard (Plaid API + local LLM)'

  force_write "$maps/Study MOC.md" '---
type: moc
tags: [moc, study]
---

# Study

Current academic and self-study tracks.

## Current Semester

- [[Advanced Algorithms]] — Stanford Online CS161, Spring 2026
- [[Italian B1]] — Self-directed, targeting B1 CEFR by August 2026

## Completed

*(nothing completed yet this year)*

## By Subject

**Computer Science**
- [[Advanced Algorithms]]

**Languages**
- [[Italian B1]]'

  force_write "$maps/Courses MOC.md" '---
type: moc
tags: [moc, course]
---

# Courses

Online courses, workshops, and self-study.

## In Progress

- [[System Design Masterclass]] — Udemy, Clement Mihailescu, 4/7 modules

## Completed

- [[Photography Lighting Masterclass]] — Domestika, Miguel Quiles, Dec 2025

## Wishlist

- Deep Learning Specialisation (Coursera / Andrew Ng)
- Advanced Swift (Point-Free)'

  force_write "$maps/Health MOC.md" '---
type: moc
tags: [moc, health]
---

# Health

Health tracking — workouts, appointments, and habits.

## Fitness

- [[Strength Training March]] — StrongLifts 5x5 log, hit 120kg squat
- [[Run 20260310]] — 8.2km Embarcadero run
- [[Strength Training March Wk3]] — week 3 log, deadlift 145kg

## Medical

- [[Annual Checkup 2026]] — all clear, Vitamin D supplement started

## Habits

- [[Sleep Habit March]] — avg 7h 10m, improving
- [[Meditation Habit]] — Waking Up app, 30-day course in progress

## By Month

**March 2026**
- [[Strength Training March]]
- [[Run 20260310]]
- [[Annual Checkup 2026]]
- [[Sleep Habit March]]
- [[Meditation Habit]]
- [[Strength Training March Wk3]]'

  force_write "$maps/Finance MOC.md" '---
type: moc
tags: [moc, finance]
---

# Finance

Financial tracking and planning.

## Budget

Monthly fixed expenses:
- [[March 2026 Rent]] — $3,200/mo (split with Maya)
- [[Gym Membership]] — $85/mo

## Investments

- $2,000 allocated to VTSAX from [[Freelance Income Feb]] payment

## Expenses

- [[QCon SF 2026]] — $1,299 conference ticket (partial expense)

## Goals

- Build 6-month emergency fund by end of 2026
- Max Roth IRA 2026 contribution ($7,000)
- Italy trip fund: $4,000 by August'

  force_write "$maps/Family MOC.md" '---
type: moc
tags: [moc, family]
---

# Family

Family events, milestones, and notes.

## Upcoming Events

- [[Lily Graduation Ceremony]] — UC Berkeley, May 15, 2026
- [[Parents Anniversary Dinner]] — Atelier Crenn, April 5, 2026

## Past

*(see daily notes for family moments)*

## People

- [[Maya Chen]] — partner
- [[Lily Chen]] — sister
- [[Mom Chen]] — parent'

  force_write "$maps/Hobbies MOC.md" '---
type: moc
tags: [moc, hobby]
---

# Hobbies

Active hobbies and creative pursuits.

## Active

- [[Street Photography]] — Fuji X100VI, Mission/Chinatown/Embarcadero, weekly shoots
- [[Italian Conversation Practice]] — iTalki with Francesca, weekly lessons

## Paused

*(none currently)*'
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
  echo -e "     Then type: ${BOLD}/vault-status${NC} or ${BOLD}/context${NC}"
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

  echo -e "${BOLD}Populating demo data (architecture: ${CYAN}$ARCHITECTURE${NC}${BOLD})...${NC}"
  echo ""

  case "$ARCHITECTURE" in
    professional)
      run_professional
      create_daily_notes "professional"
      update_mocs_professional
      ;;
    personal)
      run_personal
      create_daily_notes "personal"
      update_mocs_personal
      ;;
    both)
      run_professional
      run_personal
      create_daily_notes "both"
      update_mocs_professional
      update_mocs_personal
      # Overwrite Projects MOC with combined version
      force_write "$VAULT_ROOT/maps/Projects MOC.md" '---
type: moc
tags: [moc, project]
---

# Projects

Work and personal projects.

## Work — Active

- [[API Platform Migration]] — TechCorp, GraphQL + gRPC migration, due Jun 2026
- [[Client Dashboard V2]] — Internal, React 18 + Kafka pipeline, due May 2026

## Work — On Hold

- [[DevOps Pipeline Overhaul]] — Jenkins to GitHub Actions + ArgoCD

## Personal — Active

- [[Home Server Setup]] — Proxmox home lab, Nextcloud + Ollama
- [[Language Learning App]] — Next.js + Claude API, Italian SRS app

## Personal — On Hold

- [[Photography Portfolio]] — Static portfolio site, paused'
      ;;

    *)
      print_error "Unknown architecture: $ARCHITECTURE"
      exit 1
      ;;
  esac

  print_completion
}

main "$@"
