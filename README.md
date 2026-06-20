# Solana RPC Cost Guard Skill

A token-efficient agent skill for estimating, reducing, and monitoring Solana RPC, transaction, indexing, and account-storage costs before a product reaches production traffic.

This skill is designed as an addon for Solana AI Kit style agent setups. It gives builders a repeatable way to turn vague concerns like "will our RPC bill explode?" into concrete traffic models, cache rules, provider questions, and launch gates.

## Why This Exists

Solana apps often discover cost and reliability problems late:

- Frontends poll expensive endpoints too often.
- Backends depend on public RPC endpoints that are rate-limited and not intended for production.
- Priority fees are hardcoded instead of estimated from current writable-account contention.
- Indexers backfill without checkpoints, idempotency, or replay budgets.
- Account storage is treated as free even though every account needs a rent-exempt balance.

The goal is not to predict a provider invoice perfectly. The goal is to make an agent ask the right questions, use current Solana facts, and produce a cost-control plan that a founder or engineer can actually execute.

## Included Skill Files

| File | Purpose |
| --- | --- |
| `skill/SKILL.md` | Entry point, guardrails, and routing guide |
| `skill/rpc-cost-triage.md` | Intake flow and cost-driver diagnosis |
| `skill/transaction-fee-model.md` | Base fees, priority fees, compute budgets, and estimation workflow |
| `skill/rent-and-state-budgeting.md` | Account size, rent-exempt balances, and state cleanup |
| `skill/indexing-architecture.md` | RPC polling, subscriptions, webhooks, custom indexers, and backfills |
| `skill/rate-limits-and-caching.md` | Public endpoint limits, caching policy, batching, and backoff |
| `skill/launch-checklist.md` | Production launch gates, dashboards, alerts, and runbooks |
| `skill/references.md` | Primary source links and verification policy |
| `skill/templates/*` | Copyable worksheets and review templates |
| `agents/rpc-cost-architect.md` | Optional specialist agent for cost and launch-readiness reviews |
| `commands/rpc-cost-review.md` | Optional workflow command for structured reviews |
| `commands/provider-scorecard.md` | Optional workflow command for provider comparisons |
| `rules/rpc-cost-patterns.md` | Optional code review rules for RPC-heavy code |
| `examples/wallet-dashboard-review.md` | Sample output artifact |
| `JUDGING.md` | Direct mapping to Superteam usefulness, novelty, quality, and fit criteria |

## Installation

Install for your user:

```bash
git clone https://github.com/snkk2x-collab/solana-rpc-cost-guard-skill
cd solana-rpc-cost-guard-skill
./install.sh
```

Install into the current project:

```bash
./install.sh --project
```

Install into a custom skill path:

```bash
./install.sh --path /path/to/.claude/skills/solana-rpc-cost-guard
```

The installer does not ask for keys, create wallets, send transactions, or contact an RPC provider.

By default, the installer also copies the optional agent, commands, and rules into the same `.claude` directory. To install only the skill:

```bash
./install.sh --skill-only
```

## Example Prompts

```text
Use solana-rpc-cost-guard to review our launch RPC plan for a wallet dashboard with 20k daily users.
```

```text
Estimate the transaction and account storage costs for this Solana program flow before we ship.
```

```text
Design a cheaper indexing architecture for balances, token accounts, and program events.
```

```text
Turn this dapp traffic model into RPC provider requirements and alert thresholds.
```

## Default Output Shape

When the skill is used, the agent should usually produce:

1. Traffic and endpoint inventory.
2. Cost drivers ranked by expected impact.
3. Concrete reductions such as cache rules, batching, account filters, and backoff.
4. Fee and rent model with assumptions clearly marked.
5. Provider questions and launch gates.
6. Residual risks that need live provider data or production telemetry.

## Primary Sources

The skill points agents to official Solana documentation first:

- Solana fees: https://solana.com/docs/core/fees
- Solana accounts and rent: https://solana.com/docs/core/accounts
- Recent prioritization fees RPC: https://solana.com/docs/rpc/http/getrecentprioritizationfees
- Public RPC endpoints and limits: https://solana.com/docs/references/clusters
- Solana JSON-RPC API: https://solana.com/docs/rpc

Provider limits and pricing change frequently, so the skill instructs agents to verify provider-specific numbers from the live provider docs or dashboard before giving exact dollar estimates.

## Validation

Run:

```bash
bash tests/validate-structure.sh
```

The validation script checks that required skill files exist and that every progressive-disclosure route is linked from `SKILL.md`.

For a reviewer-focused overview, see [JUDGING.md](JUDGING.md).

## Safety Notes

- This skill does not provide financial advice.
- It must not sign, send, or ask a user to sign Solana transactions.
- It must not request private keys, seed phrases, or keypair files.
- It should treat exact network conditions, provider prices, and public endpoint limits as time-sensitive and verify them before final estimates.

## License

MIT.
