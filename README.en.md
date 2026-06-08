# superpowers-lite

A trimmed, multi-platform pack of coding-agent skills for AI assistants.

Forked and streamlined from [`superpowers`](https://github.com/obra/superpowers-marketplace) (MIT, © 2025 Jesse Vincent), with deliberate changes to suit a more conservative workflow:

- **No forced TDD** — TDD is optional, only when the task explicitly says so
- **No auto-commit / push / PR** — implementers stage changes; you commit when ready
- **No worktree dependency** — works directly in your current branch
- **Smaller context footprint** — 7 focused skills, leaner prompts
- **Multi-platform** — Claude Code, Codex, Gemini, Copilot, and any AI assistant that reads markdown

[简体中文版 README](README.md) (default)

---

## Skills included

| Skill | Always-on | On-invoke | When to use |
|---|---:|---:|---|
| `using-superpowers` | ~70 tok | ~700 tok | Always loaded — establishes how to find and use skills |
| `brainstorming` | ~70 | ~3.9k | Before any creative work — explore intent & requirements |
| `writing-plans` | ~30 | ~2.3k | Translate spec into bite-sized implementation tasks |
| `executing-plans` | ~40 | ~880 | Execute a written plan in the current session |
| `subagent-driven-development` | ~40 | ~4.7k | Execute plan via fresh subagents; per-task spec review + a single final code review (with opus) |
| `dispatching-parallel-agents` | ~40 | ~2.4k | 2+ independent tasks that can run concurrently |
| `systematic-debugging` | ~40 | ~3.7k | Any bug, test failure, or unexpected behavior |

(Token estimates from `claude plugin details`; actual usage varies.)

## What's different from upstream `superpowers`

We removed 7 skills from the upstream `superpowers` package:

| Removed skill | Reason |
|---|---|
| `test-driven-development` | TDD is no longer enforced as a "rigid" skill; opt in per task |
| `finishing-a-development-branch` | Auto git ops conflict with conservative workflows |
| `verification-before-completion` | Replaced with simple static-check requirement |
| `requesting-code-review` | Template inlined into `subagent-driven-development/code-reviewer.md` |
| `receiving-code-review` | Rare use; users can do it manually |
| `using-git-worktrees` | Not all workflows use worktrees |
| `writing-skills` | Meta-skill, niche use, very expensive on invoke |

We also modified the remaining 7 skills to:

- Remove all `superpowers:` namespace references (skills are now neutral)
- Replace "REQUIRED SUB-SKILL" hard dependencies with softer "Related skills" notes
- `writing-plans`: default task template is "implement → static checks → stage for review"; the TDD template is preserved as an optional appendix, used only when the task explicitly requires it; removed the default `git commit` step from the template
- `subagent-driven-development`: implementer only stages (no commit); the flowchart node, example output, and `implementer-prompt.md` are now all aligned ("implements, stages for review, self-reviews" instead of "implements, tests, commits"); writing tests happens only when the task explicitly requires it
- `systematic-debugging`: default bug-fix flow is "establish reliable reproduction → fix → verify (project's static checks)"; automated tests are written only when the task requires them
- Change `executing-plans`'s Step 3 to run static checks + report, instead of auto-finishing
- Streamline `using-superpowers` (kept DOT flow graph, condensed Red Flags from 12 to 7); removed the obsolete worktree-detection section from `codex-tools.md`

See git history for line-by-line diffs.

---

## Install

### 🌟 Easiest: let your AI install it

Pick the URL for **your platform + preferred language**, then paste it into your AI:

| Platform | 中文 (default) | English |
|---|---|---|
| Claude Code | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/claude-code.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/claude-code.en.md` |
| opencode | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/opencode.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/opencode.en.md` |
| Codex CLI | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/codex.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/codex.en.md` |
| Gemini CLI | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/gemini-cli.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/gemini-cli.en.md` |
| Cursor (2.4+) | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cursor.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cursor.en.md` |
| Windsurf | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/windsurf.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/windsurf.en.md` |
| Cline (3.49+) | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cline.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cline.en.md` |
| GitHub Copilot CLI | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/github-copilot.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/github-copilot.en.md` |

The URL itself determines the language — the AI will **not** ask. Each URL
contains platform-specific instructions. The AI downloads the skills,
installs them to the correct global directory (`~/.claude/skills/`,
`~/.config/opencode/skills/`, `~/.copilot/skills/`, etc.), and reports
back. Claude Code installs also register a `SessionStart` hook that
auto-injects `using-superpowers` on every new session (requires `jq`;
skipped gracefully if missing). Cursor / Windsurf / Cline / GitHub
Copilot CLI natively support the SKILL.md format and auto-discover the
installed skills (Cursor 2.4+, Cline 3.49+).

Full overview: [INSTALL.md](INSTALL.md).

### Gemini CLI native one-liner

If you're on Gemini CLI:

```bash
gemini extensions install https://github.com/MySwallow/superpowers-lite
```

### Claude Code manual script (alternative)

```bash
git clone https://github.com/MySwallow/superpowers-lite.git
cd superpowers-lite
./scripts/install-claude-code.sh              # Chinese (default)
./scripts/install-claude-code.sh --lang en    # English
```

This copies the 7 skills into `~/.claude/skills/` (user scope).

### Other platforms

See the "Manual fallback" section in [INSTALL.md](INSTALL.md), or let the AI
install for you using the first option above.

---

## Customize

The skills are plain markdown — fork and edit to taste. Each skill is one folder with a `SKILL.md` (the entry point) plus optional helper files.

Key extension points:

- `skills/using-superpowers/SKILL.md` — global skill orchestration rules
- `skills/<skill>/SKILL.md` — individual skill prompts
- `skills/subagent-driven-development/*-prompt.md` — subagent dispatch templates

---

## License

MIT — see [LICENSE](LICENSE).

This is a derivative work of `superpowers` by Jesse Vincent (@obra). The original copyright is preserved in the LICENSE file alongside this fork's modifications.

## Credits

- Original `superpowers` plugin by **Jesse Vincent** ([@obra](https://github.com/obra/superpowers-marketplace)) — the foundational methodology and skill design
- This fork **superpowers-lite** — trims forced rituals (TDD, auto-commit, worktrees) and broadens platform support

If you find this useful, consider sponsoring the upstream author: [github.com/sponsors/obra](https://github.com/sponsors/obra).
