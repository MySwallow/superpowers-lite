# Visual Companion 指南

基于浏览器的视觉 brainstorming 伴侣，用来展示 mockup、图表和选项。

## 何时使用

按问题决定，而非按会话决定。测试：**用户是看到比读到更易理解吗？**

**用浏览器** 当内容本身是视觉的：

- **UI mockup** — wireframe、布局、导航结构、组件设计
- **架构图** — 系统组件、数据流、关系图
- **并排视觉对比** — 比较两种布局、两套配色、两种设计方向
- **设计打磨** — 当问题是关于观感、间距、视觉层级
- **空间关系** — 渲染为图的状态机、流程图、实体关系

**用终端** 当内容是文本或表格：

- **需求与范围问题** — "X 是什么意思？"、"哪些功能在范围内？"
- **概念性 A/B/C 选择** — 在文字描述的方案间挑选
- **权衡列表** — 利弊、对比表
- **技术决策** — API 设计、数据建模、架构方案选择
- **澄清问题** — 任何答案是文字而非视觉偏好的事

**关于** UI 话题的问题**不自动**就是视觉问题。"你想要什么样的 wizard？"是概念问题——用终端。"这些 wizard 布局中哪个感觉对？"是视觉问题——用浏览器。

## 工作原理

服务器监视一个目录中的 HTML 文件，把最新的那个提供给浏览器。你把 HTML 内容写到 `screen_dir`，用户在浏览器里看到并能点击选择。选择被记录到 `state_dir/events`，下一轮你来读取。

**内容片段 vs 完整文档：** 如果你的 HTML 文件以 `<!DOCTYPE` 或 `<html` 开头，服务器原样提供（只注入 helper 脚本）。否则，服务器自动把你的内容套进 frame 模板——加上头部、CSS 主题、选择指示器和所有交互基础设施。**默认写内容片段。** 只在需要完全控制页面时写完整文档。

## 启动会话

```bash
# 启动带持久化的服务器（mockup 保存到项目）
scripts/start-server.sh --project-dir /path/to/project

# 返回：{"type":"server-started","port":52341,"url":"http://localhost:52341",
#           "screen_dir":"/path/to/project/.superpowers/brainstorm/12345-1706000000/content",
#           "state_dir":"/path/to/project/.superpowers/brainstorm/12345-1706000000/state"}
```

从返回中保存 `screen_dir` 和 `state_dir`。告诉用户打开该 URL。

**查找连接信息：** 服务器把启动 JSON 写到 `$STATE_DIR/server-info`。如果你在后台启动服务器且没捕获 stdout，读这个文件来获取 URL 和端口。当使用 `--project-dir` 时，检查 `<project>/.superpowers/brainstorm/` 找会话目录。

**注：** 把项目根目录作为 `--project-dir` 传入，这样 mockup 会持久化在 `.superpowers/brainstorm/` 中，服务器重启也能保留。不传则文件落到 `/tmp` 并会被清理。提醒用户把 `.superpowers/` 加进 `.gitignore`（如果还没的话）。

**按平台启动服务器：**

**Claude Code（macOS / Linux）：**
```bash
# 默认模式可用——脚本自己把服务器丢到后台
scripts/start-server.sh --project-dir /path/to/project
```

**Claude Code（Windows）：**
```bash
# Windows 自动检测并使用前台模式，会阻塞工具调用。
# 在 Bash 工具调用上用 run_in_background: true，让服务器
# 在会话轮次间存活。
scripts/start-server.sh --project-dir /path/to/project
```
通过 Bash 工具调用时，设置 `run_in_background: true`。下一轮读 `$STATE_DIR/server-info` 获取 URL 和端口。

**Codex：**
```bash
# Codex 会回收后台进程。脚本自动检测 CODEX_CI 并切到前台模式。
# 正常运行即可——不需要额外参数。
scripts/start-server.sh --project-dir /path/to/project
```

**Gemini CLI：**
```bash
# 用 --foreground 并在 shell 工具调用上设 is_background: true
# 让进程在轮次间存活
scripts/start-server.sh --project-dir /path/to/project --foreground
```

**其他环境：** 服务器必须跨会话轮次保持后台运行。如果你的环境会回收脱离的进程，用 `--foreground` 并用你平台的后台执行机制启动命令。

如果浏览器无法到达该 URL（在远程/容器化环境常见），绑定一个非环回主机：

```bash
scripts/start-server.sh \
  --project-dir /path/to/project \
  --host 0.0.0.0 \
  --url-host localhost
```

用 `--url-host` 控制返回的 URL JSON 中打印什么主机名。

## 循环

1. **检查服务器存活**，然后**写 HTML** 到 `screen_dir` 中的一个新文件：
   - 每次写入前，检查 `$STATE_DIR/server-info` 是否存在。如果不存在（或 `$STATE_DIR/server-stopped` 存在），服务器已停——继续前用 `start-server.sh` 重启。服务器在 30 分钟无活动后自动退出。
   - 用语义化文件名：`platform.html`、`visual-style.html`、`layout.html`
   - **绝不复用文件名** —— 每个屏幕用新文件
   - 用 Write 工具——**绝不用 cat/heredoc**（会把噪音倒进终端）
   - 服务器自动提供最新文件

2. **告诉用户期待什么，结束你的轮次：**
   - 提醒他们 URL（每一步，不只是第一次）
   - 简短文字总结屏幕上有什么（如"展示了 3 个主页布局选项"）
   - 让他们在终端回复："看一下告诉我你的想法。想选哪个的话点击就行。"

3. **下一轮——用户在终端回复后：**
   - 如果存在 `$STATE_DIR/events`，读它——里面是用户在浏览器中的交互（点击、选择）以 JSON 行格式记录
   - 与用户的终端文本合并，得到完整画面
   - 终端消息是主要反馈；`state_dir/events` 提供结构化交互数据

4. **迭代或推进** —— 如果反馈改变当前屏幕，写新文件（如 `layout-v2.html`）。当前步骤验证通过后再进入下一个问题。

5. **回到终端时卸载** —— 当下一步不需要浏览器时（如澄清问题、权衡讨论），推送一个 waiting 屏幕来清掉过时内容：

   ```html
   <!-- 文件名: waiting.html（或 waiting-2.html 等） -->
   <div style="display:flex;align-items:center;justify-content:center;min-height:60vh">
     <p class="subtitle">Continuing in terminal...</p>
   </div>
   ```

   这能避免对话已推进时用户还盯着已解决的选择。下个视觉问题出现时，照常推送新内容文件。

6. 重复直到完成。

## 编写内容片段

只写要放进页面的内容。服务器会自动把它套进 frame 模板（头部、主题 CSS、选择指示器和所有交互基础设施）。

**最小示例：**

```html
<h2>哪种布局更好？</h2>
<p class="subtitle">考虑可读性和视觉层级</p>

<div class="options">
  <div class="option" data-choice="a" onclick="toggleSelect(this)">
    <div class="letter">A</div>
    <div class="content">
      <h3>单列</h3>
      <p>整洁、专注的阅读体验</p>
    </div>
  </div>
  <div class="option" data-choice="b" onclick="toggleSelect(this)">
    <div class="letter">B</div>
    <div class="content">
      <h3>双列</h3>
      <p>侧边栏导航 + 主内容</p>
    </div>
  </div>
</div>
```

就这样。不需要 `<html>`、CSS 或 `<script>` 标签。服务器都提供。

## 可用 CSS 类

frame 模板为你的内容提供这些 CSS 类：

### Options（A/B/C 选项）

```html
<div class="options">
  <div class="option" data-choice="a" onclick="toggleSelect(this)">
    <div class="letter">A</div>
    <div class="content">
      <h3>标题</h3>
      <p>描述</p>
    </div>
  </div>
</div>
```

**多选：** 在容器上加 `data-multiselect`，允许用户选多个选项。每次点击切换该项。指示条会显示数量。

```html
<div class="options" data-multiselect>
  <!-- 同样的 option 结构——用户可勾选/取消多个 -->
</div>
```

### Cards（视觉设计）

```html
<div class="cards">
  <div class="card" data-choice="design1" onclick="toggleSelect(this)">
    <div class="card-image"><!-- mockup 内容 --></div>
    <div class="card-body">
      <h3>名称</h3>
      <p>描述</p>
    </div>
  </div>
</div>
```

### Mockup 容器

```html
<div class="mockup">
  <div class="mockup-header">预览：仪表盘布局</div>
  <div class="mockup-body"><!-- 你的 mockup HTML --></div>
</div>
```

### Split view（并排）

```html
<div class="split">
  <div class="mockup"><!-- 左侧 --></div>
  <div class="mockup"><!-- 右侧 --></div>
</div>
```

### Pros/Cons

```html
<div class="pros-cons">
  <div class="pros"><h4>Pros</h4><ul><li>优点</li></ul></div>
  <div class="cons"><h4>Cons</h4><ul><li>缺点</li></ul></div>
</div>
```

### Mock 元素（wireframe 积木）

```html
<div class="mock-nav">Logo | Home | About | Contact</div>
<div style="display: flex;">
  <div class="mock-sidebar">Navigation</div>
  <div class="mock-content">Main content area</div>
</div>
<button class="mock-button">Action Button</button>
<input class="mock-input" placeholder="Input field">
<div class="placeholder">Placeholder area</div>
```

### 排版与章节

- `h2` — 页面标题
- `h3` — 章节标题
- `.subtitle` — 标题下方的副文本
- `.section` — 带下边距的内容块
- `.label` — 小号大写标签文本

## 浏览器事件格式

当用户在浏览器中点选项时，他们的交互被记录到 `$STATE_DIR/events`（每行一个 JSON 对象）。当你推新屏幕时该文件会自动清空。

```jsonl
{"type":"click","choice":"a","text":"Option A - Simple Layout","timestamp":1706000101}
{"type":"click","choice":"c","text":"Option C - Complex Grid","timestamp":1706000108}
{"type":"click","choice":"b","text":"Option B - Hybrid","timestamp":1706000115}
```

完整事件流展示了用户的探索路径——他们可能在最终决定前点选多个选项。最后一个 `choice` 事件通常是最终选择，但点击模式可揭示值得追问的犹豫或偏好。

如果 `$STATE_DIR/events` 不存在，用户没用浏览器交互——只用他们的终端文本。

## 设计提示

- **保真度匹配问题** — 布局问题用 wireframe，打磨问题用 polish
- **每页都说明问题** — "Which layout feels more professional?" 而不是 "Pick one"
- **推进前先迭代** — 如果反馈改变当前屏幕，写新版本
- **每屏最多 2-4 个选项**
- **该用真实内容就用** — 摄影作品集就用真图片（Unsplash）。占位内容会掩盖设计问题。
- **mockup 保持简单** — 关注布局和结构，不必像素级完美

## 文件命名

- 用语义化名字：`platform.html`、`visual-style.html`、`layout.html`
- 绝不复用文件名——每个屏幕必须是新文件
- 迭代时加版本后缀：`layout-v2.html`、`layout-v3.html`
- 服务器按修改时间提供最新文件

## 清理

```bash
scripts/stop-server.sh $SESSION_DIR
```

如果会话使用了 `--project-dir`，mockup 文件会持久化在 `.superpowers/brainstorm/` 供日后参考。只有 `/tmp` 会话会在停止时被删。

## 参考

- Frame 模板（CSS 参考）：`scripts/frame-template.html`
- Helper 脚本（客户端）：`scripts/helper.js`
