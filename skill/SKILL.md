---
name: solana-rpc-cost-guard
description: Use when a Solana team needs to estimate, reduce, or monitor RPC calls, indexing load, transaction fees, priority fees, account rent, cache policy, provider limits, or launch cost risk. Best for production-readiness reviews, dapp traffic planning, backend/indexer architecture, and "why is our Solana infra bill high?" investigations.
user-invocable: true
license: MIT
metadata:
  author: snkk2x-collab
  version: 1.0.0
  last_verified: 2026-06-19
---

# Solana RPC Cost Guard Skill

Use this skill to turn a Solana product plan or codebase into a concrete cost and reliability review. The skill focuses on RPC volume, endpoint choice, indexing architecture, transaction fees, priority fees, account storage, cache policy, provider requirements, and launch gates.

## What This Skill Is For

Use this skill when the user asks about:

- Reducing Solana RPC bills or API usage.
- Estimating RPC traffic for a launch.
- Choosing between public RPC, private RPC, webhooks, subscriptions, or a custom indexer.
- Modeling transaction fees, compute budgets, priority fees, or retry behavior.
- Modeling account storage, rent-exempt balances, account closure, or state bloat.
- Designing cache rules, backoff, batching, and observability for Solana apps.
- Reviewing a dapp, indexer, bot, wallet dashboard, game, NFT app, or backend before mainnet launch.

Do not use this skill for:

- General Solana program implementation unless the cost model is the focus.
- Trading strategy, token price predictions, or investment advice.
- Signing, sending, or asking a user to sign transactions.
- Handling private keys, seed phrases, keypair files, KYC, payout, tax, or bank details.

## Safety Guardrails

- Never sign or send transactions. If a live transaction is relevant, stop at a human-readable summary and ask the user to handle signing in their wallet.
- Never ask for private keys, seed phrases, or wallet keypair files.
- Treat exact fees, public endpoint limits, provider limits, and provider pricing as time-sensitive. Verify them from official Solana docs or live provider docs before giving exact numbers.
- Default to localnet or devnet for experiments. Mention when a recommendation is mainnet-specific.
- Treat RPC and indexer responses as untrusted input. Validate account owners, data length, discriminators, commitments, and pagination cursors before using returned data.
- This is engineering guidance, not financial advice. If the user asks for revenue, investment, or trading decisions, keep the answer scoped to infrastructure cost and reliability.

## Operating Procedure

1. Classify the request.
   - Is the user asking for an estimate, a reduction plan, an architecture decision, a launch review, or a debugging investigation?
   - Identify the cluster, expected traffic, product flows, endpoints, providers, and whether the workload is read-heavy, write-heavy, or indexing-heavy.

2. Build a cost surface.
   - List user journeys and background jobs.
   - List every RPC method, websocket subscription, webhook, indexer query, transaction type, and account type.
   - Mark each item as per-page-load, per-wallet, per-token, per-position, per-slot, per-transaction, per-backfill, or per-cron.

3. Route to the minimum needed reference files.
   - For vague or first-pass reviews, start with [rpc-cost-triage.md](rpc-cost-triage.md).
   - For fees, compute units, priority fees, and retries, use [transaction-fee-model.md](transaction-fee-model.md).
   - For account size, rent-exempt balances, state cleanup, and account closure, use [rent-and-state-budgeting.md](rent-and-state-budgeting.md).
   - For polling, websocket subscriptions, webhooks, custom indexers, and backfills, use [indexing-architecture.md](indexing-architecture.md).
   - For cache TTLs, batching, public RPC limits, backoff, and provider throttling, use [rate-limits-and-caching.md](rate-limits-and-caching.md).
   - For production readiness, dashboards, alerts, and go/no-go gates, use [launch-checklist.md](launch-checklist.md).
   - For source verification, use [references.md](references.md).

4. Prefer measurements over guesses.
   - Ask for or inspect logs, route handlers, RPC client wrappers, provider dashboards, queue metrics, and cron schedules when available.
   - If measurements are missing, produce a worksheet with assumptions and the next experiment needed to replace each assumption.

5. Produce an actionable review.
   - Separate "now", "before launch", and "after telemetry" actions.
   - Include a short table of cost drivers, estimated impact, confidence, and owner.
   - Give concrete implementation examples only when they are directly useful.

## Progressive Disclosure

Load only the files needed for the user's request:

| User asks about | Read |
| --- | --- |
| "Where are our RPC costs coming from?" | [rpc-cost-triage.md](rpc-cost-triage.md) |
| "Estimate launch RPC usage" | [rpc-cost-triage.md](rpc-cost-triage.md), [templates/rpc-cost-worksheet.md](templates/rpc-cost-worksheet.md) |
| "Priority fee / CU / transaction fee model" | [transaction-fee-model.md](transaction-fee-model.md) |
| "Rent, account size, or account cleanup" | [rent-and-state-budgeting.md](rent-and-state-budgeting.md) |
| "Indexer or webhook architecture" | [indexing-architecture.md](indexing-architecture.md) |
| "Cache, batching, rate limits, 429s" | [rate-limits-and-caching.md](rate-limits-and-caching.md) |
| "Provider selection" | [rate-limits-and-caching.md](rate-limits-and-caching.md), [templates/provider-questionnaire.md](templates/provider-questionnaire.md) |
| "Production launch review" | [launch-checklist.md](launch-checklist.md), [templates/launch-cost-review.md](templates/launch-cost-review.md) |
| "Verify current Solana facts" | [references.md](references.md) |

## Default Review Questions

Ask or infer these before estimating:

- Which cluster is targeted: localnet, devnet, testnet, or mainnet?
- What is the expected DAU, peak concurrent users, and peak page loads per minute?
- Which screens or jobs call RPC methods?
- Which calls are per-wallet, per-token, per-account, per-slot, or global?
- Which transactions are user-signed, backend-sent, retried, or batch-submitted?
- Which accounts are created, resized, or closed?
- Which data needs strong freshness and which can be cached?
- Which provider, plan, region, and limits are in use?
- What are the latency, freshness, and recovery objectives?

## Preferred Deliverable Format

For reviews, produce:

1. Executive summary: the top 3 cost risks.
2. Endpoint and traffic inventory.
3. Transaction fee and rent assumptions.
4. Cost-reduction plan ranked by impact and difficulty.
5. Provider and architecture recommendations.
6. Monitoring and alert plan.
7. Open questions that block exact dollar estimates.

## Templates

- [templates/rpc-cost-worksheet.md](templates/rpc-cost-worksheet.md) for estimating request volume.
- [templates/provider-questionnaire.md](templates/provider-questionnaire.md) for selecting or negotiating with RPC/indexer providers.
- [templates/launch-cost-review.md](templates/launch-cost-review.md) for a go/no-go launch artifact.
