# Codex 工具映射

Skills 使用 Claude Code 的工具名。在 skill 中遇到这些时，请使用你平台的等价物：

| Skill 引用 | Codex 等价物 |
|-----------------|------------------|
| `Task` 工具（调度子代理） | `spawn_agent`（见[子代理调度需要多代理支持](#subagent-dispatch-requires-multi-agent-support)） |
| 多次 `Task` 调用（并行） | 多次 `spawn_agent` 调用 |
| Task 返回结果 | `wait_agent` |
| Task 自动完成 | `close_agent` 以释放 slot |
| `TodoWrite`（任务追踪） | `update_plan` |
| `Skill` 工具（调用一个 skill） | Skills 原生加载——直接遵循指令即可 |
| `Read`、`Write`、`Edit`（文件） | 使用你的原生文件工具 |
| `Bash`（运行命令） | 使用你的原生 shell 工具 |

## 子代理调度需要多代理支持

在 Codex 配置（`~/.codex/config.toml`）中添加：

```toml
[features]
multi_agent = true
```

这会启用 `spawn_agent`、`wait_agent` 和 `close_agent`，供 `dispatching-parallel-agents` 和 `subagent-driven-development` 等 skill 使用。

历史注：`rust-v0.115.0` 之前的 Codex 构建将"等待已派生代理"暴露为 `wait`。当前的 Codex 使用 `wait_agent` 等待已派生代理。`wait` 这个名字现在归属 code-mode 的 `exec/wait`——按 `cell_id` 恢复一个已 yield 的 exec cell；它不是已派生代理的结果工具。

## 环境检测

创建 worktree 或收尾分支的 skill 应该在继续之前
用只读 git 命令检测自己所处的环境：

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
BRANCH=$(git branch --show-current)
```

- `GIT_DIR != GIT_COMMON` → 已经在一个 linked worktree 里（跳过创建）
- `BRANCH` 为空 → detached HEAD（无法从沙箱中分支/推送/开 PR）

参见 `using-git-worktrees` 步骤 0 和 `finishing-a-development-branch`
步骤 1，了解每个 skill 如何使用这些信号。

## Codex App 收尾

当沙箱阻止分支/推送操作（外部管理的 worktree 中的 detached HEAD）时，
代理会提交所有工作，并告知用户使用 App 的原生控件：

- **"Create branch"** — 命名分支，然后通过 App UI 提交/推送/开 PR
- **"Hand off to local"** — 将工作交接到用户的本地 checkout

代理仍可运行测试、暂存文件，并输出建议的分支名、提交消息和
PR 描述供用户复制。
