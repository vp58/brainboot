---
name: log
description: Append a detailed activity log entry for the current work session to today's assistant daily log, with changed files, decisions, evidence, open loops, and wiki-linked notes.
user-invocable: true
argument-hint: "[optional: summary override, focus area, or exact activity to log]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
deps: [skill-update]
version: 1.3
last_updated: 2026-09-12
exportable: true
---

# Log Skill

Captures what happened in the current session and appends a detailed activity log entry to today's assistant daily log at `x_System/Assistant/daily/YYYY-MM-DD.md`. Connects each entry to relevant vault notes so the daily log acts as a networked activity record, not an isolated text dump.

`/log` means: write a durable, detailed account of what was actually done today, including files changed, notes linked, decisions made, verification run, and remaining open loops.

## Codex Install

Codex does not reliably execute vault-only slash-command docs by itself. The Codex wrapper for this workflow lives at:

```
x_System/Skills/log/codex/
```

Install or refresh it into:

```
~/.codex/skills/log/
```

The wrapper's trigger description explicitly covers `/log`, `$log`, "log this", and "update activity log".

There is also a repo-local Codex plugin command source at:

```
plugins/log/commands/log.md
```

It is registered in:

```
.agents/plugins/marketplace.json
```

Depending on the Codex command UI, this may appear as a plugin command such as `/log:log`. The installed Codex skill at `~/.codex/skills/log/` handles `$log` and natural-language triggers.

---

## When to Run

- End of a session or work block
- When the owner says `/log`
- When the owner says "log this", "update activity log", "add to today's log", "write this in the daily log", or similar
- Before switching to a completely different task domain (optional, good hygiene)

---

## Procedure

### 1. Determine Today's Date

Use the current workspace date to resolve the target file: `x_System/Assistant/daily/YYYY-MM-DD.md`.

If multiple dates are present in the environment or conversation, prefer the system/developer current date over stale shell output. If still ambiguous, choose the date already being used by today's active assistant daily log and note the assumption in the entry only if it matters.

### 2. Read Existing Daily Log

Read the target daily log file. If it doesn't exist, create it with a top-level heading:

```
# Daily Log - YYYY-MM-DD
```

### 3. Build Session Entry

Review the full conversation context from this session and the relevant local diff. Construct a detailed log entry with this structure:

```
## HH:MM - [Short Title] [device]

**Context:** [One sentence: what the owner asked for or what triggered the work.]

### What Changed

- [Concrete bullet per artifact created, modified, moved, merged, or deleted]
- [Include vault-relative file paths for files changed]
- [Include external links or connector records where relevant]

### Decisions / Findings

- [Important decisions, audit findings, conflicts resolved, or data corrected]

### Verification

- [Commands/checks run and PASS/FAIL result]
- [Any checks not run and why]

### Linked Notes

- [[Note Name]] - [one-line relationship: created, updated, referenced, informed by, etc.]
- [[Another Note]] - [relationship]

### Open Loops

- [Anything still waiting on the owner, a third party, or a future check]

### Operational Outcome

- [One or two sentences: what's different now as a result of this session.]
```

For very small interactions, use the compact format in Rules, but still include at least one link when a vault artifact was involved.

### 4. Connect to Relevant Notes

This is the key differentiator. For every session entry, scan for and link:

- **Notes created** in this session (new files written to Inbox, Atlas, Efforts, etc.)
- **Notes modified** in this session (edits to existing vault files)
- **Notes referenced** during the session (files read for context, even if unchanged)
- **Attachments used** - link to `[[filename.ext]]` when the session depended on an attachment
- **People mentioned** - link to their profile in `Atlas/People/` if one exists
- **Companies mentioned** - link to their profile in `Atlas/Companies/` if one exists
- **Skills used** - link to the SKILL.md that governed the work
- **Tasks created or completed** - link to task files in `Efforts/Tasks/`
- **Efforts or projects touched** - link to the relevant effort folder's anchor note

Use `[[wiki-link]]` syntax for all vault notes. Use markdown links for external URLs.

To find linkable notes:
- Glob `Atlas/People/*.md` and `Atlas/Companies/*.md` for name matches
- Glob `Efforts/Tasks/Active/*.md` for task matches
- Check conversation context for any file paths that were read or written
- Check `git status --short` and `git diff --stat` when local file edits were made

### 5. Capture Detail Level

Default to enough detail that future the owner can reconstruct:

- what problem was solved
- what sources were checked
- which records are now canonical
- what files changed
- what got moved/deleted/merged
- what still needs action

Do not paste giant diffs or full documents. Summarize large edits and link to the changed notes.

### 6. Append to Daily Log

Append the new session entry to the end of the daily log file. Do not overwrite existing entries.

### 7. Timestamp and Device Tag

Add a timestamp prefix to the session heading. Use `HH:MM` format in your local time zone.

Always append a device tag in brackets at the end of the heading. Detect the device by running `scutil --get ComputerName` and map to a short alias:
- "Mac mini" -> `[mini]`
- "MacBook Pro" -> `[mbp]`
- "MacBook Air" -> `[mba]`
- iPhone -> `[iphone]`
- Unknown -> `[unknown]`

Example: `## HH:MM - Session (Short Title) [mini]`

Compact format: `## HH:MM - Quick Description [mini]`

If device detection is unavailable, use `[unknown]` rather than blocking the log entry.

### 8. Deduplicate

Before appending, scan today's daily log for an existing entry about the same session:

- If an entry already exists and is materially complete, do not append a duplicate. Confirm it is already logged.
- If an entry exists but is incomplete, append a short "Update" subsection under the existing entry when feasible.
- If appending under the existing entry is awkward, add a new heading titled `Update: [Short Title]` and explicitly reference the earlier entry.

### 9. Skill-Worthiness Check

After building the log entry, evaluate whether this session contains a repeatable workflow worth codifying as a new skill.

**Criteria (ALL must be true to draft):**
1. The session involved 5+ tool calls following a coherent multi-step pattern (not random lookups or Q&A)
2. The workflow produced a reusable artifact or transformation pipeline (not just research or conversation)
3. The session was NOT primarily executing an existing skill (if a SKILL.md was loaded and followed, no draft needed)
4. No existing skill in `x_System/Skills/_index.md` already covers this workflow (check before drafting)
5. The workflow is generalizable: it would work for similar future inputs, not just this one-off case

**If skill-worthy:**

1. Create a draft at `x_System/Skills/_drafts/YYYY-MM-DD-{slug}.md` using this format:

```yaml
---
name: {slug}
description: One-line description of what this skill does.
status: draft
origin_session: YYYY-MM-DD
origin_log_entry: "## HH:MM - [Session Title]"
target_path: {proposed/skill/path}
user-invocable: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
version: 0.1
last_updated: YYYY-MM-DD
---
```

Then write the skill body following `x_System/Skills/_template.md` conventions:
- Extract the workflow steps from what was actually done in the session
- Generalize specific values into parameters or descriptions
- Add a `## Origin` section documenting which session spawned this draft and why it seemed worth codifying
- Add a `## Review Notes` section with questions for the owner: unclear scope, edge cases, naming suggestions, whether this overlaps with anything existing

2. Post to your skill-drafts chat channel (your channel id) via the Discord API skill:

```
**Skill Draft Created**
`_drafts/YYYY-MM-DD-{slug}.md`

[1-2 sentence summary of what the skill would do]

Review: `/skill-drafts`
```

Include `<@your-user-id>` mention.

3. Note the draft creation in the log entry's "Open Loops" section.

**If NOT skill-worthy:** Do not create a new-skill draft or mention that check. Independently consider the correction branch below.

---

### 10. Existing-Skill Correction Intake

This is a separate branch from new-skill nomination. It can apply when the session executed an existing skill; it does not relax any of the five new-skill criteria above.

1. Identify a concrete correction, failed behavior or review finding and its existing owning `SKILL.md`. Verify the source and attribution. Distinguish an explicit user correction from an agent hypothesis, an inferred signal or a one-off preference. Preserve exceptions and uncertainty; do not invent a general instruction from one ambiguous comment.
2. Read the [correction contract](../skill-update/reference/correction-contract.md). Prepare sanitized local input with a stable source reference and canonical owner path. Keep transcripts, real customer messages and private evidence at their original locations, not in the packet, fixtures or model inputs.
3. Capture through the shared helper, from the vault root:

   ```bash
   python3 x_System/Skills/skill-update/scripts/validate_correction.py capture INPUT_JSON
   ```

   Optional `--root ROOT` selects an isolated fixture vault. Capture creates one Markdown packet containing a `correction-json` block in the existing `_drafts` queue. It returns an existing pending or archived record for the same source/owner identity and surfaces conflicting content without overwriting it. It does not approve, test or apply the proposed change.
4. Link the returned packet from this daily log entry and summarize its independent decision, validation, application and resolution facts. If capture is invalid or unavailable, record that blocker; do not claim a packet was created or substitute a second queue. Existing legacy draft statuses remain unchanged and require review.
5. Route review to `skill-drafts` and implementation to `skill-update`. An already explicit current-task approval of the exact change remains authorization; logging or capturing a correction does not add another approval round. Do not apply a skill patch merely because a correction was logged. This intake branch does not itself send a notification or install a hook.

Automatic Stop-hook nomination is unverified on the inspected host. This manual `/log` procedure documents supported intake; it does not certify an installed automatic collector.

---

## Rules

- Every non-trivial entry MUST have `Context`, `What Changed`, `Linked Notes`, and `Operational Outcome`.
- Every entry MUST have at least one wiki link in the Linked Notes section. If genuinely nothing in the vault connects, note that explicitly.
- File paths in "What Changed" are vault-relative (e.g., `Efforts/Work/Decks/...`), not absolute system paths.
- Keep entries factual and specific. No filler, no aspirational language.
- Record destructive or cleanup actions explicitly, including deleted or moved notes.
- Record important corrections, especially where stale data was replaced by newer canonical information.
- If the work touched medical, legal, financial, or third-party communication records, include the evidence source and remaining uncertainty.
- If a session was trivial (quick question, no artifacts), use a compact single-line format instead:

```
## HH:MM - [Quick Description]
- [What happened in one line.] [[Relevant Note]]
```

- Do not duplicate content that already exists in the daily log from an earlier run in the same session.
- If MEMORY.md needs updating based on this session, flag it but don't auto-update. That's a separate decision.

---

## Output

After appending, confirm to the owner with:
- The session title logged
- Count of linked notes
- Daily log file updated
- Any flag if MEMORY.md may need an update

[[Work]]
