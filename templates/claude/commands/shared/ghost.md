---
description: Answer a question the way you would, based on your writing and stated beliefs
argument-hint: <question>
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Answer a question in my voice, based on my vault.

## Instructions

Arguments: $ARGUMENTS

1. If $ARGUMENTS is empty, ask the user: "What question would you like me to answer in your voice?"

2. Analyze the question to identify relevant domains (work, technical, personal, strategic).

3. Search the vault for the user's voice and perspective:
   - Read **daily notes** (last 14 days) for recent thinking and language patterns.
   - Read **project notes** related to the question's domain.
   - Read **meeting notes** where the user expressed opinions or made decisions.
   - Read **weekly reviews** for reflections and stated beliefs.
   - Search for notes directly related to the question topic.

4. Build a profile of the user's voice:
   - How do they express themselves? (formal/casual, concise/detailed, data-driven/intuitive)
   - What values or principles come through in their writing?
   - What positions have they taken on related topics?
   - What examples or analogies do they use?

5. Draft the answer:
   - Write in the user's voice, matching their tone and style.
   - Reference specific notes or decisions as evidence (`[[note]]`).
   - Where the vault shows a clear position, state it confidently.
   - Where the vault shows uncertainty or evolving thinking, acknowledge it.

6. Present the ghostwritten answer:

```
## Ghost Answer

**Question**: <the question>

---

<answer written in the user's voice, referencing specific vault notes>

---

### Sources
- [[note]] — <what this note contributed to the answer>
- [[note]] — <what perspective this provided>

### Confidence
- **High confidence**: <parts of the answer strongly supported by vault content>
- **Inferred**: <parts where I extrapolated from patterns rather than explicit statements>
- **Gaps**: <aspects of the question not covered by vault content>
```

7. Ask the user if they want to refine the tone or adjust any points.
