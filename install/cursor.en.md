# Installing superpowers-lite on Cursor

You are an AI coding assistant running inside **Cursor** (2.4+). The user
has asked you to install superpowers-lite — 7 coding-methodology skills.

Cursor 2.4 (released 2026-01-23) natively supports Agent Skills via
SKILL.md files. We install into Cursor's official **user-level**
directory `~/.cursor/skills/` — install once, available across all
projects.

**Follow these steps strictly. If any step fails, STOP and report.**

> Cursor version required: **2.4 or newer**.
> Older versions (≤ 2.3) do not support Agent Skills — the user must
> upgrade Cursor first. If unsure, the user can check `Help → About`.

---

## Step 1: Language is preset

The URL pins this installer to the **English** skill set (`skills-en/`).
Do **not** ask the user.

Let `SKILL_SRC=skills-en` for the steps below.

---

## Step 2: (Optional) Clean up legacy bad installs

If the user previously ran the v1 installer (which incorrectly used
`~/.superpowers-lite/skills/` + `.cursor/rules/superpowers-lite.{md,mdc}`),
clean them up. This step **only cleans the current project's** rules
file — if the user installed in other projects too, they'll need to
delete `.cursor/rules/superpowers-lite.*` in each one manually.

```bash
# Old shared skills dir (if any)
rm -rf ~/.superpowers-lite

# Old rule file in the current project (if any)
rm -f .cursor/rules/superpowers-lite.mdc .cursor/rules/superpowers-lite.md
```

Non-existent paths are silently skipped — safe to run.

---

## Step 3: Download the repository

```bash
curl -fsSL https://github.com/MySwallow/superpowers-lite/archive/refs/heads/main.tar.gz \
  | tar xz -C /tmp/
```

Fallback if `curl` / `tar` is missing:

```bash
git clone --depth=1 https://github.com/MySwallow/superpowers-lite.git /tmp/superpowers-lite-main
```

Verify `/tmp/superpowers-lite-main/skills-en/` contains 7 directories.

---

## Step 4: Install to Cursor's user-level skills directory

Cursor's docs explicitly scan `~/.cursor/skills/` (user-level, available
globally). Remove any previous superpowers-lite skill folders first, then
copy fresh — other files the user has added under `~/.cursor/skills/`
are preserved.

```bash
mkdir -p ~/.cursor/skills
for skill_dir in /tmp/superpowers-lite-main/$SKILL_SRC/*/; do
  rm -rf ~/.cursor/skills/$(basename "$skill_dir")
done
cp -R /tmp/superpowers-lite-main/$SKILL_SRC/* ~/.cursor/skills/
```

---

## Step 5: Verify

```bash
ls ~/.cursor/skills/
```

You must see 7 directories:

```
brainstorming
dispatching-parallel-agents
executing-plans
subagent-driven-development
systematic-debugging
using-superpowers
writing-plans
```

Each directory must contain a `SKILL.md` file (frontmatter with `name` +
`description`). If fewer than 7 or any `SKILL.md` is missing, STOP and
report.

---

## Step 6: Report to the user

1. Installed: English skill set (`skills-en/`), all 7 skills in place
2. Location: `~/.cursor/skills/` (Cursor user-level directory, global)
3. **Restart Cursor** (or `Cmd+Shift+P → Developer: Reload Window`) so
   Cursor re-scans the skills directory
4. Verify loaded: open `Cursor Settings` (Mac: `Cmd+Shift+J` / Win/Linux:
   `Ctrl+Shift+J`) → `Rules` → 7 skills should appear in the
   "**Agent Decides**" section
5. Also try typing `/` in the chat — you should see the skills listed
   (e.g. `/using-superpowers`)
6. Skills auto-trigger via Cursor Agent based on their `description`, or
   you can explicitly invoke `/skill-name`

---

## Step 7: Cleanup temp files

```bash
rm -rf /tmp/superpowers-lite-main
```

Skip cleanup if any earlier step failed, to ease debugging.

---

## Troubleshooting

- **Settings → Rules shows no skills** → check Cursor version is ≥ 2.4
  (`Help → About`). Skills are unsupported below 2.4.
- **Skills installed but Agent doesn't auto-use them** → this is expected:
  Cursor's "Agent Decides" mode picks based on description relevance.
  Try explicit `/using-superpowers` in chat to confirm loading.
- **To upgrade** → just re-run this installer URL. Step 4 wipes the 7
  known skill folders before copying fresh, so any other skill the user
  added under `~/.cursor/skills/` is preserved.
- **Full uninstall** → remove both the current install and any v1 leftovers:
  ```bash
  # New install (the 7 superpowers-lite skills under ~/.cursor/skills/)
  rm -rf ~/.cursor/skills/{brainstorming,dispatching-parallel-agents,executing-plans,subagent-driven-development,systematic-debugging,using-superpowers,writing-plans}
  # Legacy v1 leftovers (if any)
  rm -rf ~/.superpowers-lite
  rm -f .cursor/rules/superpowers-lite.mdc .cursor/rules/superpowers-lite.md
  ```
