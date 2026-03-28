---
description: Scan your vault for patterns across work and personal life and generate ideas — tools, partnerships, skills, health goals, hobby projects, financial strategies
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Scan my vault for emerging patterns and generate fresh ideas across work and personal life.

## Instructions

1. Perform a comprehensive vault scan:

   **Daily notes** (last 21 days):
   - Read all daily notes from `{{VAULT_FOLDER}}/daily/`.
   - Extract: recurring topics, mentioned interests, frustrations, questions asked, ideas hinted at, goals mentioned, habits struggling with.

   **Work domain:**
   - Read all notes in `{{VAULT_FOLDER}}/projects/` and `{{VAULT_FOLDER}}/commercials/`.
   - Note: skills being used, domains being explored, gaps or needs mentioned.
   - Read all notes in `{{VAULT_FOLDER}}/coding/`.
   - Note: technologies, patterns, tools in use.
   - Scan `{{VAULT_FOLDER}}/meetings/` and `{{VAULT_FOLDER}}/people/`.
   - Note: who the user interacts with, what topics come up, who offers what expertise.

   **Personal domain:**
   - Read all notes in `{{VAULT_FOLDER}}/study/` and `{{VAULT_FOLDER}}/courses/`.
   - Note: subjects being explored, skills being built, gaps in knowledge, adjacent interests.
   - Read all notes in `{{VAULT_FOLDER}}/health/`.
   - Note: fitness patterns, health concerns, habits attempted, wellness interests.
   - Read all notes in `{{VAULT_FOLDER}}/finances/`.
   - Note: spending patterns, financial goals mentioned, investment interests.
   - Read all notes in `{{VAULT_FOLDER}}/family/`.
   - Note: family dynamics, shared interests, activities enjoyed together.
   - Read all notes in `{{VAULT_FOLDER}}/hobby/`.
   - Note: hobbies explored, skills developing, creative output, gear or tools mentioned.

   **Weekly reviews:**
   - Read recent weekly reviews for reflections and stated goals.

2. Identify patterns:
   - What topics appear across multiple unrelated notes?
   - What skills is the user building? What skills are adjacent?
   - What problems keep coming up without a solution?
   - What interests are growing but haven't become projects yet?
   - What activities consistently produce positive reflections?
   - What goals are mentioned but never acted on?

3. Generate ideas across seven categories:

```
## Idea Report

### Tools to Build
Based on your vault patterns, these tools could solve problems you keep encountering:

1. **<tool idea>**
   - Signal: <what in the vault suggests this>
   - What it solves: <problem>
   - Starting point: <relevant notes or repos>

2. ...

### People to Reach Out To
Based on your projects and interests, these connections could be valuable:

1. **[[person]]** — <why now, what to discuss>
2. **New connection**: <type of person to seek, based on gaps in your network>

### Topics to Investigate
Ideas that keep surfacing and deserve deeper exploration:

1. **<topic>**
   - Appears in: [[note]], [[note]], [[note]]
   - Why it matters: <connection to goals or projects>
   - Suggested next step: <read, research, experiment>

2. ...

### Skills to Learn
Based on your current work and personal interests, these skills would compound:

1. **<skill idea>**
   - Signal: <what in the vault suggests this>
   - Why now: <connection to current studies, projects, or goals>
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

### Things to Write
Ideas ripe for essays, blog posts, or documentation:

1. **<writing idea>**
   - Core insight: <the idea distilled>
   - Evidence: <notes that support it>
   - Audience: <who would care>

2. ...

### Bonus: Surprising Connections
- <unexpected link between work and personal domains>
- <cross-domain insight that could spark something new>
```

4. Ground every idea in specific vault content. No generic suggestions — every idea should trace back to something the user actually wrote or did.
