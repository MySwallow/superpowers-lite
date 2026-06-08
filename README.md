# superpowers-lite

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
| `subagent-driven-development` | ~40 | ~4.7k | 用全新子 agent 执行计划，每任务 spec 审核 + 收口一次最终 code review（用 opus） |
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
- `writing-plans`：默认任务模板改为"实现 → 静态检查 → stage 待审"；TDD 模板保留为可选附录，仅当任务明确要求时启用；删除模板里的默认 `git commit` 步骤
- `subagent-driven-development`：implementer 只 stage 不 commit；流程图节点、示例输出、`implementer-prompt.md` 全部对齐（"实现、stage 待评审、自审"，而非"实现、测试、提交"）；写测试改为任务明确要求时才执行
- `systematic-debugging`：修 bug 默认改为"建立可靠复现 → 修 → 验证（项目静态检查）"；自动化测试仅在任务要求时才写
- `executing-plans` 的 Step 3 改为静态检查+报告，不自动结束
- 精简 `using-superpowers`（保留 DOT 流程图，Red Flags 从 12 条精简到 7 条）；`codex-tools.md` 删除已失效的 worktree 探测段落

具体改动可看 git 历史。

---

## 安装

### 🌟 最简单：让你的 AI 自己装

挑你当前平台 + 语言对应的 URL，把它粘到 AI 终端里：

| 平台 | 中文（默认） | English |
|---|---|---|
| Claude Code | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/claude-code.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/claude-code.en.md` |
| opencode | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/opencode.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/opencode.en.md` |
| Codex CLI | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/codex.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/codex.en.md` |
| Gemini CLI | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/gemini-cli.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/gemini-cli.en.md` |
| Cursor (2.4+) | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cursor.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cursor.en.md` |
| Windsurf | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/windsurf.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/windsurf.en.md` |
| Cline (3.49+) | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cline.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cline.en.md` |
| GitHub Copilot CLI | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/github-copilot.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/github-copilot.en.md` |

URL 本身就决定语言——AI 不会再问。每份链接对应一份针对该平台的指令，AI 读完会下载 skill 并装到对应的全局目录（`~/.claude/skills/`、`~/.config/opencode/skills/`、`~/.cursor/skills/`、`~/.copilot/skills/` 等）。Claude Code 还会额外注册一个 SessionStart hook，让每个新会话自动加载 `using-superpowers`（需要 `jq`，缺失时优雅跳过）。Cursor / Windsurf / Cline / GitHub Copilot CLI 原生支持 SKILL.md（Cursor 2.4+、Cline 3.49+），无需额外配置。

完整说明见 [INSTALL.md](INSTALL.md)。

### Gemini CLI 原生一行装

如果你用 Gemini CLI，可以直接用扩展机制：

```bash
gemini extensions install https://github.com/MySwallow/superpowers-lite
```

### Claude Code 手动脚本（备选）

```bash
git clone https://github.com/MySwallow/superpowers-lite.git
cd superpowers-lite
./scripts/install-claude-code.sh           # 中文（默认）
./scripts/install-claude-code.sh --lang en # 英文
```

会把 7 个 skill 复制到 `~/.claude/skills/`（user scope）。

### 其他平台

参见 [INSTALL.md](INSTALL.md) 的"Manual fallback"段落，或让 AI 按上面第一种方式自动安装。

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
- 本 fork **superpowers-lite** —— 去掉强制仪式（TDD、自动 commit、worktree），扩展多平台支持

如果觉得有用，可以赞助上游作者：[github.com/sponsors/obra](https://github.com/sponsors/obra)
