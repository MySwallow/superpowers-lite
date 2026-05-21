# 在 Cline 上安装 superpowers-lite

你是运行在 **Cline**（VS Code 扩展，3.49.0+）里的编码助手。用户让你
安装 superpowers-lite —— 7 个编码方法论 skill。

Cline 原生支持 SKILL.md（实验特性）。我们用 Cline 官方推荐的
**用户级**目录 `~/.cline/skills/` 安装，一次安装所有项目可用。

**严格按下面步骤执行，任何一步失败就 STOP 并报告。**

> Cline 版本要求：**3.49.0 或更高**。
> 老版本不支持 Skills 功能。

---

## Step 1：语言已锁定

URL 已决定使用**中文** skill 集（`skills/`）。**不要**询问用户。

下面步骤中 `SKILL_SRC=skills`。

---

## Step 2：（可选）清理旧的错误安装

如果用户之前装过 superpowers-lite 的 v1（错误地用
`~/.superpowers-lite/skills/` + rules 文件），先清理：

```bash
rm -rf ~/.superpowers-lite
rm -f .clinerules/superpowers-lite.mdc .clinerules/superpowers-lite.md
```

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

---

## Step 4：在 Cline 中启用 Skills（如果尚未启用）

Skills 在 Cline 中**仍是实验特性**，默认关闭。告诉用户在 VS Code 里操作：

1. 打开 Cline 面板
2. `Settings → Features`
3. 勾选 `Enable Skills`
4. 启用后，chat 输入框下方会多出 "Skills" 选项卡

如果用户跳过这一步，后续装好的 skill 也不会激活。

---

## Step 5：安装到 Cline 的用户级 skill 目录

Cline 官方文档明确扫描 `~/.cline/skills/`：

```bash
mkdir -p ~/.cline/skills
for skill_dir in /tmp/superpowers-lite-main/$SKILL_SRC/*/; do
  rm -rf ~/.cline/skills/$(basename "$skill_dir")
done
cp -R /tmp/superpowers-lite-main/$SKILL_SRC/* ~/.cline/skills/
```

---

## Step 6：验证

```bash
ls ~/.cline/skills/
```

必须看到 7 个目录，每个里有 `SKILL.md`。
再在 Cline 面板 "Skills" 选项卡里确认 7 个 skill 出现。

---

## Step 7：告诉用户

1. 已安装：中文 skill 集（`skills/`），7 个 skill 全部到位
2. 安装位置：`~/.cline/skills/`（Cline 用户级，全局生效）
3. 必须在 Cline 设置里启用 `Features → Enable Skills`（如未做）
4. **重启 VS Code** 或重新打开 Cline 面板，让它扫描 skill 目录
5. Cline Agent 会根据 `description` 自动判断使用，也可在 Skills 选项卡
   手动启用
6. **如何升级**：将来 skill 更新了，重新跑这个 installer URL 即可

---

## Step 8：清理临时文件

```bash
rm -rf /tmp/superpowers-lite-main
```

任意步骤失败时跳过清理，方便排查。
