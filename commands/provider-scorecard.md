---
name: provider-scorecard
description: Compare Solana RPC, indexer, webhook, and enhanced API providers against product traffic and launch requirements.
---

# Provider Scorecard

Use this command when the user needs to choose, upgrade, or negotiate with a Solana RPC/indexer provider.

## Usage

```text
/provider-scorecard [provider names or product requirements]
```

Examples:

```text
/provider-scorecard for a 50k DAU wallet dashboard
/provider-scorecard Helius vs QuickNode vs Triton for program event indexing
```

## Workflow

### 1. Load Context

Read:

- `skill/rate-limits-and-caching.md`
- `skill/indexing-architecture.md`
- `skill/templates/provider-questionnaire.md`
- `skill/references.md`

### 2. Define Requirements

Capture:

- Expected requests per second and peak bursts.
- Required RPC methods and enhanced APIs.
- Websocket or webhook requirements.
- Historical retention and backfill needs.
- Region and latency needs.
- Dashboard, alerting, and budget-control needs.
- Priority-fee estimation needs.

### 3. Score Providers

Use a 1-5 score and mark unknowns clearly.

| Category | Weight | Provider A | Provider B | Notes |
| --- | ---: | ---: | ---: | --- |
| Required methods |  |  |  |  |
| Burst limits |  |  |  |  |
| Websocket/webhook fit |  |  |  |  |
| Historical retention |  |  |  |  |
| Priority-fee support |  |  |  |  |
| Observability |  |  |  |  |
| Budget controls |  |  |  |  |
| Support/SLA |  |  |  |  |

### 4. Verify Current Facts

Provider prices and limits change often. Verify from live provider docs or dashboards before presenting exact dollar comparisons.

### 5. Deliver

Return:

- Recommended provider path.
- Known unknowns.
- Questions to send to providers.
- Launch blockers.
- Fallback or failover plan.
