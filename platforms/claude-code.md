# Install on Claude Code

## Quick install (English skills)

```bash
git clone https://github.com/MySwallow/agent-skills.git
cd agent-skills
./scripts/install-claude-code.sh
```

## Quick install (Chinese skills)

```bash
./scripts/install-claude-code.sh --lang zh
```

## Manual install

Copy any skill folder into `~/.claude/skills/`:

```bash
cp -R skills/systematic-debugging ~/.claude/skills/
cp -R skills/writing-plans       ~/.claude/skills/
# ... etc
```

Skills are auto-discovered from `~/.claude/skills/` on next session start.

## Verify

```bash
claude  # start a new session
# Then use /context to see loaded skills
```

You should see your installed skills in the output. To remove one:

```bash
rm -rf ~/.claude/skills/<skill-name>
```

## Uninstall

```bash
./scripts/install-claude-code.sh --uninstall
```

## Coexistence with the original superpowers plugin

If you have the upstream `superpowers` plugin installed, you'll see two copies of each skill (one prefixed `superpowers:`, one without). To avoid duplication, disable the plugin:

```bash
claude plugin disable superpowers@claude-plugins-official
```

The user-scope copies in `~/.claude/skills/` take over.
