---
name: skill-finder
argument-hint: "[task or skill name]"
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash
version: 1.1
last_updated: 2026-10-18
exportable: true
---

# Skill: Skill Finder

Use this skill to route to the correct vault skill inside:

- the canonical `x_System/Skills/` directory that contains this skill

Resolve that directory from the loaded path of this `SKILL.md`. Do not assume the
agent's current working directory is the Vault root. This keeps the same skill
portable across Claude, Codex, and orchestrators that run from an isolated work
directory.

This is a discovery and routing skill. Its job is to inspect the local vault skill library, identify the best matching skill, and then load only that skill's `SKILL.md`.

## Workflow

1. Resolve the canonical skill root from this skill's own loaded path, then search under it.
2. Use file names, folder names, and `SKILL.md` frontmatter to find likely matches.
3. Prefer exact name matches first.
4. If there is no exact match, choose the closest skill by task similarity.
5. After selecting a candidate, read only that skill's `SKILL.md`.
6. If multiple skills are relevant, return the smallest set that covers the task.

## Search Rules

- Use `rg --files '<resolved-skill-root>'` to list skills quickly. If `rg` is unavailable, use `find '<resolved-skill-root>' -name SKILL.md -type f`.
- Search for names first, then descriptions.
- Prefer top-level orchestrator skills when the task is broad.
- Prefer leaf sub-skills when the task is specific and clearly scoped.
- Do not bulk-load every skill file. Keep discovery cheap, then load only the winner.

## Selection Heuristics

| Request type | Preferred target |
|---|---|
| "find a skill" or "what skill should I use?" | Search broadly and return best matches |
| broad domain request | Choose the top-level orchestrator skill |
| specific output format | Choose the narrowest relevant sub-skill |
| unclear request | Return 2-3 likely candidates with short reasons |

## Output Format

When used, respond with:

1. The selected skill path
2. A one-line reason it matches
3. Any fallback skill if the match is ambiguous

## Fallback

If no clear match is found:

1. Return the closest top-level domain skill in `x_System/Skills/`
2. State that no exact match was found
3. Continue with the best available skill instead of stopping
