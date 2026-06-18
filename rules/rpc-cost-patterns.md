---
globs:
  - "**/*.{ts,tsx,js,jsx,mjs,cjs}"
  - "**/*.{rs,py,go}"
exclude:
  - "**/node_modules/**"
  - "**/dist/**"
  - "**/build/**"
  - "**/target/**"
  - "**/.next/**"
---

# Solana RPC Cost Patterns

Apply these rules when reviewing application code that calls Solana RPC, indexer APIs, provider webhooks, or transaction send paths.

## Request Control

- Centralize RPC clients so calls can be instrumented by method, route, and API key.
- Do not scatter direct RPC calls across components without a query/cache layer.
- Avoid per-item loops that call `getAccountInfo`, `getTransaction`, or provider APIs one at a time.
- Prefer batching when the data shares a commitment and freshness requirement.
- Add in-flight request coalescing for duplicate reads.

## Public Endpoint Use

- Do not rely on public Solana RPC endpoints for production user traffic.
- If public endpoints appear in production config, flag it as a launch blocker.
- Keep devnet/testnet/mainnet endpoints explicit and environment-scoped.

## Cache Policy

- Assign TTL or invalidation policy by data class.
- Long-cache metadata and static config.
- Short-cache account snapshots and balances when exact liveness is not required.
- Do not cache recent blockhashes beyond their valid lifetime.
- Disable or slow polling in hidden browser tabs.

## Backfills and Indexers

- Backfills need checkpoints, idempotency, bounded concurrency, and a stop condition.
- Do not replay full history on every deploy or cache miss.
- Avoid unfiltered or repeated `getProgramAccounts` scans on large programs.
- Treat webhook deliveries as potentially duplicated or out of order.

## Transaction Paths

- Simulate transactions before sending where practical.
- Set compute budgets intentionally; avoid always using the max compute limit.
- Estimate priority fees from current conditions rather than hardcoding one value forever.
- Cap retries and separate urgent user flows from background sends.
- Add daily spend and per-user limits when a backend fee payer sponsors transactions.
