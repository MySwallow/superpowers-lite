# agent-skills

A trimmed, multi-platform pack of coding-agent skills for AI assistants.

Forked and streamlined from [`superpowers`](https://github.com/obra/superpowers-marketplace) (MIT, © 2025 Jesse Vincent), with deliberate changes to suit a more conservative workflow:

- **No forced TDD** — TDD is optional, only when the task explicitly says so
- **No auto-commit / push / PR** — implementers stage changes; you commit when ready
- **No worktree dependency** — works directly in your current branch
- **Smaller context footprint** — 7 focused skills, leaner prompts
- **Multi-platform** — Claude Code, Codex, Gemini, Copilot, and any AI assistant that reads markdown

[简体中文版 README](README.zh-CN.md)

---

## Skills included

| Skill | Always-on | On-invoke | When to use |
|---|---:|---:|---|
| `using-superpowers` | ~70 tok | ~700 tok | Always loaded — establishes how to find and use skills |
| `brainstorming` | ~70 | ~3.9k | Before any creative work — explore intent & requirements |
| `writing-plans` | ~30 | ~2.3k | Translate spec into bite-sized implementation tasks |
| `executing-plans` | ~40 | ~880 | Execute a written plan in the current session |
| `subagent-driven-development` | ~40 | ~4.7k | Execute plan via fresh subagents with two-stage review |
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
- Change `subagent-driven-development`'s implementer to **stage** changes instead of commit
- Change `executing-plans`'s Step 3 to run static checks + report, instead of auto-finishing
- Streamline `using-superpowers` (kept DOT flow graph, condensed Red Flags from 12 to 7)

See git history for line-by-line diffs.

---

## Install

Install instructions per platform:

- [**Claude Code**](platforms/claude-code.md)
- [**Codex CLI**](platforms/codex.md)
- [**Gemini CLI**](platforms/gemini.md)
- [**GitHub Copilot CLI**](platforms/copilot.md)
- [**Cursor / other AI assistants**](platforms/generic.md)

### Quick install for Claude Code

```bash
git clone https://github.com/MySwallow/agent-skills.git
cd agent-skills
./scripts/install-claude-code.sh
```

This copies the 7 skills into `~/.claude/skills/` (user scope).

### Platform support matrix

| Platform | Status | Skill loader |
|---|---|---|
| Claude Code | ✅ Tested | `Skill` tool, `~/.claude/skills/` |
| Codex CLI | 🔬 Compatible | See `references/codex-tools.md` |
| Gemini CLI | 🔬 Compatible | `activate_skill` |
| GitHub Copilot CLI | 🔬 Compatible | `skill` tool |
| Cursor / Windsurf / Cline | 📄 Read as markdown | Manual reference in rules |

"🔬 Compatible" means the skill content is platform-neutral and tool mappings exist in `skills/using-superpowers/references/`, but not extensively tested on those platforms. Issues and PRs welcome.

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
- This fork **agent-skills** — trims forced rituals (TDD, auto-commit, worktrees) and broadens platform support

If you find this useful, consider sponsoring the upstream author: [github.com/sponsors/obra](https://github.com/sponsors/obra).
