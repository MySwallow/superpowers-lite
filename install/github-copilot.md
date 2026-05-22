# 在 GitHub Copilot CLI 上安装 superpowers-lite

你是运行在 **GitHub Copilot CLI** 里的编码助手。用户让你安装
superpowers-lite —— 7 个编码方法论 skill。

GitHub Copilot CLI 原生支持 SKILL.md 格式（与 Claude Code 相同的
Anthropic 规范）。我们装到 Copilot 官方推荐的**个人级**目录
`~/.copilot/skills/`，一次安装，所有项目可用。

**严格按下面步骤执行，任何一步失败就 STOP 并报告。**

---

## Step 1：语言已锁定

URL 已决定使用**中文** skill 集（`skills/`）。**不要**询问用户。

下面步骤中 `SKILL_SRC=skills`。

---

## Step 2：下载仓库

```bash
curl -fsSL https://github.com/MySwallow/superpowers-lite/archive/refs/heads/main.tar.gz \
  | tar xz -C /tmp/
```

或：

```bash
git clone --depth=1 https://github.com/MySwallow/superpowers-lite.git /tmp/superpowers-lite-main
```

验证 `/tmp/superpowers-lite-main/skills/` 必须包含 **7 个目录**。
否则 STOP 并报告。

---

## Step 3：安装到 Copilot 个人级 skill 目录

Copilot CLI 官方文档明确扫描 `~/.copilot/skills/`（个人级，跨项目共享）：

```bash
mkdir -p ~/.copilot/skills
for skill_dir in /tmp/superpowers-lite-main/$SKILL_SRC/*/; do
  rm -rf ~/.copilot/skills/$(basename "$skill_dir")
done
cp -R /tmp/superpowers-lite-main/$SKILL_SRC/* ~/.copilot/skills/
```

> 备选目录：`~/.agents/skills/` 也被 Copilot 识别。若用户已有
> `~/.agents/` 习惯（例如同时给多个 agent 工具共享 skill），可把
> `~/.copilot/skills` 换成 `~/.agents/skills`。

---

## Step 4：验证

```bash
ls ~/.copilot/skills/
```

必须看到 **7 个目录**，每个里有 `SKILL.md`。把目录名打印给用户。
若数量不是 7，STOP 并报告。

如果用户当前在 Copilot CLI 会话里，让他执行：

```
/skills reload
```

Copilot 会重新扫描 skills 目录并加载新内容。然后再跑：

```
/skills
```

确认列表里出现 7 个 skill。

---

## Step 5：告诉用户

1. 已安装：中文 skill 集（`skills/`），7 个 skill 全部到位
2. 安装位置：`~/.copilot/skills/`（Copilot CLI 个人级，全局生效）
3. 如果当前在 Copilot CLI 会话里，用 `/skills reload` 重新加载；
   否则下次启动 Copilot CLI 时会自动扫描
4. Copilot Agent 会根据 `description` 自动决定使用，也可以在 prompt
   里直接提"用 brainstorming skill"主动触发
5. **如何升级**：将来 skill 更新了，重新跑这个 installer URL 即可
6. 工具名等价对照（Claude Code → Copilot CLI）见
   `~/.copilot/skills/using-superpowers/references/`，让 Copilot 在
   需要时查阅

---

## Step 6：清理临时文件

```bash
rm -rf /tmp/superpowers-lite-main
```

任意步骤失败时跳过清理，方便排查。
