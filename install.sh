#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_NAME="solana-rpc-cost-guard"
CLAUDE_DIR="$HOME/.claude"
INSTALL_PATH="$CLAUDE_DIR/skills/$SKILL_NAME"
FORCE=false
DRY_RUN=false
SKILL_ONLY=false

usage() {
  cat <<'EOF'
Solana RPC Cost Guard Skill installer

Usage:
  ./install.sh [--project] [--path PATH] [--force] [--dry-run] [--skill-only]

Options:
  --project     Install to ./.claude/skills/solana-rpc-cost-guard
  --path PATH   Install to a custom skill path
  --force       Replace an existing installation at the destination
  --dry-run     Print what would happen without copying files
  --skill-only  Install only skill/ and skip agents, commands, and rules
  -h, --help    Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      CLAUDE_DIR=".claude"
      INSTALL_PATH="$CLAUDE_DIR/skills/$SKILL_NAME"
      shift
      ;;
    --path)
      if [[ $# -lt 2 ]]; then
        echo "Error: --path requires a value" >&2
        exit 1
      fi
      INSTALL_PATH="$2"
      parent_dir="$(dirname "$INSTALL_PATH")"
      if [[ "$(basename "$parent_dir")" == "skills" ]]; then
        CLAUDE_DIR="$(dirname "$parent_dir")"
      else
        CLAUDE_DIR="$(dirname "$INSTALL_PATH")"
        SKILL_ONLY=true
      fi
      shift 2
      ;;
    --force)
      FORCE=true
      shift
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --skill-only)
      SKILL_ONLY=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ ! -f "$SCRIPT_DIR/skill/SKILL.md" ]]; then
  echo "Error: expected skill/SKILL.md next to install.sh" >&2
  exit 1
fi

echo "Installing $SKILL_NAME"
echo "Skill destination: $INSTALL_PATH"
if [[ "$SKILL_ONLY" != true ]]; then
  echo "Agent destination: $CLAUDE_DIR/agents/rpc-cost-architect.md"
  echo "Command destination: $CLAUDE_DIR/commands/"
  echo "Rules destination: $CLAUDE_DIR/rules/"
fi

if [[ "$DRY_RUN" == true ]]; then
  exit 0
fi

if [[ -e "$INSTALL_PATH" && "$FORCE" != true ]]; then
  echo "Error: destination already exists. Re-run with --force to replace it." >&2
  exit 1
fi

mkdir -p "$(dirname "$INSTALL_PATH")"
if [[ -e "$INSTALL_PATH" ]]; then
  rm -rf "$INSTALL_PATH"
fi

cp -R "$SCRIPT_DIR/skill" "$INSTALL_PATH"
echo "Installed skill to $INSTALL_PATH"

if [[ "$SKILL_ONLY" == true ]]; then
  exit 0
fi

mkdir -p "$CLAUDE_DIR/agents" "$CLAUDE_DIR/commands" "$CLAUDE_DIR/rules"

cp "$SCRIPT_DIR/agents/rpc-cost-architect.md" "$CLAUDE_DIR/agents/rpc-cost-architect.md"
cp "$SCRIPT_DIR/commands/rpc-cost-review.md" "$CLAUDE_DIR/commands/rpc-cost-review.md"
cp "$SCRIPT_DIR/commands/provider-scorecard.md" "$CLAUDE_DIR/commands/provider-scorecard.md"
cp "$SCRIPT_DIR/rules/rpc-cost-patterns.md" "$CLAUDE_DIR/rules/rpc-cost-patterns.md"

echo "Installed agent to $CLAUDE_DIR/agents/rpc-cost-architect.md"
echo "Installed commands to $CLAUDE_DIR/commands/"
echo "Installed rules to $CLAUDE_DIR/rules/"
