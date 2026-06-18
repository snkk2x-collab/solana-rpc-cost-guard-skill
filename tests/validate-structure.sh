#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "README.md"
  "LICENSE"
  "install.sh"
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

if grep -R "TODO\\|TBD\\|PLACEHOLDER" "$ROOT/README.md" "$ROOT/skill" >/dev/null; then
  echo "Found unfinished TODO/TBD/PLACEHOLDER text" >&2
  exit 1
fi

echo "Structure validation passed."
