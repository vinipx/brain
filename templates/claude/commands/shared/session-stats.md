---
description: Show Claude Code session stats for today — tokens, cost, and session count
allowed-tools: [Read, Glob, Grep, "Bash(*)"]
---

Show me token usage and estimated costs for today's Claude Code sessions.

## Instructions

1. Determine today's date in YYYY-MM-DD format and the vault's absolute install path (the parent of `{{VAULT_FOLDER}}/`).

2. **Read pricing configuration** from `{{VAULT_FOLDER}}/_analytics/token-pricing.md`.
   - Parse the pricing table to get per-model rates (Input $/1M, Output $/1M, Cache Read $/1M, Cache Write $/1M).
   - If the file doesn't exist, use these defaults:
     - claude-opus-4-6: input=$15.00, output=$75.00, cache_read=$1.50, cache_write=$18.75
     - claude-sonnet-4-6: input=$3.00, output=$15.00, cache_read=$0.30, cache_write=$3.75
     - claude-haiku-4-5: input=$0.80, output=$4.00, cache_read=$0.08, cache_write=$1.00

3. **Find today's sessions** for this vault:
   - The Claude Code project path is derived from the install directory. For a vault at `/Users/me/Documents/brain`, the project dir is `~/.claude/projects/-Users-me-Documents-brain/`.
   - Convert the install path to the Claude project path format: replace `/` with `-`, prepend `-`, look under `~/.claude/projects/`.
   - List all `.jsonl` session files in that directory.
   - For each session file, check `~/.claude/sessions/<session-id>.json` to get `startedAt` timestamp.
   - Filter to sessions started today (compare date portion of startedAt with today's date).

4. **Parse token usage** from each today's session JSONL file:
   - Each line with a `message.usage` block contains: `input_tokens`, `output_tokens`, `cache_creation_input_tokens`, `cache_read_input_tokens`.
   - Sum all token fields per session and across all sessions.
   - Track which models were used.
   - Use `jq` to extract and sum:
     ```bash
     cat "<session>.jsonl" | jq -s '[.[] | select(.message.usage != null) | .message.usage] | {
       input: (map(.input_tokens // 0) | add),
       output: (map(.output_tokens // 0) | add),
       cache_read: (map(.cache_read_input_tokens // 0) | add),
       cache_write: (map(.cache_creation_input_tokens // 0) | add)
     }'
     ```

5. **Calculate costs** using the pricing from step 2:
   - Cost = (input_tokens * input_rate + output_tokens * output_rate + cache_read * cache_read_rate + cache_write * cache_write_rate) / 1,000,000

6. **Present results** in a clear format:

   ```
   ## Claude Usage — Today (YYYY-MM-DD)

   | Metric | Value |
   |--------|-------|
   | Sessions | N |
   | Input Tokens | X,XXX |
   | Output Tokens | X,XXX |
   | Cache Read Tokens | X,XXX |
   | Cache Write Tokens | X,XXX |
   | Models Used | model-1, model-2 |
   | **Estimated Cost** | **$X.XX** |

   ### Per Session
   | # | Started | Messages | Input | Output | Cost |
   |---|---------|----------|-------|--------|------|
   | 1 | HH:MM   | NN       | X,XXX | X,XXX  | $X.XX |
   | 2 | HH:MM   | NN       | X,XXX | X,XXX  | $X.XX |
   ```

7. If no sessions found for today, tell the user: "No Claude Code sessions found for today yet. Start using Claude and run this again later."

8. **Tip**: Mention that `/closeday` will save these stats to `_analytics/sessions/YYYY-MM-DD.md` for historical tracking.
