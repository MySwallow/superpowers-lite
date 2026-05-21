# Installing superpowers-lite on Cline

You are an AI coding assistant running inside **Cline** (VS Code
extension, 3.49.0+). The user has asked you to install superpowers-lite
— 7 coding-methodology skills.

Cline natively supports SKILL.md (experimental feature). We install into
Cline's official **user-level** directory `~/.cline/skills/` — install
once, available across all projects.

**Follow these steps strictly. If any step fails, STOP and report.**

> Cline version required: **3.49.0 or newer**. Older versions do not
> support Skills.

---

## Step 1: Language is preset

The URL pins this installer to the **English** skill set (`skills-en/`).
Do **not** ask the user.

Let `SKILL_SRC=skills-en` for the steps below.

---

## Step 2: (Optional) Clean up legacy bad installs

If the user previously ran the v1 installer (which incorrectly used
`~/.superpowers-lite/skills/` + rules files), clean them up first:

```bash
rm -rf ~/.superpowers-lite
rm -f .clinerules/superpowers-lite.mdc .clinerules/superpowers-lite.md
```

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

---

## Step 4: Enable Skills in Cline (if not already)

Skills are **still experimental** in Cline and disabled by default. Tell
the user to:

1. Open the Cline panel in VS Code
2. `Settings → Features`
3. Check `Enable Skills`
4. A "Skills" tab appears under the chat input

If skipped, even installed skills won't activate.

---

## Step 5: Install to Cline's user-level skills directory

Cline's docs explicitly scan `~/.cline/skills/`:

```bash
mkdir -p ~/.cline/skills
for skill_dir in /tmp/superpowers-lite-main/$SKILL_SRC/*/; do
  rm -rf ~/.cline/skills/$(basename "$skill_dir")
done
cp -R /tmp/superpowers-lite-main/$SKILL_SRC/* ~/.cline/skills/
```

---

## Step 6: Verify

```bash
ls ~/.cline/skills/
```

You must see 7 directories, each containing a `SKILL.md`. Then check the
Cline panel's "Skills" tab to confirm the 7 skills appear.

---

## Step 7: Report to the user

1. Installed: English skill set (`skills-en/`), all 7 skills in place
2. Location: `~/.cline/skills/` (Cline user-level, global)
3. Must enable `Features → Enable Skills` in Cline settings (if not done)
4. **Restart VS Code** or reopen the Cline panel so it re-scans skills
5. Cline Agent auto-decides usage based on `description`; you can also
   manually toggle skills in the Skills tab
6. **To upgrade later**: just re-run this installer URL

---

## Step 8: Cleanup temp files

```bash
rm -rf /tmp/superpowers-lite-main
```

Skip cleanup if any earlier step failed, to ease debugging.
