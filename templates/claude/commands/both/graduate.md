---
description: Extract undeveloped ideas from daily notes and promote them into work projects, personal projects, study subjects, courses, or hobby notes
allowed-tools: [Read, Write, Glob, Grep, Edit, "Bash(date:*)"]
---

Scan recent daily notes for ideas that deserve their own note — across both work and personal domains.

## Instructions

1. Determine today's date and calculate the date 14 days ago.
2. Read all daily notes from the last 14 days in `{{VAULT_FOLDER}}/daily/`.
3. For each daily note, scan for:
   - Ideas or insights that go beyond a simple task or meeting record.
   - Observations, hypotheses, or questions that could develop further.
   - Recurring themes that appear across multiple days.
   - Notes that are long enough to suggest depth but lack their own file.
   - Anything prefixed with "idea:", "thought:", "what if", "I wonder", "I should", "I want to", or similar markers.
   - Professional ideas: tools to build, process improvements, business opportunities, client strategies.
   - Personal ideas: skills to learn, hobby projects, health changes, family activities, financial goals.

4. For each idea worth graduating, evaluate:
   - Is it mentioned more than once across different days? (stronger candidate)
   - Does it connect to existing projects, commercials, coding work, studies, courses, or hobbies?
   - Is it developed enough to stand on its own, or does it need more context?
   - What is its natural home? (work project, personal project, study subject, course, hobby, health goal, financial goal)

5. Present the candidates to the user before creating files:

```
## Ideas Ready to Graduate

### 1. <Idea Title>
- **First appeared**: [[YYYY-MM-DD]] — "<original phrasing>"
- **Also mentioned**: [[YYYY-MM-DD]], [[YYYY-MM-DD]]
- **Core claim**: <the idea distilled into one sentence>
- **Connections**: [[project]], [[topic]], [[study subject]], [[hobby]]
- **Suggested destination**: projects (work) / projects (personal) / study / courses / hobby / health / finances
- **Maturity**: Ready to develop / Needs more thinking

### 2. ...
```

6. Ask the user which ideas they want to promote and confirm the destination folder. For each approved idea, create a standalone note at the appropriate location:

   **For work projects** (`{{VAULT_FOLDER}}/projects/<kebab-case-title>.md`):
   ```markdown
   ---
   type: project
   status: active
   origin: graduated from daily notes
   tags: [project, work, idea]
   created: "YYYY-MM-DD"
   ---

   # <Idea Title>

   ## Core Claim
   <the idea in 1-2 sentences>

   ## Context
   <where this came from — daily notes, conversations, observations>
   - First noted in [[YYYY-MM-DD]]: "<original context>"

   ## Development
   <expanded thinking, implications, next steps>

   ## Connections
   - [[related note]]
   - [[related project]]

   ## Open Questions
   - <what needs to be resolved or explored>
   ```

   **For personal projects** (`{{VAULT_FOLDER}}/projects/<kebab-case-title>.md`):
   ```markdown
   ---
   type: project
   status: active
   origin: graduated from daily notes
   tags: [project, personal]
   created: "YYYY-MM-DD"
   ---

   # <Idea Title>

   ## Goal
   <what this project aims to achieve>

   ## Context
   <where this came from — daily notes, observations, interests>
   - First noted in [[YYYY-MM-DD]]: "<original context>"

   ## Plan
   <steps to move forward>

   ## Connections
   - [[related note]]
   - [[related hobby or study]]

   ## Open Questions
   - <what needs to be resolved or explored>
   ```

   **For study subjects** (`{{VAULT_FOLDER}}/study/<kebab-case-title>.md`):
   ```markdown
   ---
   type: study
   status: active
   origin: graduated from daily notes
   tags: [study, learning]
   created: "YYYY-MM-DD"
   ---

   # <Subject Title>

   ## What to Learn
   <the topic or skill in 1-2 sentences>

   ## Why
   <motivation — what sparked this interest>
   - First noted in [[YYYY-MM-DD]]: "<original context>"

   ## Resources
   - <books, courses, videos, articles to explore>

   ## Progress
   - <starting point, what's known already>

   ## Connections
   - [[related note]]
   ```

   **For hobbies** (`{{VAULT_FOLDER}}/hobby/<kebab-case-title>.md`):
   ```markdown
   ---
   type: hobby
   status: active
   origin: graduated from daily notes
   tags: [hobby]
   created: "YYYY-MM-DD"
   ---

   # <Hobby Title>

   ## What
   <the hobby or creative pursuit>

   ## Inspiration
   <where this came from>
   - First noted in [[YYYY-MM-DD]]: "<original context>"

   ## Getting Started
   - <what's needed: tools, materials, skills, space>

   ## Goals
   - <what would success look like>

   ## Connections
   - [[related note]]
   ```

7. Update the relevant **MOC** (Projects, or the appropriate domain MOC) to include the new notes.
8. Add a wiki-link back to the new note from the original daily notes under `## Links Created Today`.
9. Summarize what was created and where each idea was placed.
