#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/skill"
SKILL_NAME="solana-rpc-cost-guard"
INSTALL_PATH="$HOME/.claude/skills/$SKILL_NAME"
FORCE=false
DRY_RUN=false

usage() {
  cat <<'EOF'
Solana RPC Cost Guard Skill installer

Usage:
  ./install.sh [--project] [--path PATH] [--force] [--dry-run]

Options:
  --project     Install to ./.claude/skills/solana-rpc-cost-guard
  --path PATH   Install to a custom skill path
  --force       Replace an existing installation at the destination
  --dry-run     Print what would happen without copying files
  -h, --help    Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      INSTALL_PATH=".claude/skills/$SKILL_NAME"
      shift
      ;;
    --path)
      if [[ $# -lt 2 ]]; then
        echo "Error: --path requires a value" >&2
        exit 1
      fi
      INSTALL_PATH="$2"
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

if [[ ! -f "$SOURCE_DIR/SKILL.md" ]]; then
  echo "Error: expected skill/SKILL.md next to install.sh" >&2
  exit 1
fi

echo "Installing $SKILL_NAME"
echo "Source:      $SOURCE_DIR"
echo "Destination: $INSTALL_PATH"

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

cp -R "$SOURCE_DIR" "$INSTALL_PATH"
echo "Installed to $INSTALL_PATH"
