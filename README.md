# Brain Boot

An install kit for an AI-run second brain: an Obsidian vault that Claude Code or Codex operates for you. It gives your agent a folder map, operating rules, a memory layout, and a starter set of skills, so it can capture, organize, plan and review your work from day one.

This is the public, generic edition of the system its author runs every day. Nothing personal is included: no notes, no contacts, no credentials.

## What is inside

| Path | What it is |
|---|---|
| `CLAUDE.md` | The operating rules your agent loads on every session. Edit it to make it yours. |
| `AGENTS.md` | Pointer for Codex and other agents that read `AGENTS.md`. |
| `x_System/Assistant/` | `SOUL.md` (voice), `USER.md` (about you), `MEMORY.md` (decisions in force). Blank templates. |
| `x_System/Skills/` | Starter skills: activity logging, a skill finder, a decision council and a skill-draft review queue. |
| `x_System/Templates/` | Note templates. |
| `x_System/Scripts/get-secret.sh` | One convention for reading credentials from the macOS Keychain. |
| `Atlas/`, `Efforts/`, `Calendar/`, `Inbox/` | The empty folder skeleton (ACE: Atlas, Calendar, Efforts). |

## Install (about five minutes)

1. Install [Obsidian](https://obsidian.md) and [Claude Code](https://docs.claude.com/en/docs/claude-code) or Codex.
2. Clone this repo where you want your vault:
   ```bash
   git clone https://github.com/vp58/brainboot.git my-brain
   cd my-brain
   ```
3. Open the folder as a vault in Obsidian.
4. Start your agent in the folder (`claude` or `codex`) and say: "Read CLAUDE.md, then interview me to fill in USER.md and SOUL.md."
5. Optional: enable the secret scan hook before you ever push your own copy anywhere:
   ```bash
   git config core.hooksPath .githooks
   ```

Keep your own vault in a **private** repository. This kit is public; your brain is not.

## Credentials

Skills never store secrets in files. They call `x_System/Scripts/get-secret.sh <name>`, which reads from the macOS Keychain under one service name (default `brain-secret`, override with `BRAIN_SECRET_SERVICE`). Add a secret with:

```bash
security add-generic-password -s brain-secret -a <name> -w
```

## Author

Created by Vinay Patankar. Released under the MIT License (see `LICENSE`).
