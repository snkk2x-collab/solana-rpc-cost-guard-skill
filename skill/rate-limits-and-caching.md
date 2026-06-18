# Rate Limits and Caching

Use this file for public RPC limits, provider throttling, cache policy, batching, retries, and frontend/backend request control.

## Public RPC Is Not A Production Plan

Solana public endpoints are useful for development and light testing. The official cluster docs state that public endpoints are rate-limited and not intended for production applications. Treat them as a fallback for demos, not as the launch dependency for a real user-facing product.

For production, use:

- A private RPC provider plan.
- A provider indexer or enhanced API for historical/high-cardinality reads.
- Webhooks or server-side subscriptions for event delivery.
- A self-hosted node only when the team can operate it properly.

## Cache By Freshness

Define cache policy by data class:

| Data | Freshness | Cache strategy |
| --- | --- | --- |
| Token metadata | slow | long TTL, background refresh |
| Program config | slow | long TTL with manual invalidation |
| Account snapshots | near-live | slot-aware or short TTL cache |
| Balances | near-live | short TTL, refresh after user action |
| Recent blockhash | live | do not cache beyond its valid lifetime |
| Transaction status | live until terminal | poll with capped backoff |
| Historical activity | historical | indexed database or provider API |

Avoid one global TTL. A single aggressive freshness policy usually means paying live-data costs for slow data.

## Batching and Coalescing

Use these patterns before increasing provider spend:

- Batch account reads with `getMultipleAccounts` where practical.
- Coalesce simultaneous identical requests in the backend.
- Share server-side subscriptions across clients.
- Cache negative lookups for a short period to avoid repeated misses.
- Precompute static or slow-changing lists.
- Move fanout-heavy reads out of the browser and into a controlled backend.

## Backoff

For 429s or provider throttling:

- Respect `Retry-After` when present.
- Use exponential backoff with jitter.
- Cap total attempts.
- Queue non-urgent work instead of retrying immediately.
- Keep idempotency keys for write-side jobs.
- Separate user-facing urgent traffic from background backfills.

## Frontend Controls

Frontend apps can multiply cost quickly. Check for:

- Refetch on focus, reconnect, tab visibility, and route changes.
- Multiple components fetching the same wallet/account independently.
- Polling that continues in background tabs.
- Token/NFT grids that make per-item RPC calls.
- Wallet connect flows that trigger full portfolio reloads repeatedly.

Recommended fixes:

- Centralize RPC state in a query cache.
- Disable background polling when tab is hidden.
- Batch item detail reads.
- Add stale-time and cache-time by data type.
- Use optimistic local updates after a user action, then confirm.

## Provider Requirements

Ask providers:

- Request units or credit cost per RPC method.
- Burst limits and sustained limits by method.
- Websocket connection and subscription limits.
- Webhook delivery guarantees, retry window, and duplicate behavior.
- Historical retention for transactions, logs, and enhanced parsed data.
- Regions, latency, and failover support.
- Priority-fee estimation support.
- Dashboard granularity by method, status code, project, and API key.
- Alerting and hard budget caps.

## Monitoring

Track:

- RPC calls by method, route, user flow, and API key.
- Cache hit rate by data class.
- 429/403/error rate.
- Request latency percentiles.
- Websocket reconnects and missed slots.
- Backfill lag and queue depth.
- Transactions sent, landed, failed, expired, retried.
- Priority fee paid and compute units consumed by transaction type.

## Review Output

Return:

- Current rate-limit risks.
- Cache policy table.
- Request-reduction actions.
- Provider plan gaps.
- Alert thresholds and budget controls.
