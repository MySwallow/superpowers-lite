# Copilot CLI 工具映射

Skills 使用 Claude Code 的工具名。在 skill 中遇到这些时，请使用你平台的等价物：

| Skill 引用 | Copilot CLI 等价物 |
|-----------------|----------------------|
| `Read`（读取文件） | `view` |
| `Write`（创建文件） | `create` |
| `Edit`（编辑文件） | `edit` |
| `Bash`（运行命令） | `bash` |
| `Grep`（按内容搜索文件） | `grep` |
| `Glob`（按文件名搜索） | `glob` |
| `Skill` 工具（调用一个 skill） | `skill` |
| `WebFetch` | `web_fetch` |
| `Task` 工具（调度子代理） | `task`，带 `agent_type: "general-purpose"` 或 `"explore"` |
| 多次 `Task` 调用（并行） | 多次 `task` 调用 |
| Task 状态/输出 | `read_agent`、`list_agents` |
| `TodoWrite`（任务追踪） | `sql` 操作内置的 `todos` 表 |
| `WebSearch` | 无等价物——用 `web_fetch` 加搜索引擎 URL |
| `EnterPlanMode` / `ExitPlanMode` | 无等价物——保持在主会话 |

## 异步 shell 会话

Copilot CLI 支持持久化的异步 shell 会话，这在 Claude Code 中没有直接等价物：

| 工具 | 用途 |
|------|---------|
| `bash` 带 `async: true` | 在后台启动一个长运行命令 |
| `write_bash` | 向运行中的异步会话发送输入 |
| `read_bash` | 从异步会话读取输出 |
| `stop_bash` | 终止一个异步会话 |
| `list_bash` | 列出所有活跃的 shell 会话 |

## Copilot CLI 额外工具

| 工具 | 用途 |
|------|---------|
| `store_memory` | 持久化关于代码库的事实供未来会话使用 |
| `report_intent` | 用当前意图更新 UI 状态行 |
| `sql` | 查询会话的 SQLite 数据库（todos、元数据） |
| `fetch_copilot_cli_documentation` | 查阅 Copilot CLI 文档 |
| GitHub MCP 工具（`github-mcp-server-*`） | 原生 GitHub API 访问（issues、PRs、代码搜索） |
