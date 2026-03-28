---
type: guide
tags: [guide, use-cases]
---

# Use Cases

Real-world scenarios for using this vault.

## Scenario 1: Starting a New Client Engagement

A commercial opportunity comes in for consulting with Acme Corp.

```
1. /new-commercial Acme Corp Automation
   --> Creates commercials/acme-corp-automation.md
   --> Creates people/jane-doe.md for the client contact
   --> Updates Commercials MOC

2. /add-meeting Acme Corp Discovery Call
   --> Records attendees, discussion, next steps
   --> Links to [[Acme Corp Automation]] commercial

3. (Later, when won) Update the commercial status to "won" and:
   /new-project Acme Corp Implementation
   --> Link it back to the commercial
```

## Scenario 2: Tracking a Multi-Week Project

You're running a project over several weeks.

```
Week 1:
  /new-project Dashboard Redesign
  /daily --> add kickoff meeting notes, link to project
  /link-coding dashboard-app --> reference the related codebase

Week 2:
  /daily --> log standup outcomes, link to [[Dashboard Redesign]]
  /add-meeting Design Review --> decisions recorded, action items assigned

Week 3:
  /weekly-review --> see all activity across the project
  /vault-status --> check open tasks

End:
  Update project status to "completed"
  Move link in Projects MOC from Active to Completed
```

## Scenario 3: Preparing for a 1:1 or Status Update

Before a meeting with your manager or client:

```
"Show me all meetings and tasks related to [[Dashboard Redesign]] in the last 2 weeks"
"What commercials are currently active and what's their last update?"
"List all open action items assigned to me"
```

Claude pulls from daily notes, meeting records, and project logs to give you a comprehensive briefing.

## Scenario 4: Onboarding to a New Codebase

You're picking up a new repo:

```
1. /link-coding new-service
   --> Claude reads the repo, creates a reference note with language, framework, key files

2. "What's the architecture of this project?"
   --> Claude follows repo-path and reads the actual source

3. Link the coding reference to the relevant project:
   "Add [[new-service]] to the Related section of [[My Project]]"
```

## Scenario 5: End-of-Quarter Review

Need to report on everything you did:

```
"Summarize all weekly reviews from January through March"
"List all projects that moved to completed this quarter"
"Show the timeline of all commercial engagements"
"Count meetings by project for Q1"
```

All the data is structured in frontmatter, so Claude can aggregate and analyze.

## Scenario 6: Handoff to a Colleague

Transitioning a project to someone else:

```
"Generate a handoff document for [[Dashboard Redesign]] including:
 - Project overview
 - All meeting decisions
 - Open tasks
 - Related commercial history
 - Linked coding repos"
```

Claude traverses the wiki-links to assemble everything.

## Scenario 7: Quick Capture During a Busy Day

Back-to-back meetings, no time to organize:

```
/add-meeting Sprint Planning
> attendees: Alice, Bob. Decided to delay release by 1 week. Action: Bob updates timeline.

/add-meeting Client Check-in
> Acme Corp. Jane happy with progress. Need to send updated SOW by Friday.

(Later)
/vault-status --> see everything captured, check if links and MOCs need updating
```

The slash commands handle the structure -- you just provide the content.
