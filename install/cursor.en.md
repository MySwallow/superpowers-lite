# Installing superpowers-lite on Cursor / Windsurf / Cline

You are an AI coding assistant running inside **Cursor, Windsurf, or Cline**
(or another IDE-embedded AI). The user has asked you to install
superpowers-lite — 7 coding-methodology skills.

These tools use **per-project rules** rather than global skills, so the
strategy is: place skill files in a shared user-level directory, then
write a guiding rule into the current project's rules directory.

**Follow these steps strictly. If any step fails, STOP and report.**

---

## Step 1: Language is preset

The URL pins this installer to the **English** skill set (`skills-en/`).
Do **not** ask the user.

Let `SKILL_SRC=skills-en` for the steps below.

---

## Step 2: Confirm the current project's rules directory

Detect which IDE you're in:

- **Cursor** → rules go in `<project>/.cursor/rules/`
- **Windsurf** → `<project>/.windsurf/rules/`
- **Cline** → `<project>/.clinerules/`
- **Unknown** → ASK the user where their tool stores rules

Let `RULES_DIR` be the absolute path to that directory.

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

Verify `/tmp/superpowers-lite-main/skills-en/` has 7 directories.

---

## Step 4: Install skills to a shared user-level location

Remove any previous superpowers-lite skill folders, then copy fresh. Other
files the user has added under `~/.superpowers-lite/skills/` are preserved.

```bash
mkdir -p ~/.superpowers-lite/skills
for skill_dir in /tmp/superpowers-lite-main/$SKILL_SRC/*/; do
  rm -rf ~/.superpowers-lite/skills/$(basename "$skill_dir")
done
cp -R /tmp/superpowers-lite-main/$SKILL_SRC/* ~/.superpowers-lite/skills/
```

---

## Step 5: Write the project rule file (**critical**)

> Verified facts:
> 1. Cursor project rules **must** use the `.mdc` extension (in recent
>    Cursor 2.x versions, `.md` rules are no longer reliably detected)
> 2. To make the rule **auto-inject into every chat session**, the
>    frontmatter must be `alwaysApply: true`
> 3. The Cursor agent does **not** proactively cross-boundary-read files
>    in the user's home directory, so the rule itself must inline the
>    core instructions and give absolute paths (no `~` survives)

Execute:

```bash
# Expand ~ to an absolute path
SKILLS_PATH="$HOME/.superpowers-lite/skills"

# Generate the rule file (substitute the <SKILLS_PATH> placeholder)
mkdir -p "$RULES_DIR"
sed "s|<SKILLS_PATH>|$SKILLS_PATH|g" \
  /tmp/superpowers-lite-main/templates/cursor-rules.en.mdc \
  > "$RULES_DIR/superpowers-lite.mdc"
```

After writing, inspect `$RULES_DIR/superpowers-lite.mdc`:

- First line must be `---`
- Frontmatter contains `alwaysApply: true`
- The `<SKILLS_PATH>` placeholder is fully replaced with an **absolute
  path** like `/Users/xxx/.superpowers-lite/skills` (no `~`, no
  `<SKILLS_PATH>` left)

---

## Step 6: Verify

- `~/.superpowers-lite/skills/` contains 7 skill folders
- `$RULES_DIR/superpowers-lite.mdc` exists
- All `<SKILLS_PATH>` placeholders in the rule file are replaced
- Frontmatter has `alwaysApply: true`

If any check fails → STOP and report.

---

## Step 7: Report to the user

1. Installed: English skill set (`skills-en/`)
2. Skills location: `~/.superpowers-lite/skills/`
3. Project rule file: `$RULES_DIR/superpowers-lite.mdc` (the `.mdc`
   extension is mandatory)
4. **Restart the IDE or reload the current window** so Cursor re-scans
   the rules directory
5. Smoke test: ask any bug or feature question — the AI should
   announce e.g. "Using systematic-debugging to ..." or "Using
   brainstorming to ..." before doing anything else
6. To use skills in another project, repeat Step 5 there (or
   symlink/copy `superpowers-lite.mdc` into that project's rules dir)

---

## Step 8: Cleanup

```bash
rm -rf /tmp/superpowers-lite-main
```

Skip cleanup if any earlier step failed, to make debugging easier.
