# Installing superpowers-lite on GitHub Copilot CLI

You are an AI coding assistant running inside **GitHub Copilot CLI**.
The user has asked you to install superpowers-lite — 7
coding-methodology skills.

GitHub Copilot CLI natively supports the SKILL.md format (the same
Anthropic standard Claude Code uses). We install into Copilot's official
**personal** directory `~/.copilot/skills/` — install once, available
across all projects.

**Follow these steps strictly. If any step fails, STOP and report.**

---

## Step 1: Language is preset

The URL pins this installer to the **English** skill set (`skills-en/`).
Do **not** ask the user.

Let `SKILL_SRC=skills-en` for the steps below.

---

## Step 2: Download the repository

```bash
curl -fsSL https://github.com/MySwallow/superpowers-lite/archive/refs/heads/main.tar.gz \
  | tar xz -C /tmp/
```

Or:

```bash
git clone --depth=1 https://github.com/MySwallow/superpowers-lite.git /tmp/superpowers-lite-main
```

Verify `/tmp/superpowers-lite-main/skills-en/` contains **7
directories**. Otherwise STOP and report.

---

## Step 3: Install to Copilot's personal skills directory

Copilot CLI's docs explicitly scan `~/.copilot/skills/` (personal,
shared across projects):

```bash
mkdir -p ~/.copilot/skills
for skill_dir in /tmp/superpowers-lite-main/$SKILL_SRC/*/; do
  rm -rf ~/.copilot/skills/$(basename "$skill_dir")
done
cp -R /tmp/superpowers-lite-main/$SKILL_SRC/* ~/.copilot/skills/
```

> Alternative directory: `~/.agents/skills/` is also recognized by
> Copilot. If the user already standardises on `~/.agents/` (e.g. to
> share skills across multiple agent tools), substitute
> `~/.copilot/skills` with `~/.agents/skills`.

---

## Step 4: Verify

```bash
ls ~/.copilot/skills/
```

You must see **7 directories**, each containing a `SKILL.md`. Print the
folder names to the user. If the count is not 7, STOP and report.

If the user is already inside a Copilot CLI session, ask them to run:

```
/skills reload
```

Copilot re-scans the skills directory and loads the new content. Then:

```
/skills
```

to confirm the 7 skills show up in the list.

---

## Step 5: Report to the user

1. Installed: English skill set (`skills-en/`), all 7 skills in place
2. Location: `~/.copilot/skills/` (Copilot CLI personal, global)
3. If they are inside a current Copilot CLI session, run
   `/skills reload`; otherwise the next launch auto-scans
4. Copilot Agent auto-decides usage based on `description`; users can
   also prompt explicitly ("use the brainstorming skill") to trigger
5. **To upgrade later**: just re-run this installer URL
6. Tool-name mapping (Claude Code → Copilot CLI equivalents) is in
   `~/.copilot/skills/using-superpowers/references/` — point Copilot
   at it when relevant

---

## Step 6: Cleanup

```bash
rm -rf /tmp/superpowers-lite-main
```

Skip cleanup if any earlier step failed, to ease debugging.
