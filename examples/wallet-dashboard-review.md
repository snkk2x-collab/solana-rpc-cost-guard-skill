# Example: Wallet Dashboard RPC Cost Review

This example shows the kind of output the skill should produce for a Solana wallet dashboard preparing for launch.

## Scenario

- Product: wallet dashboard with balances, token accounts, NFTs, recent activity, and claim transactions.
- Expected usage: 20,000 DAU, 2 sessions per user per day, 3 dashboard refreshes per session.
- Cluster: mainnet.
- Current state: frontend calls RPC directly from multiple components.
- Provider: not selected.

## Decision

Go with conditions.

The product can launch if the team centralizes RPC access, moves high-fanout reads behind a backend cache, chooses a private RPC/indexer provider, and adds quota alerts before launch.

## Top Risks

| Risk | Impact | Confidence | Fix |
| --- | --- | --- | --- |
| Per-token frontend fanout | High | Medium | Move portfolio aggregation behind backend cache |
| Public RPC dependency | High | High | Select private provider before launch |
| Recent activity backfill per page load | High | Medium | Use indexed activity store or provider enhanced API |
| No 429 degradation plan | Medium | High | Add retry caps, jitter, and stale-cache fallback |

## Cost Surface

| Flow | Multiplier | Estimated calls/day | Cache policy |
| --- | ---: | ---: | --- |
| Dashboard initial load | 20k users x 2 sessions | unknown until instrumented | short TTL account cache |
| Token balances | wallets x tokens x refreshes | high fanout | backend aggregation |
| NFT metadata | NFTs x page load | high if uncached | long TTL metadata cache |
| Recent activity | wallets x pagination | high if replayed | indexed store |
| Claim transaction | user action x retries | low volume | live, no cache |

## Immediate Actions

| Action | Expected impact | Evidence |
| --- | --- | --- |
| Add RPC wrapper instrumentation | High | Required to replace assumptions |
| Disable direct component-level RPC calls | High | Reduces duplicate reads |
| Batch account reads | Medium | Reduces request count |
| Add stale-time by data class | Medium | Reduces refresh loops |
| Select provider with method-level dashboard | High | Required for launch |

## Provider Questions

- What is the cost per token-account and NFT portfolio query?
- Are websocket subscriptions billed separately?
- What are per-method burst limits?
- Is enhanced transaction history retained long enough for activity backfill?
- Does the provider expose priority-fee estimation?
- Can alerts trigger before quota exhaustion?

## Open Questions

- Actual average token/NFT count per connected wallet.
- Exact dashboard refresh behavior in hidden tabs.
- Whether recent activity needs finalized or confirmed data.
- Whether claim transactions are user-paid or backend-sponsored.
