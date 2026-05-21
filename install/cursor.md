# 在 Cursor / Windsurf / Cline 上安装 superpowers-lite

你是运行在 **Cursor / Windsurf / Cline**（或其他 IDE 内嵌 AI）里的编码助手。
用户让你安装 superpowers-lite —— 7 个编码方法论 skill。

这些 IDE 用**项目级 rules**而不是全局 skill，所以安装策略是：把 skill
文件放到用户级共享目录，再把指引 rule 写进当前项目的 rules 目录。

**严格按下面步骤执行，任何一步失败就 STOP 并报告。**

---

## Step 1：语言已锁定

URL 已决定使用**中文** skill 集（`skills/`）。**不要**询问用户。

下面步骤中 `SKILL_SRC=skills`。

---

## Step 2：确认当前项目的 rules 目录

判断你在哪个 IDE：

- **Cursor** → rules 目录 `<project>/.cursor/rules/`
- **Windsurf** → `<project>/.windsurf/rules/`
- **Cline** → `<project>/.clinerules/`
- **未知** → 问用户该工具的 rules 目录在哪

把绝对路径记为 `RULES_DIR`。

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

## Step 4：把 skill 装到用户级共享目录

先删旧的 7 个 superpowers-lite skill 文件夹，再复制新版。其他用户自己加在
`~/.superpowers-lite/skills/` 下的文件会被保留。

```bash
mkdir -p ~/.superpowers-lite/skills
for skill_dir in /tmp/superpowers-lite-main/$SKILL_SRC/*/; do
  rm -rf ~/.superpowers-lite/skills/$(basename "$skill_dir")
done
cp -R /tmp/superpowers-lite-main/$SKILL_SRC/* ~/.superpowers-lite/skills/
```

---

## Step 5：写入项目 rule 文件（**关键步骤**）

> 关键事实（已经过印证）：
> 1. Cursor 项目 rule **必须**用 `.mdc` 后缀（最新 Cursor 2.x 版本里 `.md`
>    不被识别）
> 2. 要让 rule **每次会话自动注入到上下文**，frontmatter 必须是
>    `alwaysApply: true`
> 3. Cursor agent **不会**主动跨边界 read 用户家目录的文件，所以 rule
>    内容必须 inline 关键指令 + 给出绝对路径（不能保留 `~`）

执行：

```bash
# 用 $HOME 展开 ~ 得到绝对路径
SKILLS_PATH="$HOME/.superpowers-lite/skills"

# 生成 rule 文件（替换模板里的 <SKILLS_PATH> 占位符）
mkdir -p "$RULES_DIR"
sed "s|<SKILLS_PATH>|$SKILLS_PATH|g" \
  /tmp/superpowers-lite-main/templates/cursor-rules.zh.mdc \
  > "$RULES_DIR/superpowers-lite.mdc"
```

写入后用 `cat` 或 Read 工具检查 `$RULES_DIR/superpowers-lite.mdc`：

- 第一行必须是 `---`
- frontmatter 里 `alwaysApply: true`
- 路径占位符 `<SKILLS_PATH>` 已被替换成 `/Users/xxx/.superpowers-lite/skills`
  这种**绝对路径**（不应再出现 `~` 或 `<SKILLS_PATH>`）

---

## Step 6：验证

- `~/.superpowers-lite/skills/` 下有 7 个 skill 文件夹
- `$RULES_DIR/superpowers-lite.mdc` 存在
- rule 文件中的 `<SKILLS_PATH>` 已全部替换为绝对路径
- frontmatter 里 `alwaysApply: true`

任意一项不满足 → STOP 并报告。

---

## Step 7：告诉用户

1. 已安装：中文 skill 集（`skills/`）
2. Skill 路径：`~/.superpowers-lite/skills/`
3. 项目 rule 文件：`$RULES_DIR/superpowers-lite.mdc`（`.mdc` 后缀很重要）
4. **请重启 IDE 或 reload 当前窗口**，让 Cursor 重新扫描 rules 目录
5. 验证：随便问一个 bug 或新功能问题，AI 应该会先声明
   "Using systematic-debugging to ..." 或 "Using brainstorming to ..." 等
6. 如果想在其他项目也用，在该项目里重复 Step 5（或把
   `superpowers-lite.mdc` 软链/复制过去）

---

## Step 8：清理

```bash
rm -rf /tmp/superpowers-lite-main
```

任意步骤失败时跳过清理，方便排查。
