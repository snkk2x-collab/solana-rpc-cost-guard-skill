# Rent and State Budgeting

Use this file when a product creates, resizes, retains, or closes Solana accounts.

## Planning Model

Solana account storage is an upfront capital requirement, not just a database row. Every account must hold a minimum lamport balance proportional to its data size to remain onchain.

For planning, model:

```text
accounts_created_per_user
x account_data_size_bytes
x rent_exempt_lamports_for_size
x expected_active_users
```

Then separate:

- User-funded account creation.
- Backend-funded account creation.
- Accounts that can be closed and refunded.
- Accounts that remain permanent protocol state.

## Account Inventory

Create a table:

| Account | Owner program | Data size | Created by | Funded by | Lifetime | Close path | Notes |
| --- | --- | ---: | --- | --- | --- | --- | --- |
| user profile PDA | app program | bytes | signup | user/backend | long-lived | yes/no | versioned? |
| escrow | app program | bytes | transaction | user | temporary | yes | close after settle |
| config | app program | bytes | deploy/admin | backend | permanent | no | few accounts |

## Sizing Rules

- Count discriminator, headers, padding, vector capacity, optional fields, and future version fields.
- Avoid large unbounded vectors in frequently created accounts.
- Prefer compact encodings for hot per-user state.
- Split rarely used large state from hot state only when it reduces read/write and rent cost.
- Be explicit about account migrations and resize limits.

## Rent-Exempt Balance

For exact values, call `getMinimumBalanceForRentExemption` with the account data length on the target cluster. The official account docs also provide the current rent formula for planning.

Do not present a rent estimate as exact unless you have either:

- Called the RPC method for the exact size and cluster, or
- Verified the current formula and constants from official docs and stated the verification date.

## Cost Reduction Moves

- Close temporary accounts after settlement, claim, expiry, or cancellation.
- Provide explicit user flows for reclaiming lamports from stale accounts.
- Add cron or keeper logic only when it is safe and economically justified.
- Avoid creating per-user accounts until the user actually needs state.
- Consider off-chain or compressed representations for data that does not require mutable on-chain ownership.
- Use PDAs for deterministic lookup, but do not create every possible PDA preemptively.

## State Bloat Risks

Call out:

- Accounts with no close authority or close instruction.
- Sponsored account creation without abuse controls.
- Large dynamic fields that grow with user activity.
- Permanent per-user accounts for users who may never return.
- Indexing designs that require scanning all historical accounts because state lacks lifecycle markers.

## Review Output

Return:

- Total account types and likely account count drivers.
- Upfront lamport requirement by account type.
- Who pays and who can reclaim.
- Recommended close/migration strategy.
- Open questions needed for exact sizing.
