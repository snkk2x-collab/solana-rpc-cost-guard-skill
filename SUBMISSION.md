# Superteam Submission

## Project

Solana RPC Cost Guard Skill

Repository: https://github.com/snkk2x-collab/solana-rpc-cost-guard-skill

## What I Built

I built an installable agent skill that helps Solana builders estimate, reduce, and monitor RPC, indexing, transaction-fee, priority-fee, and account-rent costs before production launch.

The skill follows the Solana AI Kit pattern of a small `SKILL.md` router plus progressively loaded topic files. It includes:

- A routing entry point with safety guardrails and deliverable expectations.
- RPC cost triage workflow.
- Transaction fee and priority-fee modeling workflow.
- Rent and account-state budgeting workflow.
- Indexing architecture guidance.
- Rate-limit, caching, batching, and backoff guidance.
- Production launch checklist.
- Copyable templates for cost worksheets, provider evaluation, and launch reviews.
- An optional `rpc-cost-architect` agent for dedicated reviews.
- Two workflow commands: `/rpc-cost-review` and `/provider-scorecard`.
- A code-review rule file for RPC-heavy application code.
- A sample wallet dashboard review artifact.
- A validation script that checks the skill structure.

## Why It Is Useful

Many Solana teams build features first and only later discover that their RPC usage, account state, retry behavior, or indexing plan is too expensive or too fragile. This skill gives an agent a practical review process that catches those issues earlier.

It is useful for:

- Founders planning launch costs.
- Engineers reviewing backend/indexer architecture.
- Frontend teams reducing wallet dashboard and portfolio fanout.
- Program teams modeling account rent and close flows.
- DevRel or audit teams producing actionable launch-readiness reviews.

## What Makes It Agent-Friendly

- The entry file stays compact and routes to specialized files only when needed.
- The review process starts from traffic and product flows instead of generic advice.
- It asks agents to mark estimates as measured, simulated, or assumed.
- It gives concrete output formats, not just concepts.
- It has explicit safety boundaries around signing, private keys, and financial advice.

## How To Validate

Run:

```bash
bash tests/validate-structure.sh
```

The script verifies required files and checks that all progressive-disclosure routes are linked from `skill/SKILL.md`.

I also ran:

```bash
git diff --check
```

## Source Policy

The skill points agents to official Solana documentation for time-sensitive network facts:

- Solana fees: https://solana.com/docs/core/fees
- Solana accounts and rent: https://solana.com/docs/core/accounts
- Recent prioritization fees RPC: https://solana.com/docs/rpc/http/getrecentprioritizationfees
- Public RPC endpoints and limits: https://solana.com/docs/references/clusters
- Solana JSON-RPC API: https://solana.com/docs/rpc

It tells agents to verify provider-specific pricing, quota, websocket, webhook, and dashboard behavior from live provider docs or dashboards before giving exact dollar estimates.

## Limitations

This skill does not replace live provider telemetry. Exact dollar projections require the user's provider plan, traffic model, and logs. The skill is designed to make those assumptions explicit and to produce the next measurement step when data is missing.
