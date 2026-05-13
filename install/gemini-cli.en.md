# Installing superpowers-lite on Gemini CLI

You are an AI coding assistant running inside **Gemini CLI**. The user has
asked you to install superpowers-lite — 7 coding-methodology skills.

**There are two paths.** Recommend the native extension to the user first
(it's a single shell command). Only use the manual install if they want it.

---

## Path A (recommended): native extension

Tell the user to exit this session and run **in their terminal**:

```bash
gemini extensions install https://github.com/MySwallow/superpowers-lite
```

This installs superpowers-lite as a Gemini extension. It uses
`gemini-extension.json` and the repo's root `GEMINI.md`, which loads
`using-superpowers/SKILL.md` automatically. After install, restart Gemini.

If the user is happy with Path A, you are done. Stop here.

---

## Path B (manual, only if user opts out of Path A)

### Step 1: Language is preset

This installer uses the **English** skill set (`skills-en/`). The language is
fixed by the URL the user picked — do **not** ask them.

Let `SKILL_SRC=skills-en` for the steps below.

### Step 2: Download

```bash
curl -fsSL https://github.com/MySwallow/superpowers-lite/archive/refs/heads/main.tar.gz \
  | tar xz -C /tmp/
```

Fallback if `curl`/`tar` is missing:

```bash
git clone --depth=1 https://github.com/MySwallow/superpowers-lite.git /tmp/superpowers-lite-main
```

Verify `/tmp/superpowers-lite-main/skills/` has 7 directories.

### Step 3: Install skills

Remove any previous superpowers-lite skill folders, then copy fresh. This
preserves any other files the user has added under `~/.superpowers-lite/skills/`.

```bash
mkdir -p ~/.superpowers-lite/skills
for skill_dir in /tmp/superpowers-lite-main/$SKILL_SRC/*/; do
  rm -rf ~/.superpowers-lite/skills/$(basename "$skill_dir")
done
cp -R /tmp/superpowers-lite-main/$SKILL_SRC/* ~/.superpowers-lite/skills/
```

### Step 4: Wire up GEMINI.md

Read `/tmp/superpowers-lite-main/templates/GEMINI.md`. Replace every
`<SKILLS_PATH>` placeholder with the absolute path
`~/.superpowers-lite/skills` (expand `~` to the user's home dir).

Append the resulting content to `~/.gemini/GEMINI.md`. Create the file and
parent directory if needed. If the file already has a superpowers-lite
section, replace it rather than duplicating.

### Step 5: Verify

`~/.superpowers-lite/skills/` should contain 7 skill folders. `~/.gemini/GEMINI.md`
should reference superpowers-lite. If not, STOP and report.

### Step 6: Report

Tell the user the install path, the GEMINI.md update, and to restart Gemini
to pick up the new context.

### Step 7: Cleanup

```bash
rm -rf /tmp/superpowers-lite-main
```

Skip cleanup if any step failed.
