---
description: Generate a weekly review summarizing the past 7 days across all personal domains
allowed-tools: [Read, Write, Glob, Grep, Edit, "Bash(ls:*)", "Bash(date:*)"]
---

Generate a summary of the past week's personal activity.

## Instructions

1. List all daily notes in `{{VAULT_FOLDER}}/daily/` sorted by date descending. Take the most recent 7.
2. Read each of those daily notes.
3. Aggregate across all personal domains:
   - **Study & courses**: sessions completed, topics covered, assignments submitted, hours estimated.
   - **Health & fitness**: workouts completed, habits maintained or broken, appointments attended.
   - **Finances**: spending summary, bills paid, savings progress, notable transactions.
   - **Family**: events attended, quality time, commitments fulfilled.
   - **Hobbies**: time spent, milestones reached, creative output.
   - **Personal projects**: progress made, tasks completed, blockers encountered.
   - Tasks completed (checked `- [x]`)
   - Tasks still open (unchecked `- [ ]`)
4. Determine the ISO week number and date range.
5. Create a review note at `{{VAULT_FOLDER}}/daily/YYYY-WNN-review.md`:

```markdown
---
type: weekly-review
week: "YYYY-WNN"
date-range: "YYYY-MM-DD to YYYY-MM-DD"
tags: [weekly-review]
---

# Week NN Review (YYYY-MM-DD to YYYY-MM-DD)

## Study & Learning
- <subjects studied, hours estimated, key takeaways>
- Courses: <progress on active courses, assignments completed>

## Health & Fitness
- Workouts: <N completed out of planned>
- Habits: <streaks maintained, habits skipped>
- Appointments: <any health appointments>

## Finances
- Total spending: <estimate if tracked>
- Bills paid: <list>
- Savings: <progress toward goals>

## Family & Social
- <events, quality time, notable interactions>

## Hobbies
- <time spent, what was done, any milestones>

## Personal Projects
- [[project]] — <what happened>

## Completed Tasks
- [x] <task> (from [[source]])

## Open Tasks
- [ ] <task> (from [[source]])

## Reflections
- What went well:
- What could improve:
- Focus for next week:

```

6. Present the summary to the user.
