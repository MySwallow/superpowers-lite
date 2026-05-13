# 双语安装链接 + Claude Code Hook 同步设计

**日期**：2026-05-13
**作者**：MySwallow + Claude
**状态**：Spec（待实施）
**范围**：`INSTALL.md`、`install/*.md`（5 个平台）、`docs/superpowers/specs/`

---

## 1. 背景与动机

### 1.1 当前痛点

1. **AI 安装流程需要问语言**。`install/<platform>.md` 的 Step 1 都让 AI 询问用户中文/英文（默认中文）。多走一轮，且当用户复制 URL 给 AI 后，还要再回答一个问题。
2. **`install/claude-code.md` 没有 hook 步骤**。`scripts/install-claude-code.sh`（bash 手动脚本）已经会安装 SessionStart hook，但 AI 走 markdown 流程装出来的状态缺这一步——会话启动时不会注入 `using-superpowers`，skill 触发率回落。两条安装路径输出的最终状态**不一致**。

### 1.2 目标

- 让"中文/英文"在 URL 层面就定死，AI 流程跳过问语言。
- 让 AI 走 `install/claude-code.md` 装出的最终状态，与跑 `scripts/install-claude-code.sh` **等价**——含 SessionStart hook。
- 保持已分享的中文 URL 不破坏（向后兼容）。

### 1.3 非目标

- **不**为 opencode/Codex/Gemini/Cursor 引入 hook 概念。这些平台的 `AGENTS.md` / `GEMINI.md` / `cursor-rules` 本身就在每次会话被加载，已经有等价的"自动注入"机制。
- **不**修改 `scripts/install-claude-code.sh`——它已经支持 `--lang zh|en` 和 hook 注册。
- **不**引入新的 plugin 系统、CLI 工具或语言切换器。

---

## 2. 架构概览

把"语言选择"从 AI 对话层提到 URL 层。一个 URL 等价于"目标平台 + 目标语言"的完整指令：

```
旧流程：1 URL/平台 → AI 询问语言 → 装 skills/ 或 skills-en/
新流程：2 URL/平台 → AI 按 URL 预设的语言安装；不再询问
```

5 个平台 × 2 个语言 = `install/` 下 10 份 markdown：

```
install/
├── claude-code.md         # 中文（原路径，向后兼容）
├── claude-code.en.md      # 英文（新）
├── opencode.md            # 中文
├── opencode.en.md         # 英文（新）
├── codex.md
├── codex.en.md            # 新
├── gemini-cli.md
├── gemini-cli.en.md       # 新
├── cursor.md
└── cursor.en.md           # 新
```

只有 `install/claude-code.md` 和 `install/claude-code.en.md` 多一个 hook 安装步骤；其他 8 份只是把 Step 1 由"问语言"改为"硬编码 SKILL_SRC"。

---

## 3. install/*.md 改造

### 3.1 通用改造（5 平台共 10 份）

每份 markdown 的 **Step 1** 从「Ask the user which language」改为硬编码声明：

**中文版 `install/<platform>.md`**：

```markdown
## Step 1: Language is preset

This installer uses the **Chinese** skill set.
Let `SKILL_SRC=skills` for the steps below.
```

**英文版 `install/<platform>.en.md`**：

```markdown
## Step 1: Language is preset

This installer uses the **English** skill set.
Let `SKILL_SRC=skills-en` for the steps below.
```

其余 Step（下载 / 安装 / 验证 / 报告 / 清理）的步骤结构在 `.md` 与 `.en.md` 之间 **1:1 镜像**，差异只有两点：

1. 上述 `SKILL_SRC` 的值
2. 文档自身的描述语言（中文版用中文叙述、英文版用英文叙述）——只是说明性文字，不影响 AI 执行的命令

### 3.2 内容已经语言无关的部分

bash 命令本身（`curl`、`tar`、`cp`、`jq` 等）与语言无关，两个版本完全相同。

### 3.3 报告环节

每份 markdown 末尾的"Step N: Report to the user"中，把
> "Language version installed (`skills` or `skills-en`)"

改为明确告知**已安装的具体版本**：
- 中文版：`Installed: Chinese skill set (skills/)`
- 英文版：`Installed: English skill set (skills-en/)`

---

## 4. Claude Code 的 Hook 步骤

### 4.1 适用范围

**仅** `install/claude-code.md` 与 `install/claude-code.en.md`。其他 4 平台不涉及。

### 4.2 步骤位置

在 Verify 之前插入新的 **Step 4: Install SessionStart hook**，原 Step 4–6 顺延为 5–7。

### 4.3 步骤内容（中文版示意）

```markdown
## Step 4: Install SessionStart hook (boosts skill trigger rate)

This hook makes Claude Code auto-inject the `using-superpowers` skill at
the start of every new session, so the model is primed to check skills
before responding.

**If `jq` is not installed**, SKIP this step and tell the user:

> "`jq` is required to register the SessionStart hook. Install it
> (`brew install jq` on macOS, `apt-get install jq` on Debian/Ubuntu),
> then re-run the hook step manually or re-run this installer."

Do **not** fail the whole install over a missing `jq`.

If `jq` is available, run:

```bash
mkdir -p ~/.claude/scripts
cp /tmp/superpowers-lite-main/scripts/session-start-hook.sh \
   ~/.claude/scripts/superpowers-lite-session-start.sh
chmod +x ~/.claude/scripts/superpowers-lite-session-start.sh
```

Then idempotently register the hook in `~/.claude/settings.json`. Use the
**exact** jq expressions from `scripts/install-claude-code.sh` (lines
98–115 in the current version). The detection check first:

```bash
HOOK_DEST="$HOME/.claude/scripts/superpowers-lite-session-start.sh"
SETTINGS="$HOME/.claude/settings.json"
[[ -f "$SETTINGS" ]] || echo '{}' > "$SETTINGS"

# Skip if already registered
if jq -e --arg cmd "$HOOK_DEST" \
     '.hooks.SessionStart // [] | map(.hooks // [] | map(.command)) | flatten | index($cmd)' \
     "$SETTINGS" >/dev/null 2>&1; then
  echo "hook already registered — skipping"
else
  tmp="$SETTINGS.tmp.$$"
  jq --arg cmd "$HOOK_DEST" '
    .hooks //= {} |
    .hooks.SessionStart //= [] |
    .hooks.SessionStart += [{
      "matcher": "startup|clear|compact",
      "hooks": [{"type": "command", "command": $cmd}]
    }]
  ' "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
fi
```
```

英文版步骤结构相同，叙述用英文。

### 4.4 Source of Truth 原则

`scripts/install-claude-code.sh` 是 hook 注册逻辑的 source of truth。markdown 里的 jq 表达式必须**逐字**等同于 bash 脚本中的对应行。后续若 bash 脚本变更，markdown 必须同步——这一点写在 spec 的 §7 维护条款里。

### 4.5 Report 环节

新流程的步骤顺序：Step 1 Language preset / Step 2 Download / Step 3 Install skills / Step 4 Install hook / Step 5 Verify / **Step 6 Report** / Step 7 Cleanup（共 7 步）。

`Step 6: Report to the user`（原 Step 5）新增一条：

> SessionStart hook: installed at `~/.claude/scripts/superpowers-lite-session-start.sh` and registered in `~/.claude/settings.json`. New sessions will auto-inject `using-superpowers`.
> (Or: "Skipped — `jq` was not available. Install `jq` and re-run the hook step or this installer to enable it.")

---

## 5. INSTALL.md 改造

### 5.1 新表格

```markdown
| Platform | 中文 (default) | English |
|---|---|---|
| Claude Code | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/claude-code.md> | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/claude-code.en.md> |
| opencode | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/opencode.md> | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/opencode.en.md> |
| Codex CLI | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/codex.md> | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/codex.en.md> |
| Gemini CLI | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/gemini-cli.md> | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/gemini-cli.en.md> |
| Cursor / Windsurf / Cline | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cursor.md> | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cursor.en.md> |
```

### 5.2 表格附近的文案

原句（节选）：
> "Each per-platform installer is self-contained: it tells the AI to ask about language preference, ..."

改为：
> Pick the **中文** column for Chinese skills (default for Chinese readers), or the **English** column for English. The URL itself determines the language — the AI does not ask. Each per-platform installer is self-contained: it downloads the repo, installs to that platform's correct global directory, verifies, and reports back.

### 5.3 Claude Code 的 hook 提示

在 INSTALL.md 中给 Claude Code 那一行加一个脚注或额外说明，简明告诉用户：

> Claude Code installs also register a `SessionStart` hook that injects `using-superpowers` at session start to keep skill trigger rate high. Requires `jq`; skipped gracefully if missing.

---

## 6. 文件清单（差异）

**新增**：

- `install/claude-code.en.md`
- `install/opencode.en.md`
- `install/codex.en.md`
- `install/gemini-cli.en.md`
- `install/cursor.en.md`
- `docs/superpowers/specs/2026-05-13-install-bilingual-and-hook-design.md`（本文档）

**修改**：

- `INSTALL.md` — 表格双列化 + 文案
- `README.md` — 第 65–69 行的 install URL 表格双列化（与 INSTALL.md 同构）
- `README.en.md` — 第 65–69 行的 install URL 表格双列化（与 INSTALL.md 同构）
- `install/claude-code.md` — Step 1 改硬编码；插入 Step 4(Hook)；Report 增条目
- `install/opencode.md` — Step 1 改硬编码
- `install/codex.md` — Step 1 改硬编码
- `install/gemini-cli.md` — Step 1 改硬编码（仅 Path B 部分；Path A 不动）
- `install/cursor.md` — Step 1 改硬编码

**不动**：

- `scripts/install-claude-code.sh`
- `scripts/session-start-hook.sh`
- `skills/`、`skills-en/`
- `templates/`、`GEMINI.md`、`gemini-extension.json`

---

## 7. 维护条款

- **jq 表达式同步**：`install/claude-code.md` / `.en.md` 里的 hook 注册 jq 表达式必须与 `scripts/install-claude-code.sh` 完全一致。后者改动时必须同步前者。可考虑在 bash 脚本顶部加注释指向本 spec 和 markdown 文件路径，作为提醒。
- **中英文版结构对称**：每对 `.md` 与 `.en.md` 的 Step 个数、Step 标题语义一一对应。修改时两份同步，避免漂移。
- **新增平台时**：必须同时新增中、英两份 markdown，且 INSTALL.md 表格新增一行（双列）。

---

## 8. 验证计划（实施阶段执行）

1. **中文路径（claude-code.md）**：在临时目录跑一遍 markdown 流程，确认：
   - `~/.claude/skills/` 7 个目录都是中文（`skills/` 来源）
   - `~/.claude/settings.json` 含 hook 条目
   - `~/.claude/scripts/superpowers-lite-session-start.sh` 存在且可执行
   - 新开会话能看到 system-reminder 注入 `using-superpowers` 中文内容
2. **英文路径（claude-code.en.md）**：同上，但 skills 来源为 `skills-en/`，注入的是英文 `using-superpowers/SKILL.md`
3. **jq 缺失场景**：临时 PATH 屏蔽 jq，跑 markdown 流程，确认 hook 步骤被跳过、Report 正确告知、Skills 仍然装上、整体不报错
4. **幂等性**：在已注册 hook 的环境再跑一遍，settings.json 中 hook 条目数量不应增加
5. **其他 4 平台**：跑 `install/opencode.en.md`、`install/codex.en.md`、`install/gemini-cli.en.md`（Path B）、`install/cursor.en.md`，确认装的是 `skills-en/`，无 hook 副作用

---

## 9. 风险与缓解

| 风险 | 影响 | 缓解 |
|---|---|---|
| 中、英两份 markdown 步骤漂移 | AI 行为不一致 | 实施时严格 1:1 镜像；后续维护看 §7 条款 |
| jq 表达式与 bash 脚本漂移 | hook 注册失败或重复 | bash 脚本顶部加注释指向 markdown；如果可行，未来考虑用脚本生成 markdown |
| 用户复制了旧的"问语言"流程缓存 | 体验不一致但不报错 | 中文 URL 路径不变，AI 拉到的就是新文案 |
| 老的 INSTALL.md 截图/分享链接 | 用户可能看到旧表格 | 不可控；README 顶部明示版本号或日期可缓解 |

---

## 10. 实施顺序建议

1. 先复制 5 份中文 markdown → 创建对应 `.en.md`，逐字改 SKILL_SRC 和叙述语言
2. 修改 `install/claude-code.md` 加 Step 4(Hook)，再镜像到 `claude-code.en.md`
3. 把 5 份中文 markdown 的 Step 1 改硬编码（去掉"问语言"）
4. 改 INSTALL.md 表格 + 文案
5. 跑验证计划（§8）
6. （由用户决定时机）静态检查、commit

> **CLAUDE.md 约束**：实施阶段**只做静态检查**（如 markdown lint / 路径检查），**不自动 commit**，等用户明确说"提交"。
