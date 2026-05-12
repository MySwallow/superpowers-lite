# Use with Cursor, Windsurf, Cline, or any AI coding assistant

Status: 📄 Read as markdown — works with any AI assistant that can read text files.

## Approach: rules / system prompt reference

Most AI coding assistants (Cursor, Windsurf, Cline, Aider, etc.) support a "rules" or "system prompt" file. You can reference the skills from there.

### Example: Cursor

Add to `.cursor/rules/agent-skills.md`:

```markdown
# Agent Skills

When the user asks about debugging, planning, or implementing features, follow the methodology from `agent-skills/skills/`:

- For debugging: read `skills/systematic-debugging/SKILL.md`
- For planning: read `skills/writing-plans/SKILL.md`
- For brainstorming: read `skills/brainstorming/SKILL.md`
- For executing plans: read `skills/executing-plans/SKILL.md`
- For parallel agents: read `skills/dispatching-parallel-agents/SKILL.md`
- For meta orchestration: read `skills/using-superpowers/SKILL.md`
```

### Example: Windsurf / Cline

Similar approach — add a rules file pointing to the skills directory.

### Example: Aider

Use the `--read` flag at startup:

```bash
aider --read agent-skills/skills/using-superpowers/SKILL.md
```

## Tool-name caveats

The skills reference Claude Code tool names. Your assistant may have different tool names — adapt as you go, or fork the skills and rename tools to match your assistant.

## Verify

Trigger a skill condition (e.g., describe a bug and ask the assistant to fix it). The assistant should reference the systematic-debugging methodology.
