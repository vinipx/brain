---
description: Load your full state across work and personal life — projects, commercials, studies, health, finances, family, hobbies, and current focus
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Read the vault and summarize my current context across both work and personal life.

## Instructions

1. Determine today's date in YYYY-MM-DD format.
2. Scan the vault to build a full picture of the user's current state across all domains:

   ### Work Domain

   **Active Projects:**
   - Glob `{{VAULT_FOLDER}}/projects/*.md` and read each one. List those with `status: active` or `status: on-hold`.
   - Note key details: client, priority, timeline, recent progress.
   - Categorize each project as work or personal based on tags or content.

   **Active Commercials:**
   - Glob `{{VAULT_FOLDER}}/commercials/*.md` and read each one. List those with `status: active`.
   - Note: client, value, probability, next steps.

   **Coding Projects:**
   - Glob `{{VAULT_FOLDER}}/coding/*.md` and read each one.
   - Note: repo name, language, status.

   **People in Context:**
   - Glob `{{VAULT_FOLDER}}/people/*.md` and read each one.
   - Note who appears frequently in recent daily notes, meetings, and personal activities.

   **Recent Meetings:**
   - Check `{{VAULT_FOLDER}}/meetings/` for recent meeting notes.
   - Note key outcomes and pending action items.

   ### Personal Domain

   **Current Studies:**
   - Glob `{{VAULT_FOLDER}}/study/*.md` and read each one.
   - Note: subject, progress, goals, study method, resources being used.

   **Courses in Progress:**
   - Glob `{{VAULT_FOLDER}}/courses/*.md` and read each one.
   - Note: course name, platform, progress percentage, upcoming deadlines or assignments.

   **Health Overview:**
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

   ### Cross-Domain

   **Recent Focus (last 7 days):**
   - Read the most recent 7 daily notes from `{{VAULT_FOLDER}}/daily/`.
   - Extract: recurring topics, mentioned priorities, patterns in tasks, meetings, and personal activities.

   **Recent Reflections:**
   - Check weekly reviews in `{{VAULT_FOLDER}}/daily/` (files matching `*-review.md`).
   - Extract any reflections or themes from the most recent review.

3. Present the summary in this format:

```
## Your Current Context

---

### Work

#### Active Projects
- [[project]] — status, client, priority, brief description
  - Recent: <latest progress or activity>

#### Active Commercials
- [[commercial]] — client, stage, next step

#### Coding Projects
- [[repo]] — language, status

#### Recent Meetings
- [[meeting]] — key outcome, pending actions

---

### Personal

#### Active Personal Projects
- [[project]] — status, category, priority, brief description
  - Recent: <latest progress or activity>

#### Current Studies
- [[subject]] — topic, progress, method
  - Next: <upcoming milestone or goal>

#### Courses in Progress
- [[course]] — platform, progress, next deadline

#### Health Overview
- Habits: <active habits being tracked>
- Recent: <last workout, appointment, or health note>
- Goals: <current health goals>

#### Financial Overview
- Active budgets: <summary>
- Upcoming: <pending payments, savings milestones>

#### Family
- [[event/person]] — upcoming events, commitments

#### Hobbies
- [[hobby]] — current focus, recent activity

---

### Cross-Domain

#### This Week's Focus
- <what the user has been spending time on based on daily notes>
- <recurring themes, mentioned priorities>

#### Key People
- [[person]] — role/context, recent interactions

#### Recent Reflections
- <themes from latest weekly review>

#### Suggested Focus
- Work: <based on patterns, what seems most important professionally>
- Personal: <based on patterns, what seems most important personally>
- Balance: <any observations about work-life balance from the notes>
```

4. Keep the summary scannable. Use wiki-links so the user can jump to any note for details.
