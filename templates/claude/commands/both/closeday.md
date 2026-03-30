---
description: Capture what happened today across work and personal life — meetings, tasks, study, health, spending, family, hobbies
allowed-tools: [Read, Write, Glob, Grep, Edit, "Bash(*)"]
---

Review what I worked on today across both work and personal life and close out the day.

**IMPORTANT**: This command is strictly about TODAY. Do NOT read or summarize historical daily notes, previous days, or any past data. Only today's date matters.

## Instructions

1. Determine today's date in YYYY-MM-DD format.
2. Read today's daily note at `{{VAULT_FOLDER}}/daily/YYYY-MM-DD.md`.
   - If it does **NOT** exist: tell the user "No daily note found for today (YYYY-MM-DD). Run `/daily` first to create one, then run `/closeday` again." — then **STOP**. Do not proceed to any other step. Do not read previous daily notes. Do not offer alternatives.

3. Gather today's activity **only from today's daily note and today's files**:

   **Work activity:**
   - **From the daily note**: meetings, tasks (completed and open), notes.
   - **From meeting notes**: check if any files in `{{VAULT_FOLDER}}/meetings/` start with today's date.

   **Personal activity:**
   - Check if any files in the following folders have today's date in their filename or frontmatter: `{{VAULT_FOLDER}}/study/`, `{{VAULT_FOLDER}}/courses/`, `{{VAULT_FOLDER}}/health/`, `{{VAULT_FOLDER}}/finances/`, `{{VAULT_FOLDER}}/family/`, `{{VAULT_FOLDER}}/hobby/`.

4. Build the end-of-day summary and update the daily note by appending an `## End of Day` section:

```markdown
## End of Day

### Work Progress
- <what was accomplished professionally today, with [[links]] to relevant notes>

### Meetings Recap
- <meeting> — key outcome: <one-liner>

### Personal Progress

#### Study & Learning
- <what was studied, for how long, key takeaways>
- Course progress: <any assignments completed, lectures watched>

#### Health & Wellness
- <workout completed or skipped, habits tracked>
- <how energy/mood was today>

#### Finances
- <any spending, bills paid, financial decisions>

#### Family & Social
- <family interactions, events attended, quality time>

#### Hobby Progress
- <what was done, any milestones or creative output>

### New Ideas
- <any ideas that surfaced during the day worth noting>

### Carry-Over to Tomorrow
- [ ] <unfinished work task> (from: <project/commercial>)
- [ ] <unfinished personal task> (from: <domain>)

### Reflections
- <what went well>
- <what could improve>
- <gratitude or highlight of the day>
```

5. Mark completed tasks in the daily note: change `- [ ]` to `- [x]` for tasks the user confirms are done. Ask the user to confirm which tasks were completed if unclear.

6. If any carry-over tasks exist, mention: "These will appear when you run `/today` tomorrow morning."

7. **Collect Claude Code session analytics** and create the analytics note:

   a. **Read pricing** from `{{VAULT_FOLDER}}/_analytics/token-pricing.md`. If missing, use defaults:
      - claude-opus-4-6: input=$15.00, output=$75.00, cache_read=$1.50, cache_write=$18.75
      - claude-sonnet-4-6: input=$3.00, output=$15.00, cache_read=$0.30, cache_write=$3.75
      - claude-haiku-4-5: input=$0.80, output=$4.00, cache_read=$0.08, cache_write=$1.00

   b. **Find today's sessions** for this vault:
      - Convert the install directory path (parent of `{{VAULT_FOLDER}}/`) to the Claude project path: replace `/` with `-`, prepend `-`, look under `~/.claude/projects/`.
      - List all `.jsonl` files in that project directory.
      - For each, check `~/.claude/sessions/<session-id>.json` to get `startedAt` timestamp.
      - Filter to sessions started today.

   c. **Parse token usage** from each session JSONL using `jq`:
      ```bash
      cat "<session>.jsonl" | jq -s '[.[] | select(.message.usage != null) | .message.usage] | {
        input: (map(.input_tokens // 0) | add),
        output: (map(.output_tokens // 0) | add),
        cache_read: (map(.cache_read_input_tokens // 0) | add),
        cache_write: (map(.cache_creation_input_tokens // 0) | add)
      }'
      ```
      Also count messages per session and detect models used.

   d. **Calculate costs**: cost = (input * input_rate + output * output_rate + cache_read * cache_read_rate + cache_write * cache_write_rate) / 1,000,000

   e. **Create analytics note** at `{{VAULT_FOLDER}}/_analytics/sessions/YYYY-MM-DD.md`:
      ```markdown
      ---
      date: "YYYY-MM-DD"
      type: session-analytics
      tags: [analytics, sessions]
      total_sessions: N
      total_input_tokens: NNNNN
      total_output_tokens: NNNNN
      total_cache_read_tokens: NNNNN
      total_cache_write_tokens: NNNNN
      total_cost_usd: N.NN
      models_used: [model-1, model-2]
      ---

      # Session Analytics — Month DD, YYYY

      ## Summary
      | Metric | Value |
      |--------|-------|
      | Sessions | N |
      | Input Tokens | X,XXX |
      | Output Tokens | X,XXX |
      | Cache Read Tokens | X,XXX |
      | Cache Write Tokens | X,XXX |
      | Estimated Cost | $X.XX |

      ## Sessions

      ### Session 1 — HH:MM to HH:MM
      | Metric | Value |
      |--------|-------|
      | Messages | NN |
      | Input Tokens | X,XXX |
      | Output Tokens | X,XXX |
      | Cost | $X.XX |
      ```

   f. **Append usage summary** to the daily note after the End of Day section:
      ```markdown
      ### Claude Usage
      - Sessions: N | Cost: $X.XX | Tokens: X,XXX in / X,XXX out
      - Details: [[YYYY-MM-DD]] (in _analytics/sessions/)
      ```

   g. If no sessions found for today, skip the analytics section silently.

8. Present a brief summary of the day to the user, including the token/cost stats if available.
