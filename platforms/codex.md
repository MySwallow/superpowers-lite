# Install on Codex CLI

Status: 🔬 Compatible — not extensively tested. PRs welcome.

## How skills work in Codex

Codex CLI loads instructions from a configured directory. The skill content (SKILL.md) is read as guidance — when a relevant condition appears, the model follows the SKILL.md content.

## Install

1. Locate your Codex skill/instructions directory (varies by setup).
2. Copy the skills:

```bash
cp -R skills/* <codex-skills-dir>/
```

3. Reference `skills/using-superpowers/references/codex-tools.md` for the tool-name mapping (Claude Code → Codex equivalents).

## Tool-name mapping

The skills reference Claude Code tool names (`Bash`, `Read`, `Edit`, `Write`, `Task`, `TodoWrite`). On Codex, the equivalents are documented in `skills/using-superpowers/references/codex-tools.md`.

## Verify

Start a Codex session and ask it to "debug this" or "plan this" — it should announce the relevant skill and follow the methodology.
