#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "README.md"
  "LICENSE"
  "SUBMISSION.md"
  "install.sh"
  "agents/rpc-cost-architect.md"
  "commands/rpc-cost-review.md"
  "commands/provider-scorecard.md"
  "rules/rpc-cost-patterns.md"
  "examples/wallet-dashboard-review.md"
  "skill/SKILL.md"
  "skill/references.md"
  "skill/rpc-cost-triage.md"
  "skill/transaction-fee-model.md"
  "skill/rent-and-state-budgeting.md"
  "skill/indexing-architecture.md"
  "skill/rate-limits-and-caching.md"
  "skill/launch-checklist.md"
  "skill/templates/rpc-cost-worksheet.md"
  "skill/templates/provider-questionnaire.md"
  "skill/templates/launch-cost-review.md"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$ROOT/$file" ]]; then
    echo "Missing required file: $file" >&2
    exit 1
  fi
done

linked_files=(
  "rpc-cost-triage.md"
  "transaction-fee-model.md"
  "rent-and-state-budgeting.md"
  "indexing-architecture.md"
  "rate-limits-and-caching.md"
  "launch-checklist.md"
  "references.md"
  "templates/rpc-cost-worksheet.md"
  "templates/provider-questionnaire.md"
  "templates/launch-cost-review.md"
)

for linked in "${linked_files[@]}"; do
  if ! grep -Fq "$linked" "$ROOT/skill/SKILL.md"; then
    echo "SKILL.md does not link: $linked" >&2
    exit 1
  fi
done

if grep -R "TODO\\|TBD\\|PLACEHOLDER" \
  "$ROOT/README.md" \
  "$ROOT/SUBMISSION.md" \
  "$ROOT/skill" \
  "$ROOT/agents" \
  "$ROOT/commands" \
  "$ROOT/rules" \
  "$ROOT/examples" >/dev/null; then
  echo "Found unfinished TODO/TBD/PLACEHOLDER text" >&2
  exit 1
fi

if [[ ! -x "$ROOT/install.sh" ]]; then
  echo "install.sh must be executable" >&2
  exit 1
fi

if [[ ! -x "$ROOT/tests/validate-structure.sh" ]]; then
  echo "tests/validate-structure.sh must be executable" >&2
  exit 1
fi

for frontmatter_file in \
  "$ROOT/skill/SKILL.md" \
  "$ROOT/agents/rpc-cost-architect.md" \
  "$ROOT/commands/rpc-cost-review.md" \
  "$ROOT/commands/provider-scorecard.md" \
  "$ROOT/rules/rpc-cost-patterns.md"; do
  if [[ "$(sed -n '1p' "$frontmatter_file")" != "---" ]]; then
    echo "Missing frontmatter: ${frontmatter_file#$ROOT/}" >&2
    exit 1
  fi
done

"$ROOT/install.sh" --dry-run >/dev/null

echo "Structure validation passed."
