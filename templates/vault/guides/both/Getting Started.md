---
type: guide
tags: [guide, getting-started]
---

# Getting Started

How to use this Obsidian vault with Claude Code for managing both your professional and personal life in one place.

## Your First Day

1. Open a terminal in your vault's root directory (where `CLAUDE.md` lives)
2. Run `claude` to start Claude Code
3. Type `/daily` — Claude creates today's daily note with sections for both work and life
4. Open Obsidian and navigate to `daily/` to see your note

## Core Workflow

```
Morning:  /daily            --> Create today's note (work + personal sections)
          /today            --> Get a prioritized plan covering all areas
Meeting:  /add-meeting      --> Record work meeting outcomes
Health:   /log-health       --> Track wellness, exercise, symptoms
Project:  /new-project      --> Track a work project
          /new-personal-project --> Track a personal project
Study:    /new-study        --> Start a study topic
Course:   /new-course       --> Track a course or certification
Finance:  /new-finance      --> Log expenses or financial goals
Commercial:  /new-commercial   --> Log a client engagement
Family:   /new-family-event --> Record family milestones
Hobby:    /new-hobby        --> Track a hobby or creative pursuit
Code:     /link-coding      --> Reference a coding repository
Friday:   /weekly-review    --> Summarize your entire week
Anytime:  /vault-status     --> See what's active everywhere
```

## How Notes Connect

Everything links together through `[[wiki-links]]`. The combined vault lets you see how work and life interact:

```
Daily Note --> Morning standup --> references [[Dashboard Redesign]] project
     |
     +--> Lunch workout --> links to [[Running]] hobby, [[Health Log]]
     |
     +--> Afternoon meeting --> references [[Acme Corp]] commercial
     |
     +--> Evening --> [[Calculus II]] study session
     |
     +--> [[Mom's Birthday]] planning
```

The **Maps of Content** (MOC) in `maps/` are your navigation hubs. Start there when browsing.

## A Typical Day

### Morning

```
/daily
  --> Creates sections for Work and Personal
/today
  --> Prioritized plan: work deadlines, study sessions, health goals, family tasks
```

### Work Hours

```
/add-meeting Sprint Planning
  --> Records meeting, links to project
/new-project API Migration
  --> Scaffolds project tracking
/link-coding api-service
  --> References the codebase
```

### Lunch / Breaks

```
/log-health Ran 3 miles at lunch
  --> Tracks fitness, links to goals
```

### After Work

```
/new-study Chapter 7 Algorithms
  --> Study session notes
/log-health Mood: 8/10, productive day
  --> End-of-day wellness check
```

### Evening

```
/closeday
  --> Summarizes both work and personal accomplishments
  --> Surfaces carry-overs for tomorrow
```

## Where Things Live

| What you're looking for | Where to find it |
|------------------------|-----------------|
| Today's notes | `daily/YYYY-MM-DD.md` |
| A work project | `projects/` or `maps/Projects MOC` |
| A personal project | `projects/` or `maps/Projects MOC` |
| A commercial | `commercials/` or `maps/Commercials MOC` |
| A coding repo reference | `coding/` or `maps/Coding MOC` |
| A study topic | `studies/` or `maps/Studies MOC` |
| A course | `courses/` or `maps/Courses MOC` |
| Health logs | `health/` or `maps/Health MOC` |
| Finance records | `finances/` or `maps/Finances MOC` |
| Family events | `family/` or `maps/Family MOC` |
| Hobbies | `hobbies/` or `maps/Hobbies MOC` |
| A person/contact | `people/` |
| A standalone meeting | `meetings/` |
| Templates | `_templates/` (don't edit — used by commands) |

## The Power of One Vault

Having work and personal notes in the same vault unlocks insights that separate systems miss:

- **Time awareness**: `/schedule` balances work deadlines with study sessions and family commitments
- **Energy tracking**: `/log-health` entries correlate with work productivity and study focus
- **Cross-pollination**: `/connect` finds links between work projects and personal interests
- **Holistic reviews**: `/weekly-review` shows your whole life, not just one slice
- **Pattern discovery**: `/drift` surfaces themes that span work and personal contexts
