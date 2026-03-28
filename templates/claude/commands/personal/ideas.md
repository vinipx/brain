---
description: Scan your vault for patterns and generate personal life ideas — skills to learn, health goals, hobby projects, family activities, financial goals
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Scan my vault for emerging patterns and generate fresh ideas for my personal life.

## Instructions

1. Perform a comprehensive vault scan:

   **Daily notes** (last 21 days):
   - Read all daily notes from `{{VAULT_FOLDER}}/daily/`.
   - Extract: recurring interests, frustrations, questions, goals mentioned, habits struggling with, things wished for.

   **Study & courses**:
   - Read all notes in `{{VAULT_FOLDER}}/study/` and `{{VAULT_FOLDER}}/courses/`.
   - Note: subjects being explored, skills being built, gaps in knowledge, adjacent interests.

   **Health**:
   - Read all notes in `{{VAULT_FOLDER}}/health/`.
   - Note: fitness patterns, health concerns, habits attempted, wellness interests.

   **Finances**:
   - Read all notes in `{{VAULT_FOLDER}}/finances/`.
   - Note: spending patterns, financial goals mentioned, investment interests.

   **Family**:
   - Read all notes in `{{VAULT_FOLDER}}/family/`.
   - Note: family dynamics, shared interests, activities enjoyed together.

   **Hobbies**:
   - Read all notes in `{{VAULT_FOLDER}}/hobby/`.
   - Note: hobbies explored, skills developing, creative output, gear or tools mentioned.

   **People**:
   - Scan `{{VAULT_FOLDER}}/people/`.
   - Note: who the user spends time with, shared interests, potential collaborators.

   **Weekly reviews**:
   - Read recent weekly reviews for reflections and stated personal goals.

2. Identify patterns:
   - What interests appear across multiple unrelated notes?
   - What skills is the user building? What adjacent skills would compound?
   - What problems or frustrations keep recurring without a solution?
   - What activities consistently produce positive reflections?
   - What goals are mentioned but never acted on?

3. Generate ideas across five categories:

```
## Personal Idea Report

### Skills to Learn
Based on your current interests and goals, these skills would be valuable:

1. **<skill idea>**
   - Signal: <what in the vault suggests this>
   - Why now: <connection to current studies, hobbies, or goals>
   - Starting point: <resource, course, or approach>

2. ...

### Health & Wellness Goals
Based on your health patterns and reflections:

1. **<health goal>**
   - Signal: <pattern from health notes or daily reflections>
   - Approach: <specific, actionable plan>
   - Connects to: <existing habits or goals>

2. ...

### Hobby & Creative Projects
Ideas for hobby projects based on your interests:

1. **<hobby project>**
   - Signal: <what in the vault suggests this>
   - Scope: <small / medium / ambitious>
   - What you'd need: <tools, time, skills>

2. ...

### Family & Social Activities
Activities that match shared interests:

1. **<activity idea>**
   - Signal: <family interests or past activities that worked well>
   - When: <suggested timing>
   - Who: <which family members or friends>

2. ...

### Financial Goals
Based on your spending patterns and stated goals:

1. **<financial goal>**
   - Signal: <spending pattern or goal mentioned>
   - Target: <specific, measurable objective>
   - First step: <concrete action>

2. ...

### Bonus: Surprising Connections
- <unexpected link between two areas of your personal life>
```

4. Ground every idea in specific vault content. No generic suggestions — every idea should trace back to something the user actually wrote or did.
