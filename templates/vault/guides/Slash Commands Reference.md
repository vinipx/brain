---
type: guide
tags: [guide, commands, claude-code]
---

# Slash Commands Reference

All commands are run inside Claude Code from your vault's root directory.

## /daily

**Creates or opens today's daily note.**

```
/daily                    --> Create today's note (or show it if it exists)
/daily Sprint Planning    --> Create today's note with a "Sprint Planning" meeting pre-filled
```

- Creates `daily/YYYY-MM-DD.md` with sections for Meetings, Tasks, Notes
- If the note already exists, reads it and asks what to add

## /add-meeting

**Records a meeting outcome.**

```
/add-meeting Design Review
/add-meeting
```

- Asks for attendees, discussion points, decisions, action items
- Appends to today's daily note under `## Meetings`
- For substantial meetings (many decisions/actions), also creates a standalone note in `meetings/`
- Automatically creates `people/` notes for new attendees
- Cross-links to related projects and commercials

## /new-project

**Scaffolds a new project tracking note.**

```
/new-project Dashboard Redesign
/new-project
```

- Asks for client, description, priority
- Creates `projects/<kebab-name>.md` with full template
- Adds a link to `maps/Projects MOC.md`
- Mentions the project in today's daily note if it exists

## /new-commercial

**Creates a commercial engagement note.**

```
/new-commercial Acme Corp Test Automation
/new-commercial
```

- Asks for client, contact, description
- Creates `commercials/<kebab-name>.md` with timeline table
- Adds to `maps/Commercials MOC.md`
- Creates `people/` notes for contacts

## /link-coding

**Creates a vault reference note from a coding repository.**

```
/link-coding my-project
/link-coding /path/to/repo
```

- Searches your configured coding directory for the repo
- Reads README and config files to detect language, framework, description
- Creates `coding/<repo-name>.md` with extracted metadata
- Updates `maps/Coding MOC.md`

## /vault-status

**Dashboard showing current vault state.**

```
/vault-status
```

- Counts notes per folder
- Summarizes the 3 most recent daily notes
- Lists all active projects and commercials
- Shows open tasks across notes
- Suggests maintenance actions (missing daily note, stale projects)

## /weekly-review

**Generates a weekly summary.**

```
/weekly-review
```

- Reads the last 5 daily notes
- Aggregates meetings, completed tasks, open tasks, project/commercial activity
- Creates `daily/YYYY-WNN-review.md`

---

# Thinking Partner Commands

These commands turn your vault into an active thinking partner — they read your notes, find patterns, and help you think better.

## /context

**Loads your full life and work state into Claude.**

```
/context
```

- Scans active projects, commercials, coding refs, recent daily notes, and people
- Builds a comprehensive summary of your current state
- Use at the start of any session where you want Claude to know everything

## /today

**Generates a prioritized plan for today.**

```
/today
```

- Reads today's daily note, previous 3 days, active projects, and commercials
- Builds a prioritized plan: Must Do, Should Do, Could Do
- Surfaces carry-over tasks from previous days
- Suggests creating a daily note if one doesn't exist

## /closeday

**End-of-day summary — the counterpart to /today.**

```
/closeday
```

- Reviews today's activity across daily notes, meetings, and projects
- Appends an "End of Day" section with progress, carry-overs, and reflections
- Marks completed tasks and surfaces what should carry over to tomorrow

## /trace

**Tracks how an idea evolved over time across your vault.**

```
/trace microservices migration
/trace work-life balance
```

- Searches the entire vault for mentions of the topic
- Sorts chronologically to show the idea's arc
- Analyzes: when it first appeared, how it evolved, what it's connected to now

## /connect

**Finds unexpected connections between two topics.**

```
/connect machine learning and client onboarding
/connect React and commercial strategy
```

- Searches for both topics and builds a connection graph
- Finds direct links, bridge notes, shared context, and temporal proximity
- Surfaces non-obvious patterns

## /ghost

**Answers a question the way you would, based on your writing.**

```
/ghost Should we adopt Kubernetes?
/ghost What's my management philosophy?
```

- Analyzes your voice, tone, values, and stated positions from your vault
- Drafts a response in your style, referencing specific notes
- Shows confidence levels: high (explicit), inferred (extrapolated), gaps

## /challenge

**Pressure-tests your beliefs — finds contradictions and weak points.**

```
/challenge our pricing strategy
/challenge my career direction
```

- Catalogs your positions on the topic from across the vault
- Finds contradictions, weak assumptions, missing perspectives
- Provides a devil's advocate argument and specific recommendations

## /ideas

**Scans your vault for patterns and generates a full idea report.**

```
/ideas
```

- Reads daily notes (last 21 days), projects, commercials, coding refs, meetings
- Generates ideas across four categories: tools to build, people to reach out to, topics to investigate, things to write
- Every idea is grounded in specific vault content

## /graduate

**Promotes undeveloped ideas from daily notes into standalone files.**

```
/graduate
```

- Scans daily notes from the last 14 days for ideas, insights, and recurring themes
- Presents candidates with maturity assessment
- Creates standalone project notes for approved ideas with context and connections
- Updates the Projects MOC

## /drift

**Surfaces recurring themes you might not be aware of.**

```
/drift
```

- Scans the last 30 days of notes for recurring themes across unrelated contexts
- Classifies drift as strong (3+ contexts), emerging (2 contexts), or fading
- Interprets what your subconscious might be circling

## /emerge

**Finds idea clusters that could become projects, essays, or products.**

```
/emerge
```

- Maps wiki-links and shared themes across the vault
- Identifies clusters: Ready to Launch, Forming, and Seeds
- Recommends concrete next steps for each cluster

## /schedule

**Suggests a weekly schedule aligned with your priorities.**

```
/schedule
```

- Reads active projects, commercials, recent daily notes, and weekly reviews
- Compares stated priorities vs. actual time spent
- Builds a day-by-day schedule with time budgets and conflict flags
