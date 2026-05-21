# Installing superpowers-lite on Windsurf

You are an AI coding assistant running inside **Windsurf**. The user has
asked you to install superpowers-lite — 7 coding-methodology skills.

Windsurf natively supports SKILL.md (in Cascade mode). We install into
Windsurf's official **user-level** directory
`~/.codeium/windsurf/skills/` — install once, available across all
projects.

**Follow these steps strictly. If any step fails, STOP and report.**

---

## Step 1: Language is preset

The URL pins this installer to the **English** skill set (`skills-en/`).
Do **not** ask the user.

Let `SKILL_SRC=skills-en` for the steps below.

---

## Step 2: (Optional) Clean up legacy bad installs

If the user previously ran the older (v1) installer that incorrectly
placed skills under `~/.superpowers-lite/skills/` + project rules files,
clean them up first:

```bash
# Remove the old shared skills dir
rm -rf ~/.superpowers-lite

# Remove old rules files in the current project (if any)
rm -f .windsurf/rules/superpowers-lite.mdc .windsurf/rules/superpowers-lite.md
```

Non-existent paths are silently skipped by `rm -f` / `-rf` — safe to run.

---

## Step 3: Download the repository

```bash
curl -fsSL https://github.com/MySwallow/superpowers-lite/archive/refs/heads/main.tar.gz \
  | tar xz -C /tmp/
```

Or:

```bash
git clone --depth=1 https://github.com/MySwallow/superpowers-lite.git /tmp/superpowers-lite-main
```

Verify `/tmp/superpowers-lite-main/skills-en/` contains 7 directories.

---

## Step 4: Install to Windsurf's user-level skills directory

Windsurf's docs explicitly scan `~/.codeium/windsurf/skills/`:

```bash
mkdir -p ~/.codeium/windsurf/skills
for skill_dir in /tmp/superpowers-lite-main/$SKILL_SRC/*/; do
  rm -rf ~/.codeium/windsurf/skills/$(basename "$skill_dir")
done
cp -R /tmp/superpowers-lite-main/$SKILL_SRC/* ~/.codeium/windsurf/skills/
```

---

## Step 5: Verify

```bash
ls ~/.codeium/windsurf/skills/
```

You must see 7 directories (`brainstorming`, `dispatching-parallel-agents`,
`executing-plans`, `subagent-driven-development`, `systematic-debugging`,
`using-superpowers`, `writing-plans`), each containing a `SKILL.md`.

---

## Step 6: Report to the user

1. Installed: English skill set (`skills-en/`), all 7 skills in place
2. Location: `~/.codeium/windsurf/skills/` (Windsurf user-level, global)
3. **Restart Windsurf** or reload the window
4. Cascade auto-decides when to use each skill based on its
   `description`; you can also explicitly invoke `@skill-name` in chat
5. **To upgrade later**: just re-run this installer URL — Step 4
   wipes the 7 known folders before copying fresh

---

## Step 7: Cleanup temp files

```bash
rm -rf /tmp/superpowers-lite-main
```

Skip cleanup if any earlier step failed, to ease debugging.
