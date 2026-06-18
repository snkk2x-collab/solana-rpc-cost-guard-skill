# Indexing Architecture

Use this file when the user asks how to fetch, track, backfill, or query Solana data without overspending on RPC.

## Choose The Right Data Path

| Need | Good default | Watch out |
| --- | --- | --- |
| Small live account set | `getMultipleAccounts` with cache | stale data and commitment mismatch |
| User portfolio | provider DAS/token APIs or backend cache | per-token fanout from frontend |
| Program-specific state | indexed account snapshots plus change feed | large unfiltered `getProgramAccounts` scans |
| Historical transactions | provider enhanced transaction/indexer API | repeated `getTransaction` backfills |
| Real-time UX | server-side websocket or webhook fanout | one subscription per browser tab |
| Analytics | warehouse/indexer pipeline | using RPC as an analytics database |

## Polling vs Subscriptions vs Webhooks

Polling is simplest, but it can become expensive when multiplied by users, tokens, or slots.

Use polling when:

- The account set is small.
- Freshness needs are relaxed.
- Calls can be cached or batched.

Use websocket subscriptions when:

- The watched account/program set is bounded.
- You can share subscriptions server-side.
- You have reconnect and replay logic.

Use provider webhooks when:

- You need durable delivery semantics or managed filtering.
- You want to reduce your own websocket fanout.
- You can handle duplicates and out-of-order delivery.

Use a custom indexer when:

- Historical queries are core to the product.
- You need your own query model, joins, or retention.
- Provider APIs cannot meet cost, latency, or correctness requirements.

## Backfill Design

Every backfill needs:

- Start and end range.
- Cursor or checkpoint format.
- Idempotent writes.
- Retry policy with bounded concurrency.
- Resume behavior after process crash.
- Rate-limit budget.
- Verification query to detect missed ranges.
- Clear stop condition.

Avoid designs that replay the full history on every deploy or every cache miss.

## Data Freshness Tiers

Assign every data type a freshness tier:

| Tier | Examples | Suggested approach |
| --- | --- | --- |
| Live | transaction confirmation, claim status | direct RPC, websocket, or provider webhook |
| Near-live | balances, open positions, game state | short TTL cache, subscription invalidation |
| Slow | metadata, token lists, program config | long TTL cache or static artifact |
| Historical | charts, activity feeds, analytics | indexed database or provider indexer |

Most cost reductions come from refusing to treat slow or historical data as live data.

## Index Schema Hints

For app-owned programs, index enough metadata to answer product questions without re-reading every transaction:

- Account address.
- Owner program.
- Account type/version.
- Authority/user wallet.
- Created slot and updated slot.
- Last observed signature.
- Lifecycle status.
- Data hash or version.

For events:

- Signature.
- Slot.
- Instruction/program id.
- Event type.
- Idempotency key.
- Parsed fields needed by the UI.
- Raw payload location if full replay is needed.

## Failure Modes

Call out these risks in reviews:

- Reorg or commitment confusion between `processed`, `confirmed`, and `finalized`.
- Duplicate webhook deliveries.
- Missed websocket messages after reconnect.
- Provider retention window too short for slow backfills.
- Unbounded `getSignaturesForAddress` pagination.
- Transaction parser depending on mutable external metadata.
- Mixed providers returning different data freshness or parsed formats.

## Review Output

Return:

- Recommended data path per use case.
- Backfill and replay strategy.
- Cache invalidation source.
- Provider features required.
- Data correctness risks and mitigations.
