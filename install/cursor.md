# 在 Cursor 上安装 superpowers-lite

你是运行在 **Cursor**（2.4+）里的编码助手。用户让你安装
superpowers-lite —— 7 个编码方法论 skill。

Cursor 2.4（2026-01-23 发布）原生支持 Agent Skills，扫描 SKILL.md 文件。
我们用 Cursor 官方推荐的**用户级目录** `~/.cursor/skills/` 安装，
一次安装，所有项目自动可用。

**严格按下面步骤执行，任何一步失败就 STOP 并报告。**

> Cursor 版本要求：**2.4 或更高**。
> 老版本（≤ 2.3）不支持 Agent Skills，需要先升级 Cursor。
> 不确定版本？让用户在 Cursor 里看 `Help → About`。

---

## Step 1：语言已锁定

URL 已决定使用**中文** skill 集（`skills/`）。**不要**询问用户。

下面步骤中 `SKILL_SRC=skills`。

---

## Step 2：（可选）清理旧的错误安装

如果用户之前装过 superpowers-lite 的 v1（错误地用
`~/.superpowers-lite/skills/` + `.cursor/rules/superpowers-lite.{md,mdc}`），
先清理。这一步**只清当前项目**的 rules 文件——如果用户在其他项目也装过，
让他自己去那些项目里删 `.cursor/rules/superpowers-lite.*`。

```bash
# 清理旧的共享 skill 目录（如有）
rm -rf ~/.superpowers-lite

# 清理当前项目的旧 rule 文件（如有）
rm -f .cursor/rules/superpowers-lite.mdc .cursor/rules/superpowers-lite.md
```

不存在的路径会被 `rm` 静默跳过，无副作用。

---

## Step 3：下载仓库

```bash
curl -fsSL https://github.com/MySwallow/superpowers-lite/archive/refs/heads/main.tar.gz \
  | tar xz -C /tmp/
```

如果 `curl` / `tar` 不存在：

```bash
git clone --depth=1 https://github.com/MySwallow/superpowers-lite.git /tmp/superpowers-lite-main
```

验证 `/tmp/superpowers-lite-main/skills/` 下有 7 个目录。

---

## Step 4：安装到 Cursor 的用户级 skill 目录

Cursor 官方文档明确扫描 `~/.cursor/skills/`（用户级，全局可用）。
先清掉旧的 7 个 superpowers-lite skill 文件夹再复制，其他用户自己加在
`~/.cursor/skills/` 下的文件会被保留。

```bash
mkdir -p ~/.cursor/skills
for skill_dir in /tmp/superpowers-lite-main/$SKILL_SRC/*/; do
  rm -rf ~/.cursor/skills/$(basename "$skill_dir")
done
cp -R /tmp/superpowers-lite-main/$SKILL_SRC/* ~/.cursor/skills/
```

---

## Step 5：验证

```bash
ls ~/.cursor/skills/
```

必须看到 7 个目录：

```
brainstorming
dispatching-parallel-agents
executing-plans
subagent-driven-development
systematic-debugging
using-superpowers
writing-plans
```

每个目录里应有 `SKILL.md` 文件（frontmatter 含 `name` + `description`）。
如果少于 7 个或缺 `SKILL.md`，STOP 并报告。

---

## Step 6：告诉用户

1. 已安装：中文 skill 集（`skills/`），7 个 skill 全部到位
2. 安装位置：`~/.cursor/skills/`（Cursor 用户级目录，全局生效）
3. **请重启 Cursor**（或 `Cmd+Shift+P → Developer: Reload Window`），
   让 Cursor 重新扫描 skill 目录
4. 验证已加载：打开 `Cursor Settings`（Mac: `Cmd+Shift+J` / Win/Linux:
   `Ctrl+Shift+J`） → `Rules` → 在 "**Agent Decides**" 区域应能看到 7 个 skill
5. 也可在 chat 里输入 `/` 看到 skill 列表（`/using-superpowers` 等）
6. Skill 会被 Cursor Agent 根据 `description` 自动触发，也可显式
   `/skill-name` 调用

---

## Step 7：清理临时文件

```bash
rm -rf /tmp/superpowers-lite-main
```

任意步骤失败时跳过清理，方便排查。

---

## 故障排查

- **Cursor Settings → Rules 看不到 skill** → 检查 Cursor 版本是否 ≥ 2.4
  （`Help → About`），低于 2.4 完全不支持 skills
- **skill 装了但 Agent 不主动用** → 这是正常的，Cursor 是
  "Agent Decides"，根据 description 判断相关性；可以先在 chat 里用
  `/using-superpowers` 显式触发一次验证
- **如何升级** → 将来 skill 更新了，重新跑这个 installer URL 即可：
  Step 4 会先清掉 7 个旧 skill 文件夹再装新版，用户自己加在
  `~/.cursor/skills/` 下的其他 skill 不受影响
- **完全卸载** → 删除新版 + 旧版残留：
  ```bash
  # 新版（~/.cursor/skills/ 下的 7 个 superpowers-lite skill）
  rm -rf ~/.cursor/skills/{brainstorming,dispatching-parallel-agents,executing-plans,subagent-driven-development,systematic-debugging,using-superpowers,writing-plans}
  # 旧 v1 残留（如有）
  rm -rf ~/.superpowers-lite
  rm -f .cursor/rules/superpowers-lite.mdc .cursor/rules/superpowers-lite.md
  ```
