---
description: Identify clusters of personal ideas coalescing into potential projects, new hobbies, or life changes
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Find clusters of related personal ideas in my vault that could become a project, new hobby, or life goal.

## Instructions

1. Perform a comprehensive vault scan:
   - Read all daily notes from `{{VAULT_FOLDER}}/daily/` (last 30 days).
   - Read all personal project notes from `{{VAULT_FOLDER}}/projects/`.
   - Read study and course notes from `{{VAULT_FOLDER}}/study/` and `{{VAULT_FOLDER}}/courses/`.
   - Read health notes from `{{VAULT_FOLDER}}/health/`.
   - Read financial notes from `{{VAULT_FOLDER}}/finances/`.
   - Read family notes from `{{VAULT_FOLDER}}/family/`.
   - Read hobby notes from `{{VAULT_FOLDER}}/hobby/`.
   - Scan the people folder for context on relationships and shared interests.
   - Read weekly reviews for reflections and goals.

2. Build a topic map:
   - Extract all wiki-links and note which notes link to which.
   - Identify **clusters**: groups of 3+ notes that reference each other or share themes across personal domains.
   - Look for ideas that appear as fragments across multiple notes but don't have a home yet.
   - Pay special attention to cross-domain clusters (e.g., a health interest + a study topic + a hobby that could combine into something).

3. For each emerging cluster, evaluate:
   - **Density**: How many notes are involved? How tightly connected?
   - **Momentum**: Is this cluster growing (more recent mentions) or static?
   - **Completeness**: What's missing? What would make this a real project or commitment?
   - **Type**: Is this becoming a personal project? A new hobby? A lifestyle change? A learning path? A financial goal?

4. Present the findings:

```
## Personal Emergence Report

### Ready to Launch (dense cluster, growing momentum)

**1. <Potential Project/Hobby/Goal Name>**
- **Type**: personal project / new hobby / lifestyle change / learning path / financial goal
- **Core idea**: <what this cluster is about in 1-2 sentences>
- **Evidence** (N connected notes across M domains):
  - [[note]] (domain) -- <contribution to the cluster>
  - [[note]] (domain) -- <contribution>
  - [[note]] (domain) -- <contribution>
- **Momentum**: <growing / accelerating / steady>
- **What's missing**: <gaps to fill before this becomes real>
- **Suggested next step**: <concrete action>

**2. ...**

### Forming (visible cluster, needs more development)

**1. <Theme>**
- **Notes involved**: [[note]], [[note]], [[note]]
- **Domains**: <which personal areas are contributing>
- **Core thread**: <what connects them>
- **Needs**: <more research? trying it out? talking to someone? buying equipment?>

### Seeds (early signals, single ideas with potential)

**1. <Idea>**
- **Source**: [[note]]
- **Why it might grow**: <connection to other interests, life stage, or emerging needs>

### Recommended Actions
- [ ] Create a project note for "<cluster 1>" -- it's ready
- [ ] Create a hobby note for "<cluster 2>" -- start exploring
- [ ] Add a study note for "<topic>" -- research phase
- [ ] Revisit [[note]] -- the seed there connects to <existing interest>
- [ ] Talk to [[person]] about "<cluster>" -- they share this interest
```

5. Use wiki-links throughout. The user should be able to click into any note to see the full context.
6. Distinguish clearly between clusters that are ready for action and those that need more time to develop.
