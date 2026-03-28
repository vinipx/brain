---
description: Load your full personal life state — projects, studies, health, finances, family, hobbies, current focus
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Read the vault and summarize my current personal context.

## Instructions

1. Determine today's date in YYYY-MM-DD format.
2. Scan the vault to build a full picture of the user's current personal state:

   **Active Personal Projects:**
   - Glob `{{VAULT_FOLDER}}/projects/*.md` and read each one. List those with `status: active` or `status: on-hold`.
   - Note key details: category, priority, timeline, recent progress.

   **Current Studies:**
   - Glob `{{VAULT_FOLDER}}/study/*.md` and read each one.
   - Note: subject, progress, goals, study method, resources being used.

   **Courses in Progress:**
   - Glob `{{VAULT_FOLDER}}/courses/*.md` and read each one.
   - Note: course name, platform, progress percentage, upcoming deadlines or assignments.

   **Recent Health Logs:**
   - Glob `{{VAULT_FOLDER}}/health/*.md` and read each one.
   - Note: workout routines, habits being tracked, appointments, health goals, recent entries.

   **Financial Overview:**
   - Glob `{{VAULT_FOLDER}}/finances/*.md` and read each one.
   - Note: budgets, savings goals, pending payments, investment tracking, recent transactions.

   **Family Events:**
   - Glob `{{VAULT_FOLDER}}/family/*.md` and read each one.
   - Note: upcoming events, important dates, shared plans, family commitments.

   **Hobbies:**
   - Glob `{{VAULT_FOLDER}}/hobby/*.md` and read each one.
   - Note: current hobby projects, skills being developed, materials or gear tracked.

   **Recent Focus (last 7 days):**
   - Read the most recent 7 daily notes from `{{VAULT_FOLDER}}/daily/`.
   - Extract: recurring topics, mentioned priorities, patterns in activities and habits.

   **Key People:**
   - Glob `{{VAULT_FOLDER}}/people/*.md` and read each one.
   - Note who appears frequently in recent daily notes and personal activities.

3. Present the summary in this format:

```
## Your Current Context

### Active Personal Projects
- [[project]] — status, category, priority, brief description
  - Recent: <latest progress or activity>

### Current Studies
- [[subject]] — topic, progress, method
  - Next: <upcoming milestone or goal>

### Courses in Progress
- [[course]] — platform, progress, next deadline

### Health Overview
- Habits: <active habits being tracked>
- Recent: <last workout, appointment, or health note>
- Goals: <current health goals>

### Financial Overview
- Active budgets: <summary>
- Upcoming: <pending payments, savings milestones>

### Family
- [[event/person]] — upcoming events, commitments

### Hobbies
- [[hobby]] — current focus, recent activity

### This Week's Focus
- <what the user has been spending time on based on daily notes>
- <recurring themes, mentioned priorities>

### Key People
- [[person]] — relationship/context, recent interactions

### Suggested Focus
- <based on patterns, what seems most important right now>
```

4. Keep the summary scannable. Use wiki-links so the user can jump to any note for details.
