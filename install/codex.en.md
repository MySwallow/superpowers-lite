# Installing superpowers-lite on Codex CLI

You are an AI coding assistant running inside **Codex CLI**. The user has
asked you to install superpowers-lite — 7 coding-methodology skills.

**Follow these steps strictly.** Do not skip steps. Do not improvise commands.
If any step fails, STOP and report the exact failure to the user.

> **Note:** Codex has no standard global instructions file. This installer
> copies skill files to `~/.codex/skills/`, but the user will need to reference
> that path manually in their conversations (Codex does not auto-load it).

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

## Step 3: Install

Remove any previous superpowers-lite skill folders, then copy fresh. This
preserves any other personal skills the user has added under `~/.codex/skills/`.

```bash
mkdir -p ~/.codex/skills
for skill_dir in /tmp/superpowers-lite-main/$SKILL_SRC/*/; do
  rm -rf ~/.codex/skills/$(basename "$skill_dir")
done
cp -R /tmp/superpowers-lite-main/$SKILL_SRC/* ~/.codex/skills/
```

(Substitute `$SKILL_SRC` with the value from Step 1.)

---

## Step 4: Verify

List `~/.codex/skills/` and confirm **7 skill folders** are present, each
containing a `SKILL.md`. Print the folder names to the user.

If the count is not 7, STOP and report.

---

## Step 5: Report to the user

Tell the user:

1. Installed: English skill set (`skills-en/`)
2. Install path: `~/.codex/skills/`
3. Codex does not auto-discover skills. To use them, mention the path in
   your conversations. Example: "Use the skills at `~/.codex/skills/`. Start
   by reading `using-superpowers/SKILL.md`."
4. Tool-name mapping (Claude Code → Codex equivalents) is at
   `~/.codex/skills/using-superpowers/references/codex-tools.md` —
   point Codex at it when relevant.

---

## Step 6: Cleanup

```bash
rm -rf /tmp/superpowers-lite-main
```

Skip cleanup if any step failed — leave the temp dir for inspection.
