# 在 Windsurf 上安装 superpowers-lite

你是运行在 **Windsurf** 里的编码助手。用户让你安装 superpowers-lite ——
7 个编码方法论 skill。

Windsurf 原生支持 SKILL.md（Cascade 模式）。我们用 Windsurf 官方推荐的
**用户级**目录 `~/.codeium/windsurf/skills/` 安装，一次安装，所有项目
自动可用。

**严格按下面步骤执行，任何一步失败就 STOP 并报告。**

---

## Step 1：语言已锁定

URL 已决定使用**中文** skill 集（`skills/`）。**不要**询问用户。

下面步骤中 `SKILL_SRC=skills`。

---

## Step 2：（可选）清理旧的错误安装

如果用户之前装过 superpowers-lite 的旧 Cursor/Windsurf 版本（v1，
错误地用 `~/.superpowers-lite/skills/` + rules 文件），先清理：

```bash
# 清理旧的共享 skill 目录
rm -rf ~/.superpowers-lite

# 清理当前项目里旧的 rules 文件（如果有）
rm -f .windsurf/rules/superpowers-lite.mdc .windsurf/rules/superpowers-lite.md
```

不存在的路径会被 `rm -f` / `-rf` 安静跳过，无副作用。

---

## Step 3：下载仓库

```bash
curl -fsSL https://github.com/MySwallow/superpowers-lite/archive/refs/heads/main.tar.gz \
  | tar xz -C /tmp/
```

或：

```bash
git clone --depth=1 https://github.com/MySwallow/superpowers-lite.git /tmp/superpowers-lite-main
```

验证 `/tmp/superpowers-lite-main/skills/` 下有 7 个目录。

---

## Step 4：安装到 Windsurf 的用户级 skill 目录

Windsurf 官方文档明确扫描 `~/.codeium/windsurf/skills/`：

```bash
mkdir -p ~/.codeium/windsurf/skills
for skill_dir in /tmp/superpowers-lite-main/$SKILL_SRC/*/; do
  rm -rf ~/.codeium/windsurf/skills/$(basename "$skill_dir")
done
cp -R /tmp/superpowers-lite-main/$SKILL_SRC/* ~/.codeium/windsurf/skills/
```

---

## Step 5：验证

```bash
ls ~/.codeium/windsurf/skills/
```

必须看到 7 个目录（`brainstorming`、`dispatching-parallel-agents`、
`executing-plans`、`subagent-driven-development`、`systematic-debugging`、
`using-superpowers`、`writing-plans`），每个里有 `SKILL.md`。

---

## Step 6：告诉用户

1. 已安装：中文 skill 集（`skills/`），7 个 skill 全部到位
2. 安装位置：`~/.codeium/windsurf/skills/`（Windsurf 用户级，全局生效）
3. **请重启 Windsurf** 或 reload 窗口
4. Cascade 会根据 SKILL.md 的 `description` 自动判断何时使用，也可在
   chat 输入框用 `@skill-name` 显式调用
5. **如何升级**：将来 skill 更新了，重新跑这个 installer URL 即可——
   Step 4 会先清掉旧版再装新版

---

## Step 7：清理临时文件

```bash
rm -rf /tmp/superpowers-lite-main
```

任意步骤失败时跳过清理，方便排查。
