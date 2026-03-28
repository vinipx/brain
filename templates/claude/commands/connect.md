---
description: Find unexpected connections between two topics using your vault's link graph
argument-hint: "<topic A> and <topic B>"
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Find connections between two topics in my vault.

## Instructions

Arguments: $ARGUMENTS

1. Parse $ARGUMENTS to identify two topics. If not clear or missing, ask the user:
   "What two topics would you like me to connect? (e.g., 'machine learning and client onboarding')"

2. For each topic separately, search the vault:
   - Grep `{{VAULT_FOLDER}}/` recursively for each topic and related terms.
   - Find all notes that mention each topic.
   - Extract wiki-links from those notes to build a connection graph.

3. Find the bridges:
   - **Direct connections**: Notes that mention both topics.
   - **One-hop connections**: Notes about topic A that link to notes about topic B (via wiki-links).
   - **Shared connections**: Notes, people, projects, or tags that both topics link to.
   - **Temporal proximity**: Days where both topics appeared in the same daily note or close together.

4. Analyze the patterns:
   - Why might these topics be connected?
   - What shared themes, people, or projects bridge them?
   - Are there connections the user might not have noticed?

5. Present the findings:

```
## Connections: <Topic A> ↔ <Topic B>

### Direct Links
- [[note]] — mentions both topics: <context>

### Bridge Notes
- [[note A]] → [[bridge note]] → [[note B]]
  <how the bridge connects them>

### Shared Context
- **People**: [[person]] appears in both domains
- **Projects**: [[project]] touches both topics
- **Themes**: <recurring idea or pattern>

### Timeline Overlap
- YYYY-MM-DD: Both topics appeared in [[daily note]] — <context>

### Unexpected Patterns
- <non-obvious connections or insights>
- <suggestions for how these connections could be explored further>

### Strength Assessment
- **Connection strength**: strong / moderate / tenuous
- **Suggestion**: <what to do with this connection — explore further, create a project, write about it, etc.>
```

6. If no connections are found, say so honestly and suggest what kind of notes or activities might create a bridge between the two topics.
