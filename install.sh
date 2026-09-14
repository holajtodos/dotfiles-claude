#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Link this repo's Claude Code configuration into ~/.claude. Every portable
# file becomes a symlink into the repo, so edits in either place are one edit;
# whatever was there before is moved aside, never deleted.
#
# Inputs:
#   claude/CLAUDE.md, claude/rules/, claude/agent-workflow.md,
#   claude/settings.json, claude/statusline-command.sh, claude/skills/<name>/
#   machine.example.md – template for the untracked claude/rules/00-machine.md
# Output:
#   symlinks under $CLAUDE_CONFIG_DIR (default ~/.claude)
#   displaced originals under ~/.claude/backups-dotfiles/<timestamp>/
# Usage:
#   ./install.sh             # link everything
#   ./install.sh --dry-run   # print what would change
# ----------------------------------------------------------------------
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
BACKUP="$CLAUDE_DIR/backups-dotfiles/$(date +%Y%m%dT%H%M%S)"
DRY=0
[ "${1:-}" = "--dry-run" ] && DRY=1

# Print an action, and run it unless this is a dry run
run() { echo "  $*"; [ "$DRY" = 1 ] || "$@"; }

# Symlink $2 -> $1, moving any existing non-matching entry into the backup dir
link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "  ok       $dst"; return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    run mkdir -p "$BACKUP"
    run mv "$dst" "$BACKUP/$(basename "$dst")"
  fi
  run mkdir -p "$(dirname "$dst")"
  run ln -s "$src" "$dst"
}

# ---- Per-host machine file ----
if [ ! -e "$DOTFILES/claude/rules/00-machine.md" ]; then
  run cp "$DOTFILES/machine.example.md" "$DOTFILES/claude/rules/00-machine.md"
  echo "  EDIT     $DOTFILES/claude/rules/00-machine.md for this host"
fi

# ---- Links ----
echo "Linking into $CLAUDE_DIR"
link "$DOTFILES/claude/CLAUDE.md"             "$CLAUDE_DIR/CLAUDE.md"
link "$DOTFILES/claude/rules"                 "$CLAUDE_DIR/rules"
link "$DOTFILES/claude/agent-workflow.md"     "$CLAUDE_DIR/agent-workflow.md"
link "$DOTFILES/claude/settings.json"         "$CLAUDE_DIR/settings.json"
link "$DOTFILES/claude/statusline-command.sh" "$CLAUDE_DIR/statusline-command.sh"
for skill in "$DOTFILES"/claude/skills/*/; do
  link "${skill%/}" "$CLAUDE_DIR/skills/$(basename "$skill")"
done

[ -d "$BACKUP" ] && echo "Displaced originals: $BACKUP"
echo "Next: start claude once (installs the plugins named in settings.json), then claude login."
