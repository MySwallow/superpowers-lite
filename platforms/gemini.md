# Install on Gemini CLI

Status: 🔬 Compatible — not extensively tested. PRs welcome.

## How skills work in Gemini

Gemini CLI uses an extension manifest. The skills can be loaded via `activate_skill` — Gemini loads metadata at session start and activates full content on demand.

## Install (manual)

1. Find your Gemini skill / extension directory.
2. Copy the skills:

```bash
cp -R skills/* <gemini-skills-dir>/
```

3. Reference `skills/using-superpowers/references/gemini-tools.md` for tool-name mapping.

## Tool-name mapping

Gemini's `activate_skill` tool replaces Claude Code's `Skill` tool. Other tools (read/write/exec) have Gemini-specific equivalents listed in `skills/using-superpowers/references/gemini-tools.md`.

## GEMINI.md auto-load

If your Gemini setup auto-loads instructions from a `GEMINI.md` file at session start, add this line:

```
Skills available at: <path-to-skills>/
Use them when relevant per the using-superpowers skill.
```

## Verify

Start a Gemini session and trigger a skill condition (e.g., "let's brainstorm a feature"). Gemini should activate the relevant skill.
