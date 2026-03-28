---
type: guide
tags: [guide, claude-code, tips]
---

# Claude Code Tips & Tricks

How to use Claude Code effectively with this vault.

## Starting a Session

Always run Claude Code from your vault's root directory (where `CLAUDE.md` lives) so it loads the vault context and slash commands:

```bash
cd ~/Documents/brain    # or wherever you installed
claude
```

## Natural Language Works

You don't always need slash commands. Claude understands the vault structure:

```
"Add a meeting about the roadmap to today's daily"
"What projects are currently active?"
"Show me all commercials related to test automation"
"Create a person note for Maria Garcia from Acme Corp"
"What did I do last Wednesday?"
"Find all open tasks across my notes"
```

## Combining Commands with Conversation

After running a command, continue the conversation to refine:

```
> /new-project
[Claude asks for details, creates the note]

> "Also link it to the my-app coding reference and add a task to set up CI/CD"
[Claude updates the project note with links and tasks]
```

## Working with Coding Projects

Use `/link-coding` to create vault references, then use natural language to explore:

```
> /link-coding my-app
[Claude creates coding/my-app.md]

> "What's the test setup in my-app?"
[Claude reads the actual repo and answers]
```

The `coding/` notes are entry points -- Claude can follow the `repo-path` to read the actual source code.

## Bulk Operations

Ask Claude to do multiple things at once:

```
"Link all repos from my coding directory"
"Create person notes for Alice, Bob, and Carol from ClientX"
"Move all completed projects to the Completed section in the Projects MOC"
```

## Searching Across the Vault

Ask Claude to search rather than browsing manually:

```
"Which meetings mentioned the migration?"
"Show me the commercial timeline for Acme Corp"
"What action items are still open from this week?"
"Find all notes linked to [[John Smith]]"
```

## Context Awareness

Claude reads `CLAUDE.md` at the start of every session, so it knows:
- The folder structure and what goes where
- Frontmatter conventions (type, status, tags)
- How notes link together
- Where coding repos live

You don't need to re-explain the system each time.

## Keeping the Vault Healthy

Run these periodically:

| When | What |
|------|------|
| Every morning | `/daily` -- start your day |
| After each meeting | `/add-meeting` -- capture while it's fresh |
| End of week | `/weekly-review` -- reflect and plan |
| Anytime | `/vault-status` -- check for orphan notes, stale items |

## Pro Tips

1. **Start with the daily note** -- it becomes the hub for everything you did that day
2. **Link aggressively** -- every project mention, person name, and commercial reference should be a wiki-link
3. **Use the MOCs** -- keep them updated so the graph view stays useful
4. **Let Claude do the bookkeeping** -- creating cross-links, updating MOCs, and generating reviews is where Claude shines
5. **Ask for summaries** -- "summarize the last 3 meetings about Project X" works because all the data is in the vault
