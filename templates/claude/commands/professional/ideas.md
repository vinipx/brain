---
description: Scan your vault for patterns and generate ideas — tools to build, people to meet, topics to explore, things to write
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Scan my vault for emerging patterns and generate fresh ideas.

## Instructions

1. Perform a comprehensive vault scan:

   **Daily notes** (last 21 days):
   - Read all daily notes from `{{VAULT_FOLDER}}/daily/`.
   - Extract: recurring topics, mentioned interests, frustrations, questions asked, ideas hinted at.

   **Projects and commercials**:
   - Read all notes in `{{VAULT_FOLDER}}/projects/` and `{{VAULT_FOLDER}}/commercials/`.
   - Note: skills being used, domains being explored, gaps or needs mentioned.

   **Coding projects**:
   - Read all notes in `{{VAULT_FOLDER}}/coding/`.
   - Note: technologies, patterns, tools in use.

   **Meetings and people**:
   - Scan `{{VAULT_FOLDER}}/meetings/` and `{{VAULT_FOLDER}}/people/`.
   - Note: who the user interacts with, what topics come up, who offers what expertise.

   **Weekly reviews**:
   - Read recent weekly reviews for reflections and stated goals.

2. Identify patterns:
   - What topics appear across multiple unrelated notes?
   - What skills is the user building? What skills are adjacent?
   - What problems keep coming up without a solution?
   - What interests are growing but haven't become projects yet?

3. Generate ideas across four categories:

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

### Things to Write
Ideas ripe for essays, blog posts, or documentation:

1. **<writing idea>**
   - Core insight: <the idea distilled>
   - Evidence: <notes that support it>
   - Audience: <who would care>

2. ...

### Bonus: Surprising Connections
- <unexpected link between two areas of your vault>
```

4. Ground every idea in specific vault content. No generic suggestions — every idea should trace back to something the user actually wrote or did.
