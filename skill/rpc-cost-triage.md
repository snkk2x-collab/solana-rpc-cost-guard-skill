# RPC Cost Triage

Use this file when the user asks where Solana infrastructure cost is coming from, how to estimate RPC usage, or how to reduce usage before launch.

## First-Pass Intake

Collect or infer:

| Field | Examples |
| --- | --- |
| Product type | wallet dashboard, NFT mint, game, DeFi app, payments, admin tool |
| Cluster | localnet, devnet, testnet, mainnet |
| Users | DAU, MAU, peak concurrent users, geographic regions |
| Hot paths | first page load, wallet connect, token list, portfolio refresh, claim, swap, mint |
| Background jobs | backfills, reconciliation, metadata refreshes, indexer catch-up |
| RPC methods | `getAccountInfo`, `getMultipleAccounts`, `getProgramAccounts`, `getSignaturesForAddress`, `getTransaction`, websocket subscriptions |
| Transactions | per-user writes, backend writes, retries, priority fee usage |
| State | accounts created, resized, closed, retained forever |
| Provider | public endpoint, private RPC, indexer API, webhook provider, self-hosted node |

## Build the Cost Surface

Create one row for each user-visible action or background process.

| Flow | Trigger | RPC/API calls | Multiplier | Cacheable? | Freshness need | Cost risk |
| --- | --- | --- | --- | --- | --- | --- |
| Portfolio load | user opens app | balances, token accounts, metadata | users x wallets x tokens | partly | 5-60 sec | high |
| Program event feed | cron/indexer | signatures, transactions, account filters | slots x programs | yes | 1-30 sec | high |
| Mint/claim | user action | blockhash, simulation, send, confirm | attempts x retries | no | live | medium |

Multipliers matter more than individual methods. A cheap endpoint called per token per wallet per refresh interval can dominate the bill.

## Cost Driver Ladder

Rank risks in this order:

1. Unbounded polling loops or per-slot jobs.
2. `getProgramAccounts` over large programs without filters, pagination strategy, or replacement index.
3. Per-wallet fanout multiplied by token count, positions, NFTs, or open orders.
4. Repeated `getTransaction` or log backfills without checkpointing.
5. Websocket subscriptions per user instead of shared backend subscriptions.
6. Retry loops without jitter, caps, or deduplication.
7. Missing cache policy for metadata, token lists, program config, and slow-changing accounts.
8. Transactions with hardcoded compute budget or priority fee.
9. Accounts that are never closed after a flow is complete.

## Quick Reduction Moves

Start with changes that reduce request count without weakening correctness:

- Replace N single-account reads with `getMultipleAccounts` when the data can share one commitment and freshness level.
- Move global data from per-user frontend calls to backend cache or static build-time artifacts.
- Add a request coalescer so simultaneous identical reads share one in-flight promise.
- Add slot-aware or TTL-based cache keys for account data.
- Use event/webhook/indexer sources for historical data instead of replaying transactions on every request.
- Store backfill checkpoints and make ingestion idempotent.
- Cap retries, use exponential backoff with jitter, and respect provider `Retry-After` headers.
- Split "fresh enough" UI state from "must be finalized" settlement state.

## Estimate Request Volume

Use this rough formula for each flow:

```text
daily_calls = users_per_day
            x sessions_per_user
            x flow_invocations_per_session
            x calls_per_flow
            x fanout_multiplier
            x retry_multiplier
            x cache_miss_rate
```

For background jobs:

```text
daily_calls = jobs_per_day
            x calls_per_job
            x pages_or_batches_per_job
            x retry_multiplier
```

For websocket or subscription systems:

```text
active_subscriptions = concurrent_users
                     x subscriptions_per_user
                     x fanout_multiplier
```

Then ask whether those subscriptions can be shared, moved server-side, or replaced by a provider webhook/indexer.

## Confidence Bands

Mark each estimate:

- High confidence: based on logs, traces, provider dashboard, or load test.
- Medium confidence: based on code inspection and realistic traffic assumptions.
- Low confidence: based on product guesses only.

When confidence is low, produce an experiment:

- Add RPC client instrumentation.
- Run a scripted user journey 100 times.
- Rehearse a backfill against devnet or a small mainnet range.
- Ask the provider for plan-specific quota and burst behavior.

## Output Checklist

Return:

- Top cost risks.
- Estimated daily and peak request volume.
- Endpoints most likely to hit rate limits.
- Cache and batching opportunities.
- Provider questions.
- Metrics to add before launch.
