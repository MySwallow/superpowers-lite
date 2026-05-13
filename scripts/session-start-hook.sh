#!/usr/bin/env bash
# superpowers-lite SessionStart hook for Claude Code.
#
# Reads ~/.claude/skills/using-superpowers/SKILL.md and emits the JSON
# Claude Code expects for the SessionStart hook — the SKILL.md content
# is injected into the session as additional system context, primes the
# model to check skills before responding.
#
# Outputs an empty JSON object if the skill isn't installed yet (don't
# break Claude Code's startup).

set -euo pipefail

SKILL_FILE="${HOME}/.claude/skills/using-superpowers/SKILL.md"

if [[ ! -f "$SKILL_FILE" ]]; then
  echo '{}'
  exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
  # jq isn't available; emit empty rather than malformed JSON.
  echo '{}'
  exit 0
fi

SKILL_CONTENT="$(cat "$SKILL_FILE")"

CONTEXT="<EXTREMELY_IMPORTANT>
You have superpowers-lite skills installed. Below is the full content of your
'using-superpowers' skill — your introduction to using skills. For all other
skills, use the 'Skill' tool when relevant.

${SKILL_CONTENT}
</EXTREMELY_IMPORTANT>"

jq -n --arg ctx "$CONTEXT" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: $ctx
  }
}'
