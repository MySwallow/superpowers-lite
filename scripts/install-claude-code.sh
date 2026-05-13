#!/usr/bin/env bash
# Install superpowers-lite into ~/.claude/skills/ (Claude Code user scope).
# Also registers a SessionStart hook that injects the using-superpowers
# skill into every new session — needed to keep skill trigger rates high.
#
# Usage:
#   ./install-claude-code.sh              # install Chinese skills (default)
#   ./install-claude-code.sh --lang en    # install English skills
#   ./install-claude-code.sh --lang zh    # explicit Chinese (same as default)
#   ./install-claude-code.sh --no-hook    # skip SessionStart hook install
#   ./install-claude-code.sh --uninstall  # remove skills + hook

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$HOME/.claude/skills"
LANG_DIR="skills"
ACTION="install"
INSTALL_HOOK=1

HOOK_SRC="$REPO_ROOT/scripts/session-start-hook.sh"
HOOK_DEST="$HOME/.claude/scripts/superpowers-lite-session-start.sh"
SETTINGS="$HOME/.claude/settings.json"

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
    --no-hook)
      INSTALL_HOOK=0
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

SKILL_NAMES=(
  brainstorming
  dispatching-parallel-agents
  executing-plans
  subagent-driven-development
  systematic-debugging
  using-superpowers
  writing-plans
)

# ---- Hook helpers ------------------------------------------------------------

require_jq() {
  if ! command -v jq >/dev/null 2>&1; then
    cat >&2 <<EOF
Error: \`jq\` is required to register the SessionStart hook.
Install it (\`brew install jq\` on macOS, \`apt-get install jq\` on Debian/Ubuntu)
or re-run with --no-hook to skip the hook registration.
EOF
    exit 1
  fi
}

install_hook() {
  require_jq

  mkdir -p "$(dirname "$HOOK_DEST")"
  cp "$HOOK_SRC" "$HOOK_DEST"
  chmod +x "$HOOK_DEST"
  echo "✔ hook script:  $HOOK_DEST"

  if [[ ! -f "$SETTINGS" ]]; then
    echo '{}' > "$SETTINGS"
  fi

  # Idempotent: skip if the same command is already registered.
  if jq -e --arg cmd "$HOOK_DEST" \
       '.hooks.SessionStart // [] | map(.hooks // [] | map(.command)) | flatten | index($cmd)' \
       "$SETTINGS" >/dev/null 2>&1; then
    echo "✔ hook already registered in $SETTINGS — skipping"
    return
  fi

  local tmp="$SETTINGS.tmp.$$"
  jq --arg cmd "$HOOK_DEST" '
    .hooks //= {} |
    .hooks.SessionStart //= [] |
    .hooks.SessionStart += [{
      "matcher": "startup|clear|compact",
      "hooks": [{"type": "command", "command": $cmd}]
    }]
  ' "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"

  echo "✔ hook registered in $SETTINGS"
}

uninstall_hook() {
  if [[ ! -f "$SETTINGS" ]]; then
    echo "(no $SETTINGS — nothing to clean)"
  elif ! command -v jq >/dev/null 2>&1; then
    echo "⚠  jq missing — leaving $SETTINGS alone. Remove the hook entry by hand."
  else
    local tmp="$SETTINGS.tmp.$$"
    jq --arg cmd "$HOOK_DEST" '
      if .hooks.SessionStart then
        .hooks.SessionStart |= (
          map(
            .hooks |= map(select(.command != $cmd))
          ) | map(select((.hooks // []) | length > 0))
        ) |
        if (.hooks.SessionStart | length) == 0 then del(.hooks.SessionStart) else . end
      else . end |
      if (.hooks // {}) == {} then del(.hooks) else . end
    ' "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
    echo "✘ hook entry removed from $SETTINGS"
  fi

  if [[ -f "$HOOK_DEST" ]]; then
    rm -f "$HOOK_DEST"
    echo "✘ removed $HOOK_DEST"
  fi
}

# ---- Uninstall ---------------------------------------------------------------

if [[ "$ACTION" == "uninstall" ]]; then
  for name in "${SKILL_NAMES[@]}"; do
    if [[ -d "$DEST/$name" ]]; then
      rm -rf "$DEST/$name"
      echo "✘ removed $DEST/$name"
    fi
  done
  uninstall_hook
  echo ""
  echo "Uninstalled. Restart Claude Code to apply."
  exit 0
fi

# ---- Install -----------------------------------------------------------------

mkdir -p "$DEST"

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
if [[ "$INSTALL_HOOK" == "1" ]]; then
  install_hook
  echo ""
fi

echo "Done. Restart Claude Code to load the skills."
echo "Tip: run 'claude plugin disable superpowers@claude-plugins-official'"
echo "     if you have the upstream plugin installed (to avoid duplicates)."
