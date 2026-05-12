#!/usr/bin/env bash
# Install agent-skills into ~/.claude/skills/ (Claude Code user scope)
#
# Usage:
#   ./install-claude-code.sh              # install Chinese skills (default)
#   ./install-claude-code.sh --lang en    # install English skills
#   ./install-claude-code.sh --lang zh    # explicit Chinese (same as default)
#   ./install-claude-code.sh --uninstall  # remove installed skills

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$HOME/.claude/skills"
LANG_DIR="skills"
ACTION="install"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --lang)
      shift
      case "${1:-zh}" in
        zh) LANG_DIR="skills" ;;
        en) LANG_DIR="skills-en" ;;
        *) echo "Unknown language: $1. Use 'en' or 'zh'." >&2; exit 1 ;;
      esac
      shift
      ;;
    --uninstall)
      ACTION="uninstall"
      shift
      ;;
    --help|-h)
      grep '^#' "$0" | sed 's/^# \?//'
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

SKILLS_SRC="$REPO_ROOT/$LANG_DIR"

if [[ ! -d "$SKILLS_SRC" ]]; then
  echo "Skills directory not found: $SKILLS_SRC" >&2
  exit 1
fi

mkdir -p "$DEST"

SKILL_NAMES=(
  brainstorming
  dispatching-parallel-agents
  executing-plans
  subagent-driven-development
  systematic-debugging
  using-superpowers
  writing-plans
)

if [[ "$ACTION" == "uninstall" ]]; then
  for name in "${SKILL_NAMES[@]}"; do
    if [[ -d "$DEST/$name" ]]; then
      rm -rf "$DEST/$name"
      echo "✘ removed $DEST/$name"
    fi
  done
  echo ""
  echo "Uninstalled. Restart Claude Code to apply."
  exit 0
fi

echo "Installing skills from: $SKILLS_SRC"
echo "Into:                   $DEST"
echo ""

for name in "${SKILL_NAMES[@]}"; do
  if [[ -d "$DEST/$name" ]]; then
    echo "⚠  $name already exists — overwriting"
    rm -rf "$DEST/$name"
  fi
  cp -R "$SKILLS_SRC/$name" "$DEST/"
  echo "✔ installed $name"
done

echo ""
echo "Done. Restart Claude Code to load the skills."
echo "Tip: run 'claude plugin disable superpowers@claude-plugins-official'"
echo "     if you have the upstream plugin installed (to avoid duplicates)."
