---
description: Identify patterns coalescing into something bigger — scattered thoughts becoming projects
allowed-tools: [Read, Glob, Grep, "Bash(date:*)"]
---

Find clusters of related ideas in my vault that could become a project, essay, or product.

## Instructions

1. Perform a comprehensive vault scan:
   - Read all daily notes from `{{VAULT_FOLDER}}/daily/` (last 30 days).
   - Read all project notes, presale notes, and coding references.
   - Read meeting notes and weekly reviews.
   - Scan the people folder for context on collaborators.

2. Build a topic map:
   - Extract all wiki-links and note which notes link to which.
   - Identify **clusters**: groups of 3+ notes that reference each other or share themes.
   - Look for ideas that appear as fragments across multiple notes but don't have a home yet.

3. For each emerging cluster, evaluate:
   - **Density**: How many notes are involved? How tightly connected?
   - **Momentum**: Is this cluster growing (more recent mentions) or static?
   - **Completeness**: What's missing? What would make this a real project?
   - **Type**: Is this becoming a project? An essay? A product? A research thread?

4. Present the findings:

```
## Emergence Report

### Ready to Launch (dense cluster, growing momentum)

**1. <Potential Project/Essay/Product Name>**
- **Type**: project / essay / product / research
- **Core idea**: <what this cluster is about in 1-2 sentences>
- **Evidence** (N connected notes):
  - [[note]] — <contribution to the cluster>
  - [[note]] — <contribution>
  - [[note]] — <contribution>
- **Momentum**: <growing / accelerating / steady>
- **What's missing**: <gaps to fill before this becomes real>
- **Suggested next step**: <concrete action>

**2. ...**

### Forming (visible cluster, needs more development)

**1. <Theme>**
- **Notes involved**: [[note]], [[note]], [[note]]
- **Core thread**: <what connects them>
- **Needs**: <more research? a conversation? a prototype?>

### Seeds (early signals, single ideas with potential)

**1. <Idea>**
- **Source**: [[note]]
- **Why it might grow**: <connection to other interests or trends>

### Recommended Actions
- [ ] Create a project note for "<cluster 1>" — it's ready
- [ ] Write a brainstorm note for "<cluster 2>" — explore further
- [ ] Revisit [[note]] — the seed there connects to <existing project>
```

5. Use wiki-links throughout. The user should be able to click into any note to see the full context.
6. Distinguish clearly between clusters that are ready for action and those that need more time to develop.
