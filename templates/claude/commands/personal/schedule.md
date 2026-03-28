---
description: Suggest a weekly personal schedule based on your study goals, workouts, hobbies, family events, and course deadlines
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Based on my current personal priorities and commitments, suggest a schedule for this week.

## Instructions

1. Determine today's date, day of the week, and the remaining days in the current week (Monday-Sunday).

2. Gather the user's priorities and commitments:

   **Study & courses**:
   - Read all notes in `{{VAULT_FOLDER}}/study/` and `{{VAULT_FOLDER}}/courses/`.
   - Note: upcoming exams, assignment deadlines, study goals, preferred study times.

   **Health & fitness**:
   - Read all notes in `{{VAULT_FOLDER}}/health/`.
   - Note: workout schedule, planned activities, appointments, habit goals.

   **Hobbies**:
   - Read all notes in `{{VAULT_FOLDER}}/hobby/`.
   - Note: hobby sessions planned, project deadlines, events.

   **Family**:
   - Read all notes in `{{VAULT_FOLDER}}/family/`.
   - Note: family events, commitments, shared activities planned.

   **Finances**:
   - Read all notes in `{{VAULT_FOLDER}}/finances/`.
   - Note: bills due this week, financial reviews needed.

   **Personal projects**:
   - Read all notes in `{{VAULT_FOLDER}}/projects/` with `status: active`.
   - Note: priority, deadlines, open tasks.

   **Recent daily notes** (last 5):
   - Read to understand: what the user has been doing, stated priorities, recurring commitments.
   - Extract any time-related mentions ("I need to finish X by Sunday", "want to spend more time on Y").

   **Latest weekly review**:
   - Read for reflections on time allocation and stated intentions for the coming week.

   **Open tasks**:
   - Scan all recent notes for unchecked tasks (`- [ ]`) and their source.

3. Analyze time allocation:
   - Based on recent daily notes, estimate how the user has been spending personal time.
   - Compare this to stated priorities and goals. Flag misalignment.

4. Build the schedule:

```
## Suggested Personal Schedule -- Week of YYYY-MM-DD

### Priority Alignment Check
- **Stated priorities**: <from reviews and notes>
- **Actual time spent**: <from daily notes>
- **Misalignment**: <where stated priorities don't match time investment>

### Monday
- **Study block**: <subject/course> (X hours)
  - Why: <deadline, exam prep, or momentum>
- **Workout**: <type of exercise> (X min)
- **Tasks**: <specific items from open tasks>
- **Evening**: <family time, hobby, or rest>

### Tuesday
- ...

### Wednesday
- ...

### Thursday
- ...

### Friday
- ...

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
| Study/Courses | N hours | <exam / deadline / goal> |
| Health/Fitness | N hours | <workout plan / habit building> |
| Hobby | N hours | <project milestone / enjoyment> |
| Family | N hours | <event / quality time> |
| Personal projects | N hours | <deadline / momentum> |

### Flags
- <deadline approaching for [[course]]>
- <you said you'd work on X but haven't -- when will it happen?>
- <this habit has been skipped 3 days in a row>
- <family event on [[date]] needs preparation>
```

5. Be honest about conflicts between what the user says matters and how they're spending time. The goal is clarity, not judgment.
6. If today isn't Monday, only schedule the remaining days in the week.
