# 双语安装链接 + Claude Code Hook 同步 实施计划

> **For agentic workers:** Use the subagent-driven-development skill (recommended) or executing-plans skill to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 让 5 个平台 install/*.md 都有中/英双链接版本，并让 Claude Code 的 AI 安装流程与 bash 脚本一样自动装 SessionStart hook。

**Architecture:** 每平台一份中文 .md（原路径，向后兼容）+ 一份新 .en.md。AI 流程跳过"问语言"环节——URL 把语言定死。`install/claude-code.md` 和 `install/claude-code.en.md` 额外多一个 hook 安装步骤，jq 表达式严格对齐 `scripts/install-claude-code.sh`。

**Tech Stack:** Markdown (instruction docs), bash + jq (referenced commands, not executed by the plan itself)

**Spec:** [`docs/superpowers/specs/2026-05-13-install-bilingual-and-hook-design.md`](../specs/2026-05-13-install-bilingual-and-hook-design.md)

**用户规则注意（CLAUDE.md）：**
- 不强制 TDD。本计划没有"先写失败测试"步骤——markdown 改动没有传统测试，验证手段是 grep / 文件存在性 / `bash -n` 语法检查。
- 完成后只做静态检查。
- **不要自动 commit**。本计划不包含 `git commit` 步骤——所有改动留待用户明确说"提交"后再统一 commit。

---

## Task 1: 修改 4 个非 hook 平台的中文 .md 的 Step 1

**Files:**
- Modify: `install/opencode.md`（Step 1 段落）
- Modify: `install/codex.md`（Step 1 段落）
- Modify: `install/gemini-cli.md`（Path B 下的 Step 1 段落，注意是 `###` 三级标题）
- Modify: `install/cursor.md`（Step 1 段落）

**目标**：把"询问用户语言"改为"硬编码声明使用 Chinese skill set"。报告环节同步改"`skills` or `skills-en`"为"Chinese skill set (`skills/`)"。

---

- [ ] **Step 1.1: 改 `install/opencode.md` 的 Step 1**

用 Edit，old_string：

```markdown
## Step 1: Ask the user which language

Two skill sets ship in this repository:

- `skills/` — **Chinese (default)**
- `skills-en/` — English

Ask the user which one. If they don't specify, use `skills/`.
Let `SKILL_SRC` be the chosen directory name.
```

new_string：

```markdown
## Step 1: Language is preset

This installer uses the **Chinese** skill set (`skills/`). The language is
fixed by the URL the user picked — do **not** ask them.

Let `SKILL_SRC=skills` for the steps below.
```

---

- [ ] **Step 1.2: 改 `install/opencode.md` 的 Step 6 Report**

old_string：

```markdown
1. Language version installed (`skills` or `skills-en`)
```

new_string：

```markdown
1. Installed: Chinese skill set (`skills/`)
```

---

- [ ] **Step 1.3: 改 `install/codex.md` 的 Step 1**

old_string（同 1.1 的 old_string，因为这一段在所有非 hook 平台都一字不差）：

```markdown
## Step 1: Ask the user which language

Two skill sets ship in this repository:

- `skills/` — **Chinese (default)**
- `skills-en/` — English

Ask the user which one. If they don't specify, use `skills/`.
Let `SKILL_SRC` be the chosen directory name.
```

new_string（同 1.1 的 new_string）：

```markdown
## Step 1: Language is preset

This installer uses the **Chinese** skill set (`skills/`). The language is
fixed by the URL the user picked — do **not** ask them.

Let `SKILL_SRC=skills` for the steps below.
```

---

- [ ] **Step 1.4: 改 `install/codex.md` 的 Step 5 Report**

old_string：

```markdown
1. Language version installed (`skills` or `skills-en`)
```

new_string：

```markdown
1. Installed: Chinese skill set (`skills/`)
```

---

- [ ] **Step 1.5: 改 `install/gemini-cli.md` Path B 下的 Step 1**

注意是 `###`（三级标题）。old_string：

```markdown
### Step 1: Ask the user which language

Two skill sets ship in this repository:

- `skills/` — **Chinese (default)**
- `skills-en/` — English

Ask the user. If unspecified, use `skills/`. Let `SKILL_SRC` be that name.
```

new_string：

```markdown
### Step 1: Language is preset

This installer uses the **Chinese** skill set (`skills/`). The language is
fixed by the URL the user picked — do **not** ask them.

Let `SKILL_SRC=skills` for the steps below.
```

> `install/gemini-cli.md` 的 Step 6 Report 没有"Language version installed"那一行（措辞不同），跳过 Report 改动。

---

- [ ] **Step 1.6: 改 `install/cursor.md` 的 Step 1**

old_string：

```markdown
## Step 1: Ask the user which language

Two skill sets ship in this repository:

- `skills/` — **Chinese (default)**
- `skills-en/` — English

Ask the user. If unspecified, use `skills/`. Let `SKILL_SRC` be that name.
```

new_string：

```markdown
## Step 1: Language is preset

This installer uses the **Chinese** skill set (`skills/`). The language is
fixed by the URL the user picked — do **not** ask them.

Let `SKILL_SRC=skills` for the steps below.
```

---

- [ ] **Step 1.7: 改 `install/cursor.md` 的 Step 7 Report**

old_string：

```markdown
1. Language version installed
```

new_string：

```markdown
1. Installed: Chinese skill set (`skills/`)
```

---

- [ ] **Step 1.8: 静态检查（grep 确认无残留）**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite
grep -nE "Ask the user which language|Language version installed" install/opencode.md install/codex.md install/gemini-cli.md install/cursor.md
```

Expected: 空输出（exit 1）。如果有任何匹配，回头修。

---

## Task 2: 创建 4 个非 hook 平台的英文版 .en.md

**Files:**
- Create: `install/opencode.en.md`
- Create: `install/codex.en.md`
- Create: `install/gemini-cli.en.md`
- Create: `install/cursor.en.md`

**目标**：每个 .en.md 是对应 .md（Task 1 改完后的状态）的镜像，唯一差异：`SKILL_SRC=skills-en`、声明 English skill set、Report 行也用英文 skill set。

策略：用 `cp` 复制中文版为初稿，然后用 Edit 做两到三处替换。

---

- [ ] **Step 2.1: 创建 `install/opencode.en.md`（复制中文版）**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite
cp install/opencode.md install/opencode.en.md
```

Expected: 文件创建成功，无报错。

---

- [ ] **Step 2.2: 改 `install/opencode.en.md` Step 1**

用 Edit，old_string：

```markdown
## Step 1: Language is preset

This installer uses the **Chinese** skill set (`skills/`). The language is
fixed by the URL the user picked — do **not** ask them.

Let `SKILL_SRC=skills` for the steps below.
```

new_string：

```markdown
## Step 1: Language is preset

This installer uses the **English** skill set (`skills-en/`). The language is
fixed by the URL the user picked — do **not** ask them.

Let `SKILL_SRC=skills-en` for the steps below.
```

---

- [ ] **Step 2.3: 改 `install/opencode.en.md` Report**

old_string：

```markdown
1. Installed: Chinese skill set (`skills/`)
```

new_string：

```markdown
1. Installed: English skill set (`skills-en/`)
```

---

- [ ] **Step 2.4: 创建并改 `install/codex.en.md`**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite
cp install/codex.md install/codex.en.md
```

然后用 Edit 替换 Step 1 段落：

old_string（同 2.2 old_string）→ new_string（同 2.2 new_string）。

接着 Edit Report：old_string（同 2.3 old_string）→ new_string（同 2.3 new_string）。

---

- [ ] **Step 2.5: 创建并改 `install/gemini-cli.en.md`**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite
cp install/gemini-cli.md install/gemini-cli.en.md
```

然后用 Edit 替换 Path B 下的三级标题 Step 1，old_string：

```markdown
### Step 1: Language is preset

This installer uses the **Chinese** skill set (`skills/`). The language is
fixed by the URL the user picked — do **not** ask them.

Let `SKILL_SRC=skills` for the steps below.
```

new_string：

```markdown
### Step 1: Language is preset

This installer uses the **English** skill set (`skills-en/`). The language is
fixed by the URL the user picked — do **not** ask them.

Let `SKILL_SRC=skills-en` for the steps below.
```

> `gemini-cli.md` 没改 Report，所以这里也不需要改 Report。

---

- [ ] **Step 2.6: 创建并改 `install/cursor.en.md`**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite
cp install/cursor.md install/cursor.en.md
```

然后 Edit Step 1：old_string（同 2.2 old_string）→ new_string（同 2.2 new_string）。

Edit Report：old_string（同 2.3 old_string）→ new_string（同 2.3 new_string）。

---

- [ ] **Step 2.7: 静态检查**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite
ls install/*.en.md
grep -l "SKILL_SRC=skills-en" install/*.en.md
grep -c "Installed: English skill set" install/opencode.en.md install/codex.en.md install/cursor.en.md
```

Expected:
- `ls`：列出 `install/opencode.en.md`、`install/codex.en.md`、`install/gemini-cli.en.md`、`install/cursor.en.md`
- `grep -l`：列出全部 4 个 .en.md（含 gemini-cli.en.md）
- `grep -c`：3 个文件都是 `1`（gemini-cli.en.md 不含 Report 修改，所以不查它）

---

## Task 3: 改 `install/claude-code.md` —— Step 1 硬编码 + 插入 hook Step + 顺延 Step 编号

**Files:**
- Modify: `install/claude-code.md`（多处）

**目标**：
1. Step 1 改硬编码（中文）
2. 在原 Step 4(Verify) 之前插入新的 Step 4: Install SessionStart hook
3. 原 Step 4–6 顺延为 5–7
4. Step 6 Report 增加 hook 报告条目

---

- [ ] **Step 3.1: 改 `install/claude-code.md` 的 Step 1**

用 Edit，old_string：

```markdown
## Step 1: Ask the user which language

Two skill sets ship in this repository:

- `skills/` — **Chinese (default)**
- `skills-en/` — English

Ask the user which one. If they don't specify, use `skills/`.
Let `SKILL_SRC` be the chosen directory name.
```

new_string：

```markdown
## Step 1: Language is preset

This installer uses the **Chinese** skill set (`skills/`). The language is
fixed by the URL the user picked — do **not** ask them.

Let `SKILL_SRC=skills` for the steps below.
```

---

- [ ] **Step 3.2: 顺延 Step 4 → Step 5（Verify）**

用 Edit，old_string：

```markdown
## Step 4: Verify

List `~/.claude/skills/` and confirm **7 skill folders** are present, each
containing a `SKILL.md`. Print the folder names to the user.

If the count is not 7, STOP and report.
```

new_string：

```markdown
## Step 5: Verify

List `~/.claude/skills/` and confirm **7 skill folders** are present, each
containing a `SKILL.md`. Print the folder names to the user.

If the count is not 7, STOP and report.
```

---

- [ ] **Step 3.3: 顺延 Step 5 → Step 6（Report）+ 新增 hook 报告条目**

用 Edit，old_string：

```markdown
## Step 5: Report to the user

Tell the user, in plain language:

1. Language version installed (`skills` or `skills-en`)
2. Install path: `~/.claude/skills/`
3. **Restart Claude Code session** to load the new skills
4. Example trigger to confirm: ask "let's brainstorm a new feature" — the
   `brainstorming` skill should activate.
```

new_string：

```markdown
## Step 6: Report to the user

Tell the user, in plain language:

1. Installed: Chinese skill set (`skills/`)
2. Install path: `~/.claude/skills/`
3. SessionStart hook: installed at `~/.claude/scripts/superpowers-lite-session-start.sh`
   and registered in `~/.claude/settings.json`. New sessions will auto-inject
   `using-superpowers`. (Or, if `jq` was missing: skipped — tell the user
   how to enable it later.)
4. **Restart Claude Code session** to load the new skills
5. Example trigger to confirm: ask "let's brainstorm a new feature" — the
   `brainstorming` skill should activate.
```

---

- [ ] **Step 3.4: 顺延 Step 6 → Step 7（Cleanup）**

用 Edit，old_string：

```markdown
## Step 6: Cleanup

```bash
rm -rf /tmp/superpowers-lite-main
```

Skip cleanup if Step 3 or 4 failed — leave the temp dir for inspection.
```

new_string：

```markdown
## Step 7: Cleanup

```bash
rm -rf /tmp/superpowers-lite-main
```

Skip cleanup if Step 3, 4 or 5 failed — leave the temp dir for inspection.
```

---

- [ ] **Step 3.5: 在原 Step 4(Verify) 现在叫 Step 5 之前，插入新的 Step 4 (Install hook)**

> 顺序很关键：先把 Verify 改名为 Step 5（Step 3.2 已做），再在它前面插入 Step 4。

用 Edit，old_string（要在 Step 5: Verify 之前插入，所以用它的标题作为锚点）：

```markdown
---

## Step 5: Verify
```

new_string：

```markdown
---

## Step 4: Install SessionStart hook (boosts skill trigger rate)

This hook makes Claude Code auto-inject the `using-superpowers` skill at
the start of every new session, so the model is primed to check skills
before responding.

**If `jq` is not installed**, SKIP this step and tell the user:

> "`jq` is required to register the SessionStart hook. Install it
> (`brew install jq` on macOS, `apt-get install jq` on Debian/Ubuntu),
> then re-run this installer (or run `scripts/install-claude-code.sh`
> from the cloned repo) to enable the hook."

Do **not** fail the whole install over a missing `jq`. Continue to Step 5.

If `jq` is available:

```bash
mkdir -p ~/.claude/scripts
cp /tmp/superpowers-lite-main/scripts/session-start-hook.sh \
   ~/.claude/scripts/superpowers-lite-session-start.sh
chmod +x ~/.claude/scripts/superpowers-lite-session-start.sh
```

Then idempotently register the hook in `~/.claude/settings.json`. The jq
expressions below are **copied verbatim** from
`scripts/install-claude-code.sh` (do not improvise them):

```bash
HOOK_DEST="$HOME/.claude/scripts/superpowers-lite-session-start.sh"
SETTINGS="$HOME/.claude/settings.json"
[[ -f "$SETTINGS" ]] || echo '{}' > "$SETTINGS"

# Skip if the same command is already registered
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
  echo "hook registered in $SETTINGS"
fi
```

---

## Step 5: Verify
```

---

- [ ] **Step 3.6: 静态检查 — 步骤号序列**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite
grep -nE "^## Step [0-9]+:" install/claude-code.md
```

Expected 输出 7 行，编号严格 1→7：

```
## Step 1: Language is preset
## Step 2: Download the repository
## Step 3: Install
## Step 4: Install SessionStart hook (boosts skill trigger rate)
## Step 5: Verify
## Step 6: Report to the user
## Step 7: Cleanup
```

如果编号有跳跃或重复，回头修。

---

## Task 4: 创建 `install/claude-code.en.md`

**Files:**
- Create: `install/claude-code.en.md`

**目标**：基于 Task 3 完成后的 `install/claude-code.md` 镜像 + 改 SKILL_SRC、改 skill set 描述。

---

- [ ] **Step 4.1: 复制中文版作为初稿**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite
cp install/claude-code.md install/claude-code.en.md
```

---

- [ ] **Step 4.2: 改 Step 1**

用 Edit，old_string：

```markdown
## Step 1: Language is preset

This installer uses the **Chinese** skill set (`skills/`). The language is
fixed by the URL the user picked — do **not** ask them.

Let `SKILL_SRC=skills` for the steps below.
```

new_string：

```markdown
## Step 1: Language is preset

This installer uses the **English** skill set (`skills-en/`). The language is
fixed by the URL the user picked — do **not** ask them.

Let `SKILL_SRC=skills-en` for the steps below.
```

---

- [ ] **Step 4.3: 改 Step 6 Report 第一条**

用 Edit，old_string：

```markdown
1. Installed: Chinese skill set (`skills/`)
```

new_string：

```markdown
1. Installed: English skill set (`skills-en/`)
```

---

- [ ] **Step 4.4: 静态检查**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite
grep -nE "^## Step [0-9]+:" install/claude-code.en.md
grep -n "SKILL_SRC=skills-en" install/claude-code.en.md
grep -n "Installed: English skill set" install/claude-code.en.md
```

Expected:
- 步骤号序列 1→7 跟 claude-code.md 一样
- `SKILL_SRC=skills-en` 至少 1 行（Step 1 里）
- `Installed: English skill set` 1 行（Step 6 里）

---

## Task 5: 改 `INSTALL.md` 表格 + 文案

**Files:**
- Modify: `INSTALL.md`

---

- [ ] **Step 5.1: 替换表格 + 表格前后文案**

用 Edit，old_string：

```markdown
Pick the install URL for **your platform** and paste it into your AI:

| Platform | Tell your AI: "Please install superpowers-lite. Follow:" |
|---|---|
| Claude Code | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/claude-code.md> |
| opencode | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/opencode.md> |
| Codex CLI | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/codex.md> |
| Gemini CLI | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/gemini-cli.md> |
| Cursor / Windsurf / Cline | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cursor.md> |

Each per-platform installer is self-contained: it tells the AI to ask
about language preference, download the repo, install to that platform's
correct global directory, verify, and report back.
```

new_string：

```markdown
Pick the install URL for **your platform and your preferred language**, then paste it into your AI:

| Platform | 中文 (default) | English |
|---|---|---|
| Claude Code | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/claude-code.md> | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/claude-code.en.md> |
| opencode | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/opencode.md> | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/opencode.en.md> |
| Codex CLI | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/codex.md> | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/codex.en.md> |
| Gemini CLI | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/gemini-cli.md> | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/gemini-cli.en.md> |
| Cursor / Windsurf / Cline | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cursor.md> | <https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cursor.en.md> |

The URL itself determines the language — the AI will **not** ask. Each
per-platform installer is self-contained: it downloads the repo, installs
to that platform's correct global directory, verifies, and reports back.

> **Claude Code only:** the installer also registers a `SessionStart` hook
> that injects `using-superpowers` at the start of every new session
> (keeps skill trigger rate high). Requires `jq`; skipped gracefully if
> missing.
```

---

- [ ] **Step 5.2: 静态检查**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite
grep -c "\.en\.md" INSTALL.md
grep -E "中文 \(default\)|English" INSTALL.md
```

Expected:
- `grep -c`：≥ 5（5 个 .en.md URL）
- 第二个 grep：匹配新表头行

---

## Task 6: 改 `README.md` 和 `README.en.md` 的安装链接表格

**Files:**
- Modify: `README.md`（第 63–69 行附近的表格）
- Modify: `README.en.md`（第 63–69 行附近的表格）

---

- [ ] **Step 6.1: 改 `README.md`（中文 README）的表格**

用 Edit，old_string：

```markdown
挑你当前平台对应的 URL，把它粘到 AI 终端里：

| 平台 | 跟 AI 说："帮我安装 superpowers-lite，按这个链接操作：" |
|---|---|
| Claude Code | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/claude-code.md` |
| opencode | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/opencode.md` |
| Codex CLI | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/codex.md` |
| Gemini CLI | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/gemini-cli.md` |
| Cursor / Windsurf / Cline | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cursor.md` |

每个 URL 对应一份针对该平台的指令，AI 读完会下载 skill 并装到对应的全局目录（`~/.claude/skills/`、`~/.config/opencode/skills/` 等）。
```

new_string：

```markdown
挑你当前平台 + 语言对应的 URL，把它粘到 AI 终端里：

| 平台 | 中文（默认） | English |
|---|---|---|
| Claude Code | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/claude-code.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/claude-code.en.md` |
| opencode | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/opencode.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/opencode.en.md` |
| Codex CLI | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/codex.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/codex.en.md` |
| Gemini CLI | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/gemini-cli.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/gemini-cli.en.md` |
| Cursor / Windsurf / Cline | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cursor.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cursor.en.md` |

URL 本身就决定语言——AI 不会再问。每份链接对应一份针对该平台的指令，AI 读完会下载 skill 并装到对应的全局目录（`~/.claude/skills/`、`~/.config/opencode/skills/` 等）。Claude Code 还会额外注册一个 SessionStart hook，让每个新会话自动加载 `using-superpowers`（需要 `jq`，缺失时优雅跳过）。
```

---

- [ ] **Step 6.2: 改 `README.en.md`（英文 README）的表格**

用 Edit，old_string：

```markdown
Pick the URL for **your platform** and paste it into your AI:

| Platform | Tell your AI: "Please install superpowers-lite. Follow:" |
|---|---|
| Claude Code | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/claude-code.md` |
| opencode | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/opencode.md` |
| Codex CLI | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/codex.md` |
| Gemini CLI | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/gemini-cli.md` |
| Cursor / Windsurf / Cline | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cursor.md` |

Each URL contains platform-specific instructions. The AI will download the
skills and install them to the correct global directory (`~/.claude/skills/`,
`~/.config/opencode/skills/`, etc.) and report where they ended up.
```

new_string：

```markdown
Pick the URL for **your platform + preferred language**, then paste it into your AI:

| Platform | 中文 (default) | English |
|---|---|---|
| Claude Code | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/claude-code.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/claude-code.en.md` |
| opencode | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/opencode.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/opencode.en.md` |
| Codex CLI | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/codex.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/codex.en.md` |
| Gemini CLI | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/gemini-cli.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/gemini-cli.en.md` |
| Cursor / Windsurf / Cline | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cursor.md` | `https://raw.githubusercontent.com/MySwallow/superpowers-lite/main/install/cursor.en.md` |

The URL itself determines the language — the AI will **not** ask. Each URL
contains platform-specific instructions. The AI downloads the skills,
installs them to the correct global directory (`~/.claude/skills/`,
`~/.config/opencode/skills/`, etc.), and reports back. Claude Code installs
also register a `SessionStart` hook that auto-injects `using-superpowers`
on every new session (requires `jq`; skipped gracefully if missing).
```

---

- [ ] **Step 6.3: 静态检查**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite
grep -c "\.en\.md" README.md README.en.md
```

Expected: 两个文件都 ≥ 5。

---

## Task 7: 端到端验证

**Files:**（不写文件，只跑检查）

**目标**：spec §8 的验证条款的可执行子集。本地无法跑完整的"模拟新 Claude Code 会话"流程，所以这里只做静态可验证项。完整 e2e（跑实际 install、检查 settings.json、新会话注入）建议下一会话或交给用户手动验。

---

- [ ] **Step 7.1: 文件清单**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite
ls -1 install/
```

Expected: 10 个文件，含 5 个 `.md` 和 5 个 `.en.md`，每个平台一对。

---

- [ ] **Step 7.2: 所有平台都不再"问语言"**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite
grep -lE "Ask the user which language" install/*.md install/*.en.md
```

Expected: 空（exit 1）。

---

- [ ] **Step 7.3: 所有 .en.md 都指向 skills-en**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite
grep -L "SKILL_SRC=skills-en" install/*.en.md
```

Expected: 空（exit 0 with no output）。

> `-L` 列出**没有**匹配的文件。所以空输出意味着所有 .en.md 都含 `SKILL_SRC=skills-en`。

---

- [ ] **Step 7.4: 所有 .md（非 .en.md）都指向 skills**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite
for f in install/claude-code.md install/opencode.md install/codex.md install/gemini-cli.md install/cursor.md; do
  if ! grep -q "SKILL_SRC=skills$" "$f"; then
    echo "MISSING in $f"
  fi
done
```

Expected: 无输出。

---

- [ ] **Step 7.5: claude-code 两份的 hook 步骤齐全**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite
grep -c "Install SessionStart hook" install/claude-code.md install/claude-code.en.md
grep -c "superpowers-lite-session-start.sh" install/claude-code.md install/claude-code.en.md
grep -c "matcher.*startup|clear|compact" install/claude-code.md install/claude-code.en.md
```

Expected:
- 第一行：两个文件都是 `1`
- 第二行：两个文件都 ≥ 2（cp 命令一次，settings.json 注册段一次）
- 第三行：两个文件都是 `1`

---

- [ ] **Step 7.6: 嵌入的 bash 脚本片段语法 sanity check**

把 claude-code.md 里 hook 步骤的 bash 块抽出来跑 `bash -n` 看语法：

```bash
cd /Users/mini/Documents/dev/superpowers-lite

# 把 Step 4 里的关键 bash 块抽到临时文件
awk '/^```bash$/,/^```$/' install/claude-code.md | grep -v '^```' > /tmp/extracted.sh
bash -n /tmp/extracted.sh
echo "exit=$?"
rm -f /tmp/extracted.sh
```

Expected: `exit=0`（语法 OK）。如果非 0，看输出找问题；hook 块的 jq 表达式有可能因为 awk 抓的多块拼起来出问题——如果是这个问题，单独提取 Step 4 那一段（`awk` 用更精细的范围）再跑。

> 说明：bash -n 只检查 shell 语法，不会执行命令；也不会真正校验 jq 表达式的正确性——后者依赖与 `scripts/install-claude-code.sh` 的一致性（已经在 Step 3.5 的内容里通过逐字复制保证）。

---

- [ ] **Step 7.7: 入口文档表格双列**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite
grep -cE "中文.*English|中文（默认）.*English|中文 \(default\)" INSTALL.md README.md README.en.md
```

Expected: 三个文件都 ≥ 1。

---

- [ ] **Step 7.8: 与 spec 的 jq 表达式一致性检查**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite

# 提取 install-claude-code.sh 的注册 jq 表达式（约 lines 106-113）
sed -n '/jq --arg cmd/,/" "\$SETTINGS"/p' scripts/install-claude-code.sh > /tmp/sh-jq.txt

# 同样的 jq 表达式应在 claude-code.md 与 claude-code.en.md 中各出现一次
for f in install/claude-code.md install/claude-code.en.md; do
  echo "--- $f ---"
  grep -A 8 "jq --arg cmd" "$f" | head -n 12
done
echo "--- scripts/install-claude-code.sh ---"
cat /tmp/sh-jq.txt
rm -f /tmp/sh-jq.txt
```

Expected: 三段 jq 表达式（两份 markdown + 一份 shell）在 `.hooks //= {}` / `.hooks.SessionStart //= []` / `.hooks.SessionStart += [...]` 三行上**逐字一致**。差异 = bug，立即修。

---

## Task 8: 完成总结 + 等用户决定 commit

**Files:** 无（汇报）

**目标**：按 CLAUDE.md 规则，本计划**不**自动 commit。整理本次变更，向用户汇报，等用户明确说"提交"再做。

---

- [ ] **Step 8.1: 列出本次所有改动**

Run:

```bash
cd /Users/mini/Documents/dev/superpowers-lite
git status --short
```

Expected：
- 新增 (`??`)：`install/claude-code.en.md`、`install/opencode.en.md`、`install/codex.en.md`、`install/gemini-cli.en.md`、`install/cursor.en.md`、`docs/superpowers/plans/2026-05-13-install-bilingual-and-hook.md`（本计划本身）、`docs/superpowers/specs/2026-05-13-install-bilingual-and-hook-design.md`（spec 自身）
- 修改 (`M`)：`INSTALL.md`、`README.md`、`README.en.md`、`install/claude-code.md`、`install/opencode.md`、`install/codex.md`、`install/gemini-cli.md`、`install/cursor.md`

---

- [ ] **Step 8.2: 汇报给用户**

输出格式参考：

```
✅ 双语安装链接 + Claude Code Hook 同步 — 实施完成

新增 5 份英文版 installer：
- install/claude-code.en.md（含 hook 步骤）
- install/opencode.en.md
- install/codex.en.md
- install/gemini-cli.en.md
- install/cursor.en.md

修改 8 份既有文件（去掉"问语言"、claude-code 加 hook、3 个入口文档表格双列化）。

静态检查全通过：
- 所有 .en.md 都指向 skills-en，所有 .md 指向 skills
- 没有任何"Ask the user which language"残留
- Claude Code 的两份都含 Install SessionStart hook step
- bash 片段语法 OK
- jq 表达式与 scripts/install-claude-code.sh 一致

下一步：
- 想 commit 请说"commit"或"提交"，我会按 ~/.claude/rules/zh/git-workflow.md
  的格式生成一条 feat: 提交（含完整改动清单）。
- 想再做端到端验证（spec §8 第 1–5 项）请说"跑 e2e"——
  我会在临时目录跑实际 install 流程。
```

> **本步骤不执行 git 操作**——只是汇报。等用户回复后再决定下一步动作。

---

## 自审记录

写完计划后做了 3 项自审：

1. **Spec 覆盖：**
   - spec §2 双链接架构 → Tasks 1-6 覆盖
   - spec §3 install/*.md 改造 → Tasks 1-4 覆盖
   - spec §4 hook 步骤 → Task 3 Step 3.5 + Task 4
   - spec §5 INSTALL.md → Task 5
   - spec §6 文件清单（含 README.md/README.en.md）→ Task 6
   - spec §7 维护条款 → 不需要任务（是文档说明）
   - spec §8 验证计划 → Task 7（静态部分） + 留口子给用户做 e2e
   - spec §9 风险与缓解 → 已通过具体步骤设计降低
   - spec §10 实施顺序 → 本计划任务顺序就是 spec §10 推荐顺序

2. **占位符扫描：** 无 TBD/TODO/"implement later"。Task 7 Step 7.6 注释里有"如果是这个问题，单独提取 Step 4"——给出了应对策略，不是占位符。

3. **类型一致性：**
   - `SKILL_SRC=skills` / `SKILL_SRC=skills-en` 在所有 Task 中拼写一致
   - `HOOK_DEST` / `SETTINGS` 变量名 = `scripts/install-claude-code.sh` 中的命名
   - 步骤编号顺延一致：Step 3.2/3.3/3.4 把 Verify/Report/Cleanup 从 4/5/6 改成 5/6/7，Step 3.5 在 Step 5 之前插入 Step 4——序列闭合
