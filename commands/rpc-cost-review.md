---
name: rpc-cost-review
description: Run a structured Solana RPC, indexing, fee, rent, cache, and launch-cost review.
---

# RPC Cost Review

Use this command when a user wants a practical infrastructure cost review for a Solana app, backend, indexer, dashboard, bot, game, or protocol launch.

## Usage

```text
/rpc-cost-review [scope]
```

Examples:

```text
/rpc-cost-review wallet dashboard launch
/rpc-cost-review indexer backfill plan
/rpc-cost-review why our RPC bill spiked
```

## Workflow

### 1. Load Context

Read the minimal files needed:

- `skill/rpc-cost-triage.md`
- `skill/rate-limits-and-caching.md`
- Add `skill/transaction-fee-model.md` if transactions are in scope.
- Add `skill/rent-and-state-budgeting.md` if accounts are created or resized.
- Add `skill/indexing-architecture.md` if history, events, webhooks, or backfills are in scope.
- Add `skill/launch-checklist.md` if this is a production review.

### 2. Inventory Workloads

Create a table of:

- User flows.
- Background jobs.
- RPC methods and provider APIs.
- Websocket subscriptions or webhooks.
- Transaction types.
- Account types.
- Cache policy and freshness needs.

### 3. Estimate Load

Use:

```text
daily_calls = users_per_day
            x sessions_per_user
            x flow_invocations_per_session
            x calls_per_flow
            x fanout_multiplier
            x retry_multiplier
            x cache_miss_rate
```

Mark every number as measured, simulated, or assumed.

### 4. Recommend Changes

Rank actions by expected impact:

- Remove per-item fanout.
- Batch account reads.
- Add shared backend cache.
- Coalesce duplicate in-flight requests.
- Replace repeated historical RPC with an indexer path.
- Add checkpointed backfills.
- Add retry caps and jitter.
- Define transaction fee ceilings.
- Add account close flows.

### 5. Deliver

Return:

- Decision or risk posture.
- Top three risks.
- Cost surface table.
- Recommended actions.
- Provider questions.
- Metrics and alerts.
- Missing data needed for exact dollar estimates.
