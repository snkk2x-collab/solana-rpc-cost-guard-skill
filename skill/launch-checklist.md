# Launch Checklist

Use this file for production-readiness reviews focused on Solana RPC, indexing, transaction fees, rent, and operational cost.

## Go/No-Go Gates

A launch plan should answer "yes" to these:

- Do we know peak request volume by RPC method?
- Do we know which flows are live, near-live, slow, and historical?
- Do we have cache policy by data class?
- Do we have rate-limit and 429 behavior tested?
- Do we have a private RPC/indexer plan for production traffic?
- Do we have priority-fee policy and max-fee caps for each transaction type?
- Do we know who pays each transaction fee and account rent cost?
- Do all temporary accounts have close paths where appropriate?
- Do backfills have checkpoints, idempotency, and concurrency limits?
- Do dashboards show method volume, error rate, latency, cache hit rate, transaction result, and fee spend?
- Do alerts fire before quota exhaustion or budget blowout?

## Load Test Plan

Minimum useful rehearsal:

1. Script the top three user journeys.
2. Run each journey enough times to expose per-user and per-session RPC volume.
3. Run background jobs at expected launch concurrency.
4. Inject 429 and timeout responses.
5. Verify retry caps and user-facing degradation.
6. Confirm provider dashboard numbers match internal instrumentation.

Do not extrapolate from a single happy-path browser session unless you mark confidence as low.

## Dashboard Checklist

Create panels for:

- RPC calls by method and route.
- Provider credits or request units by method.
- Cache hit rate by namespace.
- 429, 403, 5xx, timeout, and parse-error rates.
- P50/P95/P99 latency.
- Websocket reconnect count and active subscriptions.
- Backfill lag, rows processed, and last checkpoint.
- Transactions by type: sent, confirmed, finalized, failed, expired.
- Priority fee paid by type.
- Account creation and closure counts.
- Backend fee-payer balance and daily burn.

## Alert Examples

| Alert | Trigger | Response |
| --- | --- | --- |
| Provider quota risk | 70% daily quota before halfway through day | reduce background jobs, raise cache TTL, contact provider |
| 429 spike | 429 rate above threshold for 5 minutes | slow queues, respect backoff, disable non-urgent refresh |
| Cache collapse | hit rate drops suddenly | inspect deploy, key format, invalidation source |
| Fee spike | priority fees exceed policy ceiling | defer non-urgent sends, surface user warning |
| Backfill lag | lag grows for 15 minutes | reduce concurrency or switch provider path |
| Fee payer drain | projected daily spend above budget | pause sponsored flow |

## Launch Review Output

Produce a short go/no-go artifact:

- Decision: go, go with conditions, or no-go.
- Top risks.
- Required fixes before launch.
- Live monitoring owner.
- Rollback or degradation plan.
- Open provider questions.

## Degradation Plan

Prefer graceful degradation:

- Hide or slow-refresh non-critical historical panels.
- Serve cached metadata while refreshing in background.
- Queue non-urgent writes when priority fees exceed ceiling.
- Reduce backfill concurrency before user-facing routes are affected.
- Disable expensive filters or exports temporarily.
- Keep core transaction confirmation UX live.
