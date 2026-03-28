---
description: Identify clusters of ideas across work and personal domains coalescing into potential projects, ventures, hobbies, or life changes
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Find clusters of related ideas across my vault that could become a new project, venture, hobby, or initiative.

## Instructions

1. Perform a comprehensive vault scan:

   **Work domain:**
   - Read all daily notes from `{{VAULT_FOLDER}}/daily/` (last 30 days).
   - Read all project notes from `{{VAULT_FOLDER}}/projects/`.
   - Read commercial notes from `{{VAULT_FOLDER}}/commercials/`.
   - Read coding references from `{{VAULT_FOLDER}}/coding/`.
   - Read meeting notes from `{{VAULT_FOLDER}}/meetings/`.

   **Personal domain:**
   - Read study and course notes from `{{VAULT_FOLDER}}/study/` and `{{VAULT_FOLDER}}/courses/`.
   - Read health notes from `{{VAULT_FOLDER}}/health/`.
   - Read financial notes from `{{VAULT_FOLDER}}/finances/`.
   - Read family notes from `{{VAULT_FOLDER}}/family/`.
   - Read hobby notes from `{{VAULT_FOLDER}}/hobby/`.

   **Cross-domain:**
   - Scan the people folder `{{VAULT_FOLDER}}/people/` for context on collaborators, relationships, and shared interests.
   - Read weekly reviews for reflections and goals.

2. Build a topic map:
   - Extract all wiki-links and note which notes link to which.
   - Identify **clusters**: groups of 3+ notes that reference each other or share themes across any domain.
   - Look for ideas that appear as fragments across multiple notes but don't have a home yet.
   - Pay special attention to **cross-domain clusters** (e.g., a coding skill + a hobby interest + a commercial opportunity that could combine into something).

3. For each emerging cluster, evaluate:
   - **Density**: How many notes are involved? How tightly connected?
   - **Momentum**: Is this cluster growing (more recent mentions) or static?
   - **Completeness**: What's missing? What would make this a real project or commitment?
   - **Type**: Is this becoming a work project? A product? A side business? A personal project? A new hobby? A lifestyle change? A learning path? A financial goal? An essay?
   - **Domain span**: Does it bridge work and personal life?

4. Present the findings:

```
## Emergence Report

### Ready to Launch (dense cluster, growing momentum)

**1. <Potential Project/Product/Venture/Hobby Name>**
- **Type**: work project / product / side business / personal project / new hobby / lifestyle change / learning path / essay
- **Domain span**: work only / personal only / cross-domain
- **Core idea**: <what this cluster is about in 1-2 sentences>
- **Evidence** (N connected notes across M domains):
  - [[note]] (domain) — <contribution to the cluster>
  - [[note]] (domain) — <contribution>
  - [[note]] (domain) — <contribution>
- **Momentum**: <growing / accelerating / steady>
- **What's missing**: <gaps to fill before this becomes real>
- **Suggested next step**: <concrete action>

**2. ...**

### Forming (visible cluster, needs more development)

**1. <Theme>**
- **Notes involved**: [[note]], [[note]], [[note]]
- **Domains**: <which areas are contributing>
- **Core thread**: <what connects them>
- **Needs**: <more research? a conversation? a prototype? trying it out? buying equipment?>

### Seeds (early signals, single ideas with potential)

**1. <Idea>**
- **Source**: [[note]]
- **Why it might grow**: <connection to other interests, market trends, life stage, or emerging needs>

### Cross-Domain Opportunities
Clusters that bridge work and personal life:

**1. <Opportunity>**
- **Work side**: [[note]], [[note]]
- **Personal side**: [[note]], [[note]]
- **Potential**: <what this could become if the domains are combined>
- **Example**: <a concrete way to pursue this>

### Recommended Actions
- [ ] Create a work project note for "<cluster 1>" — it's ready
- [ ] Create a personal project note for "<cluster 2>" — start exploring
- [ ] Create a hobby note for "<cluster 3>" — start exploring
- [ ] Add a study note for "<topic>" — research phase
- [ ] Revisit [[note]] — the seed there connects to <existing project or interest>
- [ ] Talk to [[person]] about "<cluster>" — they share this interest or have relevant expertise
```

5. Use wiki-links throughout. The user should be able to click into any note to see the full context.
6. Distinguish clearly between clusters that are ready for action and those that need more time to develop.
7. Highlight cross-domain opportunities — these are often the most valuable and least obvious.
