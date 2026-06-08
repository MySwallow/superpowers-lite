# Gemini CLI 工具映射

Skills 使用 Claude Code 的工具名。在 skill 中遇到这些时，请使用你平台的等价物：

| Skill 引用 | Gemini CLI 等价物 |
|-----------------|----------------------|
| `Read`（读取文件） | `read_file` |
| `Write`（创建文件） | `write_file` |
| `Edit`（编辑文件） | `replace` |
| `Bash`（运行命令） | `run_shell_command` |
| `Grep`（按内容搜索文件） | `grep_search` |
| `Glob`（按文件名搜索） | `glob` |
| `TodoWrite`（任务追踪） | `write_todos` |
| `Skill` 工具（调用一个 skill） | `activate_skill` |
| `WebSearch` | `google_web_search` |
| `WebFetch` | `web_fetch` |
| `Task` 工具（调度子代理） | `@agent-name`（见[子代理支持](#subagent-support)） |

## 子代理支持

Gemini CLI 通过 `@` 语法原生支持子代理。使用内置的 `@generalist` 代理来调度任何任务——它能访问所有工具，并遵循你提供的 prompt。

当 skill 说要调度一个有名字的代理类型时，使用 `@generalist` 并传入 skill 的 prompt 模板的完整填充内容：

| Skill 指令 | Gemini CLI 等价物 |
|-------------------|----------------------|
| 调度 implementer 子代理 | `@generalist` 加上填好的 `implementer-prompt.md` 模板 |
| 调度 spec-reviewer 子代理 | `@generalist` 加上填好的 `spec-reviewer-prompt.md` 模板 |
| 调度 code-reviewer 子代理（含收口的最终 code review） | `@code-reviewer`（捆绑的代理）或 `@generalist` 加上填好的 `code-reviewer.md` 模板 |
| `Task tool (general-purpose)` 加内联 prompt | `@generalist` 加上你的内联 prompt |

### Prompt 填充

Skills 提供带占位符的 prompt 模板，如 `{WHAT_WAS_IMPLEMENTED}` 或 `[FULL TEXT of task]`。填好所有占位符，把完整 prompt 作为消息传给 `@generalist`。prompt 模板本身就包含代理的角色、评审标准和预期输出格式——`@generalist` 会遵循它。

### 并行调度

Gemini CLI 支持子代理并行调度。当 skill 要求你并行调度多个独立的子代理任务时，把所有这些 `@generalist` 或具名子代理任务放在同一个 prompt 中一起请求。让有依赖的任务保持顺序，但不要为了简化历史而把独立的子代理任务串行化。

## Gemini CLI 额外工具

Gemini CLI 中有这些工具，但在 Claude Code 中没有等价物：

| 工具 | 用途 |
|------|---------|
| `list_directory` | 列出文件和子目录 |
| `save_memory` | 持久化事实到 GEMINI.md，跨会话保留 |
| `ask_user` | 向用户请求结构化输入 |
| `tracker_create_task` | 富任务管理（创建、更新、列出、可视化） |
| `enter_plan_mode` / `exit_plan_mode` | 切换到只读研究模式，再做变更 |
