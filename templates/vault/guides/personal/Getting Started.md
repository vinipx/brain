---
type: guide
tags: [guide, getting-started]
---

# Getting Started

How to use this Obsidian vault with Claude Code for personal knowledge management.

## Your First Day

1. Open a terminal in your vault's root directory (where `CLAUDE.md` lives)
2. Run `claude` to start Claude Code
3. Type `/daily` — Claude creates today's daily note with a ready-to-fill structure
4. Open Obsidian and navigate to `daily/` to see your note

## Core Workflow

```
Morning:  /daily            --> Create today's note
Health:   /log-health       --> Track wellness, exercise, symptoms
Study:    /new-study        --> Start a new study topic or research
Courses:  /new-course       --> Track an online course or class
Finance:  /new-finance      --> Log expenses, budgets, financial goals
Family:   /new-family-event --> Record family milestones and events
Hobbies:  /new-hobby        --> Track a hobby or creative pursuit
Friday:   /weekly-review    --> Summarize your week
Anytime:  /vault-status     --> See what's active and what needs attention
```

## How Notes Connect

Everything links together through `[[wiki-links]]`:

```
Daily Note --> logs a Health entry --> connects to a Fitness Goal
     |                                       |
  Study notes                        Course (if related)
     |
  Finance tracking --> links to Budget goals
     |
  Family events --> links to People
```

The **Maps of Content** (MOC) in `maps/` are your navigation hubs. Start there when browsing.

## A Typical Week

### Monday

```
/daily
  --> Plan the week, note any appointments
/log-health
  --> Log weekend activity, sleep quality, how you feel
```

### Tuesday -- Thursday

```
/daily
  --> Capture thoughts, tasks, ideas throughout the day
/new-study or /new-course
  --> Log study sessions, lecture notes, reading progress
/new-finance
  --> Track purchases or review budget
```

### Friday

```
/daily
  --> Wrap up the week
/weekly-review
  --> See patterns in health, study progress, spending
```

### Weekend

```
/new-hobby
  --> Log hobby sessions, creative work, side projects
/new-family-event
  --> Record family outings, milestones, gatherings
```

## Where Things Live

| What you're looking for | Where to find it |
|------------------------|-----------------|
| Today's notes | `daily/YYYY-MM-DD.md` |
| A study topic | `studies/` or `maps/Studies MOC` |
| A course | `courses/` or `maps/Courses MOC` |
| Health logs | `health/` or `maps/Health MOC` |
| Finance records | `finances/` or `maps/Finances MOC` |
| Family events | `family/` or `maps/Family MOC` |
| Hobbies | `hobbies/` or `maps/Hobbies MOC` |
| People/contacts | `people/` |
| Templates | `_templates/` (don't edit — used by commands) |
