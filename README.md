# agent-skills

精简版、多平台的 AI 编码 agent skill 集合。

基于 [`superpowers`](https://github.com/obra/superpowers-marketplace) 改造（MIT，© 2025 Jesse Vincent），主要差异：

- **不强制 TDD** —— TDD 改为可选，只在任务明确要求时启用
- **不自动 commit / push / PR** —— implementer 只 stage，用户决定何时 commit
- **不依赖 worktree** —— 直接在当前分支工作
- **更小的上下文占用** —— 7 个聚焦 skill，更精简的 prompt
- **多平台支持** —— Claude Code、Codex、Gemini、Copilot，以及任何能读 markdown 的 AI 助手

[English README](README.en.md)

---

## 包含的 Skill

| Skill | 常驻 token | 触发 token | 使用场景 |
|---|---:|---:|---|
| `using-superpowers` | ~70 | ~700 | 始终加载 —— 定义如何查找和使用 skill |
| `brainstorming` | ~70 | ~3.9k | 任何创造性工作前 —— 探索意图和需求 |
| `writing-plans` | ~30 | ~2.3k | 把规格拆成可执行的步骤 |
| `executing-plans` | ~40 | ~880 | 在当前会话执行已有计划 |
| `subagent-driven-development` | ~40 | ~4.7k | 用全新子 agent 执行计划，两阶段审核 |
| `dispatching-parallel-agents` | ~40 | ~2.4k | 2+ 个独立任务并行处理 |
| `systematic-debugging` | ~40 | ~3.7k | 任何 bug、测试失败、异常行为 |

（token 估算来自 `claude plugin details`，实际用量会有差异）

## 与上游 `superpowers` 的差异

我们移除了上游 7 个 skill：

| 移除的 skill | 原因 |
|---|---|
| `test-driven-development` | TDD 不再"硬性强制"，按需启用 |
| `finishing-a-development-branch` | 自动 git 操作与保守工作流冲突 |
| `verification-before-completion` | 改为简单的"跑静态检查"要求 |
| `requesting-code-review` | 模板内联到 `subagent-driven-development/code-reviewer.md` |
| `receiving-code-review` | 使用频率低，手动处理即可 |
| `using-git-worktrees` | 不是所有工作流都用 worktree |
| `writing-skills` | 元 skill，使用面窄，触发成本高 |

保留的 7 个 skill 也做了以下修改：

- 移除所有 `superpowers:` 命名空间引用（skill 现在是中性的）
- 把 "REQUIRED SUB-SKILL" 硬依赖改为温和的 "Related skills"
- `subagent-driven-development` 的 implementer 改为 **stage** 而非 commit
- `executing-plans` 的 Step 3 改为静态检查+报告，不自动结束
- 精简 `using-superpowers`（保留 DOT 流程图，Red Flags 从 12 条精简到 7 条）

具体改动可看 git 历史。

---

## 安装

各平台安装说明：

- [**Claude Code**](platforms/claude-code.md)
- [**Codex CLI**](platforms/codex.md)
- [**Gemini CLI**](platforms/gemini.md)
- [**GitHub Copilot CLI**](platforms/copilot.md)
- [**Cursor / 其他 AI 助手**](platforms/generic.md)

### Claude Code 一行安装

```bash
git clone https://github.com/MySwallow/agent-skills.git
cd agent-skills
./scripts/install-claude-code.sh
```

会把 7 个 skill 复制到 `~/.claude/skills/`（user scope）。

### 平台支持矩阵

| 平台 | 状态 | Skill 加载方式 |
|---|---|---|
| Claude Code | ✅ 已测试 | `Skill` 工具，`~/.claude/skills/` |
| Codex CLI | 🔬 兼容 | 参考 `references/codex-tools.md` |
| Gemini CLI | 🔬 兼容 | `activate_skill` |
| GitHub Copilot CLI | 🔬 兼容 | `skill` 工具 |
| Cursor / Windsurf / Cline | 📄 当 markdown 读 | 在 rules 里手动引用 |

"🔬 兼容" 表示 skill 内容平台中立、`skills/using-superpowers/references/` 里有工具名映射，但未在那些平台做过充分测试。欢迎提 Issue / PR。

---

## 自定义

所有 skill 都是纯 markdown，可以 fork 后随意编辑。每个 skill 是一个文件夹，里面有 `SKILL.md`（入口）加上可选的辅助文件。

主要扩展点：

- `skills/using-superpowers/SKILL.md` —— 全局 skill 调度规则
- `skills/<skill>/SKILL.md` —— 单个 skill 的 prompt
- `skills/subagent-driven-development/*-prompt.md` —— 子 agent 派遣模板

---

## License

MIT —— 详见 [LICENSE](LICENSE)。

本项目衍生自 Jesse Vincent (@obra) 的 `superpowers` 项目，LICENSE 中保留了原作者版权和本 fork 的修改声明。

## 致谢

- 上游 `superpowers` 插件作者 **Jesse Vincent** ([@obra](https://github.com/obra/superpowers-marketplace)) —— 提供了核心方法论和 skill 设计
- 本 fork **agent-skills** —— 去掉强制仪式（TDD、自动 commit、worktree），扩展多平台支持

如果觉得有用，可以赞助上游作者：[github.com/sponsors/obra](https://github.com/sponsors/obra)
