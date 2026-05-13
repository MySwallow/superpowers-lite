# Installing superpowers-lite on opencode

You are an AI coding assistant running inside **opencode**. The user has
asked you to install superpowers-lite — 7 coding-methodology skills.

**Follow these steps strictly.** Do not skip steps. Do not improvise commands.
If any step fails, STOP and report the exact failure to the user.

---

## Step 1: Language is preset

This installer uses the **English** skill set (`skills-en/`). The language is
fixed by the URL the user picked — do **not** ask them.

Let `SKILL_SRC=skills-en` for the steps below.

---

## Step 2: Download the repository

Run **exactly**:

```bash
curl -fsSL https://github.com/MySwallow/superpowers-lite/archive/refs/heads/main.tar.gz \
  | tar xz -C /tmp/
```

If `curl` or `tar` is missing, fall back to:

```bash
git clone --depth=1 https://github.com/MySwallow/superpowers-lite.git /tmp/superpowers-lite-main
```

Verify `/tmp/superpowers-lite-main/skills/` contains **7 directories**. If
not, STOP and report.

---

## Step 3: Install skills

opencode discovers personal skills from `~/.config/opencode/skills/`. Remove any
previous superpowers-lite skill folders first, then copy fresh. This preserves
any other personal skills the user has added there.

```bash
mkdir -p ~/.config/opencode/skills
for skill_dir in /tmp/superpowers-lite-main/$SKILL_SRC/*/; do
  rm -rf ~/.config/opencode/skills/$(basename "$skill_dir")
done
cp -R /tmp/superpowers-lite-main/$SKILL_SRC/* ~/.config/opencode/skills/
```

(Substitute `$SKILL_SRC` with the value from Step 1.)

---

## Step 4: Append the awareness hint to AGENTS.md

Read `/tmp/superpowers-lite-main/templates/AGENTS.md`. Replace every
`<SKILLS_PATH>` placeholder with the absolute path `~/.config/opencode/skills`
(expand `~` to the user's home directory).

Append the resulting content to `~/.config/opencode/AGENTS.md`. Create the
file (and parent directory) if it doesn't exist. If the file already
contains a superpowers-lite section, replace it rather than appending again.

---

## Step 5: Verify

List `~/.config/opencode/skills/` and confirm **7 skill folders** are
present, each containing a `SKILL.md`. Confirm `~/.config/opencode/AGENTS.md`
exists and contains a reference to `superpowers-lite`.

If verification fails, STOP and report.

---

## Step 6: Report to the user

Tell the user, in plain language:

1. Installed: English skill set (`skills-en/`)
2. Install path: `~/.config/opencode/skills/`
3. AGENTS.md was updated at: `~/.config/opencode/AGENTS.md`
4. **Restart opencode** to load the new skills
5. Example trigger to confirm: ask "let's brainstorm a new feature" — the
   `brainstorming` skill should activate.

---

## Step 7: Cleanup

```bash
rm -rf /tmp/superpowers-lite-main
```

Skip cleanup if any step failed — leave the temp dir for inspection.
