# Transaction Fee Model

Use this file for Solana transaction base fees, compute units, priority fees, simulation, retries, and fee-payer risk.

## Fee Components

Solana transaction fees have two main parts:

| Component | Planning meaning |
| --- | --- |
| Base fee | Paid per signature. Include every signer and every retry. |
| Prioritization fee | Optional fee based on compute unit price and compute unit limit. Used to improve scheduling during congestion. |

Planning formula:

```text
base_fee_lamports = signature_count x base_fee_per_signature
priority_fee_lamports = ceil(compute_unit_price_micro_lamports x compute_unit_limit / 1_000_000)
total_fee_lamports = base_fee_lamports + priority_fee_lamports
```

Verify the current constants from https://solana.com/docs/core/fees before giving exact numeric commitments.

## Estimation Workflow

1. Inventory transaction types.
   - Who pays the fee?
   - How many signatures are required?
   - Which accounts are writable?
   - Which instructions run and in what order?
   - Which flows retry automatically?

2. Simulate.
   - Simulate the built transaction or transaction message.
   - Record consumed compute units and errors.
   - Add a bounded margin rather than using the max compute limit by default.

3. Estimate current priority fee.
   - Use `getRecentPrioritizationFees`.
   - Provide the writable accounts when congestion around specific accounts matters.
   - Prefer a provider priority-fee API when the production provider offers one.

4. Set compute budget intentionally.
   - Add a compute unit limit based on simulation.
   - Add a compute unit price based on current conditions and user experience requirements.
   - Refresh blockhash after expensive pre-send work.

5. Track retries separately.
   - Each failed or expired send attempt can create user pain and possibly additional base-fee exposure if it lands.
   - Cap retries, add jitter, and make backend operations idempotent.

## What To Watch For

- Hardcoded priority fees that are too high in quiet periods or too low during congestion.
- Setting the compute unit limit much higher than simulation requires.
- Forgetting that more signatures means more base fee.
- Building a transaction, simulating, waiting too long, then sending with stale blockhash assumptions.
- Sending multiple competing retries without deduplication.
- Backend-sponsored fees without per-user or per-IP abuse limits.
- Fee payer accounts that can be drained by repeated sponsored operations.

## Priority Fee Sampling

`getRecentPrioritizationFees` returns recent micro-lamport-per-compute-unit samples and can filter by locked writable accounts. Use it to avoid a single global fee guess.

Planning guidance:

- For one-off UX, choose a percentile policy rather than a fixed number.
- For backend jobs, define a max acceptable priority fee and defer non-urgent work above that ceiling.
- For user-sponsored transactions, show the user a clear fee expectation before signing.
- For high-contention writable accounts, estimate fees using those writable accounts rather than only the unfiltered cluster-wide samples.

## Fee-Payer Abuse Controls

If the backend pays fees:

- Require authentication or proof of eligibility.
- Put per-user and per-IP budgets on sponsored sends.
- Add a daily circuit breaker for total sponsored fee spend.
- Simulate and reject clearly failing transactions before requesting a signature or sending.
- Log transaction type, fee payer, signature count, compute limit, compute price, result, and retry count.

## Deliverable Snippet

For each transaction type, report:

| Transaction | Signatures | Est. CU | Priority policy | Retry cap | Fee payer | Risk |
| --- | ---: | ---: | --- | ---: | --- | --- |
| claim reward | 1 | from simulation | p50/p75 writable-account sample | 2 | user | low |
| backend settle | 1 | from simulation | max ceiling, defer when high | 3 | backend | medium |

Always state whether estimates are measured, simulated, or assumed.
