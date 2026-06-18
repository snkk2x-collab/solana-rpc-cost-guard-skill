# RPC Cost Worksheet

Copy this template into the project review and fill one row per flow.

## Traffic Assumptions

| Field | Value | Confidence | Source |
| --- | --- | --- | --- |
| Daily active users |  | low/med/high |  |
| Peak concurrent users |  | low/med/high |  |
| Sessions per user per day |  | low/med/high |  |
| Peak page loads per minute |  | low/med/high |  |
| Main cluster |  | low/med/high |  |
| RPC/indexer provider |  | low/med/high |  |

## Flow Inventory

| Flow | Trigger | Calls per flow | Fanout multiplier | Retry multiplier | Cache miss rate | Daily calls | Peak calls/min | Notes |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
|  |  |  |  |  |  |  |  |  |

Suggested formula:

```text
daily_calls = users_per_day
            x sessions_per_user
            x flow_invocations_per_session
            x calls_per_flow
            x fanout_multiplier
            x retry_multiplier
            x cache_miss_rate
```

## Endpoint Inventory

| Method/API | Used by | Calls/day | Peak/min | Cacheable | Freshness | Provider cost unit | Risk |
| --- | --- | ---: | ---: | --- | --- | --- | --- |
|  |  |  |  | yes/no | live/near-live/slow/historical |  |  |

## Reduction Plan

| Action | Expected impact | Difficulty | Owner | Deadline |
| --- | --- | --- | --- | --- |
|  | high/med/low | high/med/low |  |  |

## Open Questions

- Which assumptions are not backed by logs?
- Which provider limits or prices need verification?
- Which user flows need a load test?
