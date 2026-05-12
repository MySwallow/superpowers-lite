---
name: using-superpowers
description: Use when starting any conversation - establishes how to find and use skills before responding
---

<SUBAGENT-STOP>
If you were dispatched as a subagent for a specific task, skip this skill.
</SUBAGENT-STOP>

# Using Skills

## Core Rule

Before responding to a user message, check if any available skill applies.
If yes, invoke it via the Skill tool BEFORE producing any other output
(including clarifying questions). Announce briefly: "Using [skill] to [purpose]".

```dot
digraph skill_flow {
    "User message received" [shape=doublecircle];
    "About to EnterPlanMode?" [shape=doublecircle];
    "Already brainstormed?" [shape=diamond];
    "Invoke brainstorming skill" [shape=box];
    "Might any skill apply?" [shape=diamond];
    "Invoke Skill tool" [shape=box];
    "Announce: 'Using [skill] to [purpose]'" [shape=box];
    "Has checklist?" [shape=diamond];
    "Create TodoWrite todo per item" [shape=box];
    "Follow skill exactly" [shape=box];
    "Respond (including clarifications)" [shape=doublecircle];

    "About to EnterPlanMode?" -> "Already brainstormed?";
    "Already brainstormed?" -> "Invoke brainstorming skill" [label="no"];
    "Already brainstormed?" -> "Might any skill apply?" [label="yes"];
    "Invoke brainstorming skill" -> "Might any skill apply?";

    "User message received" -> "Might any skill apply?";
    "Might any skill apply?" -> "Invoke Skill tool" [label="yes, even 1%"];
    "Might any skill apply?" -> "Respond (including clarifications)" [label="definitely not"];
    "Invoke Skill tool" -> "Announce: 'Using [skill] to [purpose]'";
    "Announce: 'Using [skill] to [purpose]'" -> "Has checklist?";
    "Has checklist?" -> "Create TodoWrite todo per item" [label="yes"];
    "Has checklist?" -> "Follow skill exactly" [label="no"];
    "Create TodoWrite todo per item" -> "Follow skill exactly";
}
```

## How to Access Skills

Skills use Claude Code conventions by default. Each platform has its own way to access them:

- **Claude Code:** use the `Skill` tool. When invoked, the skill's content is loaded — follow it directly. Never use the Read tool on skill files.
- **GitHub Copilot CLI:** use the `skill` tool (same semantics as Claude Code's `Skill` tool).
- **Gemini CLI:** skills activate via `activate_skill`. Gemini loads metadata at session start and activates full content on demand.
- **Codex CLI / other platforms:** see `references/` in this folder for tool-name equivalents.

Generic fallback: read the SKILL.md content yourself and follow it as guidance.

## Instruction Priority (highest → lowest)

1. **User instructions** — CLAUDE.md, AGENTS.md, direct user requests
2. **Skills** — override default system behavior where conflicts arise
3. **Default system prompt**

If a user instruction contradicts a skill, follow the user. The user is in control.

## Red Flags — STOP if you think any of these

- "This is just a simple question" → questions are tasks, check for skills
- "I need more context first" → skill check comes BEFORE clarifying questions
- "Let me explore the codebase first" → skills tell you HOW to explore
- "This doesn't need a formal skill" → if a skill exists, use it
- "The skill is overkill" → simple things become complex
- "I know what that means" → knowing the concept ≠ using the skill
- "I'll just do this one thing first" → check BEFORE doing anything
