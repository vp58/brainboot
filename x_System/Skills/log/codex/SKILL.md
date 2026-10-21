---
name: log
description: Use when the owner types /log, $log, "log this", "update activity log", or asks to add a detailed record of the current session to today's assistant daily log in the vault.
metadata:
  short-description: Add a detailed entry to today's assistant daily log
---

# Codex Log Skill

This is the Codex-installed wrapper for the owner's vault `/log` workflow.

When the owner types `/log` or `$log`, do not treat it as a no-op slash command. Execute the logging workflow immediately.

## Canonical Workflow

Read and follow:

```
x_System/Skills/log/SKILL.md
```

## Target Log

Append to today's vault daily log:

```
x_System/Assistant/daily/YYYY-MM-DD.md
```

If the file does not exist, create it with:

```markdown
# Daily Log - YYYY-MM-DD
```

## Required Behavior

1. Determine today's date from the active system/developer context, not stale shell output.
2. Read the canonical vault log skill.
3. Inspect relevant session context and local file changes.
4. Append a detailed activity entry with:
   - context
   - files changed
   - decisions / findings
   - verification
   - linked notes
   - open loops
   - operational outcome
5. Do not append a duplicate if the same work is already logged.
6. Confirm the title logged and the daily log path updated.

## Notes

- Prefer wiki links for vault notes.
- Include vault-relative paths for file changes.
- Record moved, merged, and deleted notes explicitly.
- If `/log` is the entire user message, run the workflow without asking a clarifying question.

[[Work]]
