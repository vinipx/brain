---
description: Suggest a weekly schedule balancing work priorities, meetings, study time, workouts, hobbies, and family events
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Based on my current work and personal priorities, suggest a balanced schedule for this week.

## Instructions

1. Determine today's date, day of the week, and the remaining days in the current week (Monday-Sunday).

2. Gather the user's priorities and commitments across all domains:

   **Work:**
   - Read all notes in `{{VAULT_FOLDER}}/projects/` with `status: active`.
   - Note: priority, deadlines, recent progress, open tasks.
   - Read all notes in `{{VAULT_FOLDER}}/commercials/` with `status: active`.
   - Note: deadlines, deliverables, next steps.

   **Study & courses:**
   - Read all notes in `{{VAULT_FOLDER}}/study/` and `{{VAULT_FOLDER}}/courses/`.
   - Note: upcoming exams, assignment deadlines, study goals, preferred study times.

   **Health & fitness:**
   - Read all notes in `{{VAULT_FOLDER}}/health/`.
   - Note: workout schedule, planned activities, appointments, habit goals.

   **Hobbies:**
   - Read all notes in `{{VAULT_FOLDER}}/hobby/`.
   - Note: hobby sessions planned, project deadlines, events.

   **Family:**
   - Read all notes in `{{VAULT_FOLDER}}/family/`.
   - Note: family events, commitments, shared activities planned.

   **Finances:**
   - Read all notes in `{{VAULT_FOLDER}}/finances/`.
   - Note: bills due this week, financial reviews needed.

   **Recent daily notes** (last 5):
   - Read to understand: what the user has been working on, stated priorities, recurring meetings and commitments.
   - Extract any time-related mentions ("I need to finish X by Friday", "want to study Y this week", "workout at 7am").

   **Latest weekly review:**
   - Read for reflections on time allocation and stated intentions for the coming week.

   **Open tasks:**
   - Scan all recent notes for unchecked tasks (`- [ ]`) and their source.

3. Analyze time allocation:
   - Based on recent daily notes, estimate how the user has been splitting time between work and personal activities.
   - Compare this to stated priorities. Flag misalignment.
   - Check for work-life balance issues.

4. Build the schedule:

```
## Suggested Schedule — Week of YYYY-MM-DD

### Priority Alignment Check
- **Work priorities**: <from projects, commercials, reviews>
- **Personal priorities**: <from studies, health, family, hobbies>
- **Actual time spent**: <from daily notes>
- **Misalignment**: <where stated priorities don't match time investment>

### Monday
- **Work focus block**: <project/task> (2-3 hours)
  - Why: <deadline, momentum, or priority alignment>
- **Study block**: <subject/course> (X hours)
- **Workout**: <type of exercise> (X min)
- **Tasks**: <specific items from open tasks>
- **Meetings**: <if known from patterns>
- **Evening**: <family time, hobby, or rest>

### Tuesday
- ...

### Wednesday
- ...

### Thursday
- ...

### Friday
- **Weekly wrap-up**: close out work items
- **Focus**: <preparation for next week>

### Saturday
- **Hobby time**: <project or activity> (X hours)
- **Family**: <planned activity or quality time>
- **Errands**: <any pending tasks, shopping, finances>

### Sunday
- **Weekly review**: Run `/weekly-review`
- **Prep**: <plan for the coming week>
- **Rest & recharge**: <leisure, reading, social>

### Time Budget
| Area | Suggested Hours | Reason |
|---|---|---|
| Work projects | N hours | <deadline / priority / momentum> |
| Commercials | N hours | <next deliverable> |
| Study/Courses | N hours | <exam / deadline / goal> |
| Health/Fitness | N hours | <workout plan / habit building> |
| Hobby | N hours | <project milestone / enjoyment> |
| Family | N hours | <event / quality time> |

### Flags
- <deadline approaching for [[project]]>
- <you said you'd do X but haven't — when will it happen?>
- <this commercial needs attention before it goes cold>
- <exam coming up for [[course]] — schedule more study time>
- <this habit has been skipped 3 days in a row>
- <family event on [[date]] needs preparation>
- <work-life balance concern: too much time on X, not enough on Y>
```

5. Be honest about conflicts between what the user says matters and how they're spending time. The goal is clarity, not judgment.
6. If today isn't Monday, only schedule the remaining days in the week.
