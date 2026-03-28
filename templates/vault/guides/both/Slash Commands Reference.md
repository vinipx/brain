---
type: guide
tags: [guide, commands, claude-code]
---

# Slash Commands Reference

All commands are run inside Claude Code from your vault's root directory. This reference covers all commands available in the combined (professional + personal) vault.

---

# Professional Core Commands

## /daily

**Creates or opens today's daily note.**

```
/daily                    --> Create today's note (or show it if it exists)
/daily Sprint Planning    --> Create today's note with a "Sprint Planning" meeting pre-filled
```

- Creates `daily/YYYY-MM-DD.md` with sections for Meetings, Tasks, Health, Notes
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

**Scaffolds a new work project tracking note.**

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

---

# Personal Core Commands

## /new-personal-project

**Scaffolds a new personal project tracking note.**

```
/new-personal-project Kitchen Renovation
/new-personal-project
```

- Asks for description, category, priority
- Creates `projects/<kebab-name>.md` with full template
- Adds a link to `maps/Projects MOC.md`
- Mentions the project in today's daily note if it exists

## /new-study

**Creates a study topic or research tracking note.**

```
/new-study Linear Algebra
/new-study
```

- Asks for subject area, goals, resources
- Creates `studies/<kebab-name>.md` with progress tracking
- Adds to `maps/Studies MOC.md`
- Links to related courses if any exist

## /new-course

**Tracks an online course, class, or certification.**

```
/new-course CS50 Introduction to Computer Science
/new-course
```

- Asks for platform, instructor, duration, schedule
- Creates `courses/<kebab-name>.md` with module tracking
- Adds to `maps/Courses MOC.md`
- Links to related study topics

## /log-health

**Records a health or wellness entry.**

```
/log-health
/log-health Ran 5k this morning
```

- Asks for category (exercise, sleep, nutrition, symptoms, mood)
- Appends to today's daily note under `## Health`
- Creates or updates `health/` tracking notes for recurring metrics
- Links to relevant goals

## /new-finance

**Creates a financial tracking entry or goal.**

```
/new-finance Monthly Budget March
/new-finance
```

- Asks for type (expense, income, budget, goal), amount, category
- Creates `finances/<kebab-name>.md` with tracking template
- Adds to `maps/Finances MOC.md`
- Links to related budget or goal notes

## /new-family-event

**Records a family event, milestone, or gathering.**

```
/new-family-event Mom's Birthday Dinner
/new-family-event
```

- Asks for date, attendees, details, photos
- Creates `family/<kebab-name>.md` with event template
- Adds to `maps/Family MOC.md`
- Creates `people/` notes for family members if they don't exist

## /new-hobby

**Tracks a hobby, creative pursuit, or side interest.**

```
/new-hobby Watercolor Painting
/new-hobby
```

- Asks for category, skill level, goals, resources
- Creates `hobbies/<kebab-name>.md` with progress tracking
- Adds to `maps/Hobbies MOC.md`
- Links to related study topics or courses

---

# Shared Core Commands

## /vault-status

**Dashboard showing current vault state.**

```
/vault-status
```

- Counts notes per folder
- Summarizes the 3 most recent daily notes
- Lists all active projects (work and personal), commercials, studies, and courses
- Shows health trends and open tasks
- Suggests maintenance actions (missing daily note, stale items)

## /weekly-review

**Generates a weekly summary.**

```
/weekly-review
```

- Reads the last 5 daily notes
- Aggregates meetings, health logs, study sessions, completed tasks, project and commercial activity, spending
- Creates `daily/YYYY-WNN-review.md`

---

# Shared Thinking Partner Commands

These commands turn your vault into an active thinking partner -- they read your notes, find patterns, and help you think better.

## /context

**Loads your full life and work state into Claude.**

```
/context
```

- Scans active projects, commercials, studies, courses, health logs, hobbies, coding refs, recent daily notes, and people
- Builds a comprehensive summary of your current state
- Use at the start of any session where you want Claude to know everything

## /today

**Generates a prioritized plan for today.**

```
/today
```

- Reads today's daily note, previous 3 days, active projects, commercials, studies, and courses
- Builds a prioritized plan: Must Do, Should Do, Could Do
- Surfaces carry-over tasks from previous days
- Balances work and personal priorities

## /closeday

**End-of-day summary -- the counterpart to /today.**

```
/closeday
```

- Reviews today's activity across daily notes, meetings, health logs, studies, and projects
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
/connect machine learning and meal planning
/connect client onboarding and study habits
```

- Searches for both topics and builds a connection graph
- Finds direct links, bridge notes, shared context, and temporal proximity
- Surfaces non-obvious patterns across work and personal domains

## /ghost

**Answers a question the way you would, based on your writing.**

```
/ghost Should we adopt Kubernetes?
/ghost Should I switch careers?
```

- Analyzes your voice, tone, values, and stated positions from your vault
- Drafts a response in your style, referencing specific notes
- Shows confidence levels: high (explicit), inferred (extrapolated), gaps

## /challenge

**Pressure-tests your beliefs -- finds contradictions and weak points.**

```
/challenge our pricing strategy
/challenge my work-life balance
```

- Catalogs your positions on the topic from across the vault
- Finds contradictions, weak assumptions, missing perspectives
- Provides a devil's advocate argument and specific recommendations

---

# Shared Discovery Commands

## /ideas

**Scans your vault for patterns and generates a full idea report.**

```
/ideas
```

- Reads daily notes (last 21 days), projects, commercials, studies, courses, hobbies, coding refs, meetings
- Generates ideas across categories: tools to build, people to reach out to, topics to investigate, things to write, skills to develop, things to create
- Every idea is grounded in specific vault content

## /graduate

**Promotes undeveloped ideas from daily notes into standalone files.**

```
/graduate
```

- Scans daily notes from the last 14 days for ideas, insights, and recurring themes
- Presents candidates with maturity assessment
- Creates standalone project, study, or hobby notes for approved ideas with context and connections
- Updates the relevant MOC

## /drift

**Surfaces recurring themes you might not be aware of.**

```
/drift
```

- Scans the last 30 days of notes for recurring themes across unrelated contexts
- Classifies drift as strong (3+ contexts), emerging (2 contexts), or fading
- Interprets what your subconscious might be circling -- across both work and personal life

## /emerge

**Finds idea clusters that could become projects, essays, products, or pursuits.**

```
/emerge
```

- Maps wiki-links and shared themes across the vault
- Identifies clusters: Ready to Launch, Forming, and Seeds
- Recommends concrete next steps for each cluster
- Surfaces clusters that bridge work and personal domains

## /schedule

**Suggests a weekly schedule aligned with your priorities.**

```
/schedule
```

- Reads active projects, commercials, studies, courses, hobbies, health goals, and recent daily notes
- Compares stated priorities vs. actual time spent across work and personal activities
- Builds a day-by-day schedule with time budgets and conflict flags
- Ensures personal time is protected alongside work commitments
