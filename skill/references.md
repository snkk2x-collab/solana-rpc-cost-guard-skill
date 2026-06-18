# References and Verification Policy

Solana network behavior, RPC endpoint limits, and provider pricing change over time. Use these sources as the starting point, then verify anything time-sensitive before giving exact numbers.

## Primary Solana Sources

| Topic | Source |
| --- | --- |
| Transaction fees, base fees, priority fee formula, compute unit limits | https://solana.com/docs/core/fees |
| Account model, ownership, rent, data-size limits | https://solana.com/docs/core/accounts |
| Recent prioritization fee samples | https://solana.com/docs/rpc/http/getrecentprioritizationfees |
| Public RPC endpoints, cluster purpose, public rate limits, production warning | https://solana.com/docs/references/clusters |
| Solana JSON-RPC API | https://solana.com/docs/rpc |
| Compute budget concepts | https://solana.com/docs/core/fees/compute-budget |
| Transaction structure | https://solana.com/docs/core/transactions |

## Verification Rules

- If the user needs exact current public RPC limits, re-open the Solana clusters page. It explicitly treats public endpoint limits as changeable.
- If the user needs exact provider dollars, use the provider's live pricing page or dashboard. Do not infer prices from memory.
- If the user needs current priority fees, use `getRecentPrioritizationFees` or provider-specific fee APIs. Do not hardcode a static micro-lamport price.
- If the user needs rent-exempt balances, call `getMinimumBalanceForRentExemption` for the exact account data length and cluster, or use the current official formula only as a rough planning estimate.
- If the user needs launch readiness, verify both the public Solana facts and the provider-specific limits, quotas, websocket behavior, webhook delivery guarantees, retention windows, and support SLA.

## Stable Facts To Reuse Carefully

These facts were last checked against Solana docs on 2026-06-19:

- Solana transactions have a base fee plus optional prioritization fee.
- The base fee is per signature.
- The prioritization fee is based on compute unit price and compute unit limit.
- `getRecentPrioritizationFees` can return samples filtered by writable accounts.
- Public RPC endpoints are rate-limited and are not intended for production applications.
- Accounts require a minimum lamport balance proportional to their data size to remain onchain.

Do not copy exact values blindly into dollar estimates without saying when they were verified.
