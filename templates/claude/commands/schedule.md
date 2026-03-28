---
description: Suggest a weekly schedule based on your priorities, projects, and how you actually spend time
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Based on my current projects and priorities, suggest a schedule for this week.

## Instructions

1. Determine today's date, day of the week, and the remaining days in the current week (Monday–Friday).

2. Gather the user's priorities and commitments:

   **Active projects**:
   - Read all notes in `{{VAULT_FOLDER}}/projects/` with `status: active`.
   - Note: priority, deadlines, recent progress, open tasks.

   **Active presales**:
   - Read all notes in `{{VAULT_FOLDER}}/presales/` with `status: active`.
   - Note: deadlines, deliverables, next steps.

   **Recent daily notes** (last 5):
   - Read to understand: what the user has been working on, stated priorities, recurring meetings.
   - Extract any time-related mentions ("I need to finish X by Friday", "should spend more time on Y").

   **Latest weekly review**:
   - Read for reflections on time allocation and stated intentions for the coming week.

   **Open tasks**:
   - Scan all recent notes for unchecked tasks (`- [ ]`) and their source.

3. Analyze time allocation:
   - Based on recent daily notes, estimate how the user has been spending time.
   - Compare this to stated priorities. Flag misalignment.

4. Build the schedule:

```
## Suggested Schedule — Week of YYYY-MM-DD

### Priority Alignment Check
- **Stated priorities**: <from reviews and notes>
- **Actual time spent**: <from daily notes>
- **Misalignment**: <where stated priorities don't match time investment>

### Monday
- **Focus block**: <project/task> (2-3 hours)
  - Why: <deadline, momentum, or priority alignment>
- **Tasks**: <specific items from open tasks>
- **Meetings**: <if known from patterns>

### Tuesday
- ...

### Wednesday
- ...

### Thursday
- ...

### Friday
- **Weekly review**: Run `/weekly-review`
- **Focus**: <wrap-up items, preparation for next week>

### Time Budget
| Project/Area | Suggested Hours | Reason |
|---|---|---|
| <project> | N hours | <deadline / priority / momentum> |
| <presale> | N hours | <next deliverable> |
| <other> | N hours | <reason> |

### Flags
- <deadline approaching for [[project]]>
- <you said you'd do X but haven't — when will it happen?>
- <this presale needs attention before it goes cold>
```

5. Be honest about conflicts between what the user says matters and how they're spending time. The goal is clarity, not judgment.
6. If today isn't Monday, only schedule the remaining days in the week.
