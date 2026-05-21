# Installing superpowers-lite

Pick the install URL for **your platform and your preferred language**, then paste it into your AI:

| Platform | 中文 (default) | English |
|---|---|---|
| Claude Code | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/claude-code.md> | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/claude-code.en.md> |
| opencode | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/opencode.md> | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/opencode.en.md> |
| Codex CLI | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/codex.md> | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/codex.en.md> |
| Gemini CLI | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/gemini-cli.md> | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/gemini-cli.en.md> |
| Cursor (2.4+) | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cursor.md> | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cursor.en.md> |
| Windsurf | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/windsurf.md> | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/windsurf.en.md> |
| Cline (3.49+) | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cline.md> | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cline.en.md> |

The URL itself determines the language — the AI will **not** ask. Each
per-platform installer is self-contained: it downloads the repo, installs
to that platform's correct global directory, verifies, and reports back.

> **Claude Code only:** the installer also registers a `SessionStart` hook
> that injects `using-superpowers` at the start of every new session
> (keeps skill trigger rate high). Requires `jq`; skipped gracefully if
> missing.

**Re-running an installer upgrades cleanly** — it removes the 7 known
skill folders before copying fresh, so stale files from older versions
don't pile up. Any other skills you've added by hand to the same directory
are preserved.

---

## Native one-liner alternatives

For platforms with built-in plugin systems, you can skip the AI installer
and use the native command directly.

### Gemini CLI

```bash
gemini extensions install https://github.com/MySwallow/superpowers-lite
```

---

## Manual install (no AI, no plugin manager)

If you'd rather install everything by hand:

### Claude Code

```bash
git clone https://github.com/MySwallow/superpowers-lite.git
cd superpowers-lite
./scripts/install-claude-code.sh           # Chinese (default)
./scripts/install-claude-code.sh --lang en # English
```

### Any other platform

1. Clone the repo: `git clone https://github.com/MySwallow/superpowers-lite.git`
2. Copy `skills/` (or `skills-en/`) into your platform's skill directory.
   Common locations:
   - opencode: `~/.config/opencode/skills/`
   - Codex: `~/.codex/skills/`
   - **Cursor (2.4+)**: `~/.cursor/skills/` (user-level, global)
   - **Windsurf**: `~/.codeium/windsurf/skills/`
   - **Cline (3.49+)**: `~/.cline/skills/` (also enable
     `Settings → Features → Enable Skills`)
3. Restart the IDE so it re-scans the skills directory.
4. Verify by asking the AI to brainstorm or debug something — it should
   announce the relevant skill.

> All three IDEs natively support the SKILL.md format (the same Anthropic
> standard Claude Code uses). They auto-discover skills based on the
> `description` frontmatter — no rules / config files needed.

---

## Troubleshooting

If install fails, file an issue with the platform, the command run, and
the error output: <https://github.com/MySwallow/superpowers-lite/issues>
