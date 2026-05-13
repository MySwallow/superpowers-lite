# Installing superpowers-lite on Cursor / Windsurf / Cline

You are an AI coding assistant running inside **Cursor, Windsurf, or Cline**
(or another IDE-embedded AI). The user has asked you to install
superpowers-lite — 7 coding-methodology skills.

These tools use **per-project rules**, not global ones, so installation
puts skills in a shared user-level location and wires them into the
current project's rules directory.

**Follow these steps strictly.** If any step fails, STOP and report.

---

## Step 1: Language is preset

This installer uses the **English** skill set (`skills-en/`). The language is
fixed by the URL the user picked — do **not** ask them.

Let `SKILL_SRC=skills-en` for the steps below.

---

## Step 2: Confirm the current project's rules directory

Detect which IDE you are in:

- **Cursor** → rules go in `<project>/.cursor/rules/`
- **Windsurf** → rules go in `<project>/.windsurf/rules/` (or similar)
- **Cline** → rules go in `<project>/.clinerules/` or via system prompt
- **Unknown** → ASK THE USER for the rules path their tool uses

Let `RULES_DIR` be the absolute path to that directory.

---

## Step 3: Download the repository

```bash
curl -fsSL https://github.com/MySwallow/superpowers-lite/archive/refs/heads/main.tar.gz \
  | tar xz -C /tmp/
```

Fallback if `curl`/`tar` is missing:

```bash
git clone --depth=1 https://github.com/MySwallow/superpowers-lite.git /tmp/superpowers-lite-main
```

Verify `/tmp/superpowers-lite-main/skills/` has 7 directories.

---

## Step 4: Install skills to a shared location

Remove any previous superpowers-lite skill folders, then copy fresh. This
preserves any other files the user has added under `~/.superpowers-lite/skills/`.

```bash
mkdir -p ~/.superpowers-lite/skills
for skill_dir in /tmp/superpowers-lite-main/$SKILL_SRC/*/; do
  rm -rf ~/.superpowers-lite/skills/$(basename "$skill_dir")
done
cp -R /tmp/superpowers-lite-main/$SKILL_SRC/* ~/.superpowers-lite/skills/
```

(Substitute `$SKILL_SRC` from Step 1.)

---

## Step 5: Wire up the project rules

Read `/tmp/superpowers-lite-main/templates/cursor-rules.md`. Replace every
`<SKILLS_PATH>` placeholder with the absolute path `~/.superpowers-lite/skills`
(expand `~` to the user's home dir).

Write the result to `$RULES_DIR/superpowers-lite.md` (or `skills.md` —
match the existing naming convention in `$RULES_DIR`). Create `$RULES_DIR`
if it doesn't exist.

---

## Step 6: Verify

- `~/.superpowers-lite/skills/` contains 7 skill folders
- `$RULES_DIR/superpowers-lite.md` exists and references the skills path

If not, STOP and report.

---

## Step 7: Report to the user

Tell the user:

1. Installed: English skill set (`skills-en/`)
2. Skills location: `~/.superpowers-lite/skills/`
3. Rules file added: `$RULES_DIR/superpowers-lite.md`
4. **Reload the project or restart the IDE** so rules pick up
5. If they want skills available in other projects too, they need to repeat
   Step 5 in each project (or symlink the rules file).

---

## Step 8: Cleanup

```bash
rm -rf /tmp/superpowers-lite-main
```

Skip cleanup if any step failed.
