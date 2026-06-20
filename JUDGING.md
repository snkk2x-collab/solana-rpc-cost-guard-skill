# Judging Evidence

This note maps Solana RPC Cost Guard directly to the Superteam listing criteria:
usefulness, novelty, quality, and fit with the Solana AI Kit skill shape.

## Usefulness

Solana teams repeatedly face launch-time infrastructure cost and reliability issues:

- wallet and portfolio pages fan out into many `getTokenAccountsByOwner`, account, NFT, and transaction-history calls;
- public RPC endpoints are used beyond their intended limits;
- retry loops and hidden-tab refreshes multiply provider usage;
- priority fees and compute budgets are hardcoded instead of measured;
- account rent, close flows, and state cleanup are missing from product cost reviews;
- indexer backfills launch without checkpoints, replay budgets, or alerting.

The skill turns those issues into an actionable review artifact: endpoint inventory,
traffic model, cache policy, provider questionnaire, fee and rent assumptions, and launch gates.

## Novelty

The existing Solana skill ecosystem is strong for building programs, using ecosystem APIs,
and auditing code. This skill focuses on a narrower recurring gap: production cost control
for Solana RPC, indexing, priority fees, and account rent before launch.

That makes it complementary to:

- Solana Foundation developer skills;
- Helius and core AI resources;
- Jupiter, Metaplex, and SendAI ecosystem skills;
- Trail of Bits and other security-review skills.

It is not a general Solana programming tutorial. It is a launch-readiness and cost-control
skill for founders and engineers who need operational decisions.

## Quality

The repo is structured for review and reuse:

- `skill/SKILL.md` is a compact router with guardrails and progressive-disclosure links.
- Topic files cover RPC triage, transaction fees, rent, indexing, caching, references, and launch gates.
- Templates make outputs repeatable instead of ad hoc.
- Optional `agents/`, `commands/`, and `rules/` files help teams use the workflow repeatedly.
- `examples/wallet-dashboard-review.md` demonstrates the expected output quality.
- `tests/validate-structure.sh` verifies required files, frontmatter, route links, executable scripts, and unfinished placeholder text.

Validated with:

```bash
bash tests/validate-structure.sh
git diff --check
```

## Fit With Solana AI Kit

The skill follows the reference shape requested by the listing:

- a `skill/` directory;
- a `SKILL.md` entry point;
- focused `.md` files loaded only when needed;
- optional `agents/`, `commands/`, and `rules/`;
- an installer script;
- a clear README;
- MIT license;
- public GitHub repository.

It is safe to merge, submodule, or adapt because it does not include opaque binaries,
network side effects, wallet handling, private-key handling, transaction signing, or investment advice.

## Best-Fit Use Cases

- Pre-launch review for wallet dashboards, NFT apps, games, DeFi dashboards, indexers, and backend jobs.
- Provider selection and quota planning.
- RPC usage reduction before a launch or demo day.
- Post-incident review after 429s, provider throttling, or unexpected Solana infrastructure bills.
- Engineering handoff between product, backend, infra, and DevRel teams.

## Reviewer Shortcut

For the fastest review path:

1. Read `README.md` for the product problem and install flow.
2. Read `skill/SKILL.md` to verify progressive-disclosure routing and safety guardrails.
3. Read `examples/wallet-dashboard-review.md` for the expected output artifact.
4. Run `bash tests/validate-structure.sh`.
