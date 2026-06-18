# RPC and Indexer Provider Questionnaire

Use this before choosing, upgrading, or negotiating with a provider.

## Plan and Pricing

- What is the billing unit: request, credit, compute unit, method weight, bandwidth, or seat?
- Which RPC methods are weighted differently?
- Are websocket subscriptions billed separately?
- Are webhooks billed by delivery, matched event, or configured rule?
- Are historical or enhanced transaction APIs priced separately?
- Are there hard budget caps or only soft alerts?

## Limits

- Sustained requests per second.
- Burst requests per second.
- Per-method limits.
- Concurrent HTTP connections.
- Websocket connection limits.
- Websocket subscription limits.
- Maximum batch size.
- Payload size limits.
- Backfill or archive retention windows.

## Reliability

- Regions and routing.
- SLA and support response time.
- Failover behavior.
- Status page and incident history.
- Retry headers and throttling semantics.
- Webhook retry duration and duplicate behavior.
- Data consistency expectations across regions.

## Solana-Specific Features

- Priority fee estimation.
- Enhanced transaction parsing.
- Token/NFT/portfolio APIs.
- DAS API support.
- Program account indexing.
- Webhook filters by program, account, mint, wallet, or instruction.
- Commitment support and default commitment.
- Mainnet/devnet/testnet support.

## Observability

- Dashboard by method, API key, route, project, status code, and time window.
- Exportable logs or metrics.
- Alert integrations.
- Quota and budget alerts.
- Per-endpoint latency percentiles.

## Exit Criteria

Before launch, the team should know:

- Which provider path serves each data class.
- What happens at quota exhaustion.
- What the monthly bill looks like at 1x, 3x, and 10x expected traffic.
- Which workloads can be throttled without breaking core UX.
