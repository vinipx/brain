---
description: Pressure-test your beliefs — find contradictions and weak points in your thinking
argument-hint: <topic>
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Review my thinking on a topic and challenge it.

## Instructions

Arguments: $ARGUMENTS

1. If $ARGUMENTS is empty, ask the user: "What topic or belief would you like me to challenge?"

2. Search the vault thoroughly for the user's positions on the topic:
   - Grep `{{VAULT_FOLDER}}/` for the topic across all note types.
   - Read relevant project notes, meeting notes, daily notes, and weekly reviews.
   - Pay special attention to **decisions made**, **opinions stated**, and **assumptions implied**.

3. Catalog the user's positions:
   - What have they explicitly said about this topic?
   - What decisions have they made that imply a belief?
   - What assumptions are embedded in their project plans or actions?

4. Perform the challenge:

   **Contradictions**: Find places where the user's stated beliefs conflict with each other or with their actions.

   **Weak assumptions**: Identify assumptions that aren't supported by evidence in the vault.

   **Missing perspectives**: What viewpoints or data points are absent from the user's thinking?

   **Risk exposure**: What could go wrong if the current beliefs are wrong?

   **Counter-arguments**: What would a thoughtful critic say?

5. Present the challenge:

```
## Challenge: <Topic>

### Your Current Position
Based on your vault, here's what you believe:
- <belief 1> (from [[note]])
- <belief 2> (from [[note]])
- <assumption> (implied by [[note]])

### Contradictions Found
- **<contradiction>**: In [[note A]] you said X, but in [[note B]] you decided Y.
  - Why this matters: <impact>

### Weak Points
- **<assumption>**: You're assuming <X>, but your vault has no evidence for this.
  - What if: <alternative scenario>

### Missing Perspectives
- <viewpoint not represented in your notes>
- <data or evidence you haven't considered>

### Risk Assessment
- If you're wrong about <X>, the consequence is: <Y>
- Probability: <estimate based on available info>

### Devil's Advocate
<a paragraph arguing the strongest possible case against the user's position>

### Recommendations
- [ ] <specific action to strengthen or correct the position>
- [ ] <note or research to address a gap>
- [ ] <conversation to have or perspective to seek>
```

6. Be honest but constructive. The goal is to strengthen the user's thinking, not to tear it down.
