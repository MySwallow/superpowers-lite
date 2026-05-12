# Install on GitHub Copilot CLI

Status: 🔬 Compatible — not extensively tested. PRs welcome.

## How skills work in Copilot CLI

GitHub Copilot CLI uses a `skill` tool similar to Claude Code's `Skill` tool. Skills are auto-discovered from installed plugins.

## Install

The Copilot ecosystem prefers plugin-based distribution. Two options:

### Option 1: Manual copy

If Copilot CLI supports user-scope skills:

```bash
cp -R skills/* <copilot-skills-dir>/
```

### Option 2: As a plugin

Wrap this repo as a Copilot plugin (PRs welcome — we'd appreciate a plugin manifest example).

## Tool-name mapping

Copilot uses similar tool names to Claude Code. See `skills/using-superpowers/references/copilot-tools.md` for the exact mapping.

## Verify

Start a Copilot CLI session and trigger a skill condition. The `skill` tool should activate the relevant skill.
