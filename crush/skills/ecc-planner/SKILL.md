# ECC Planner

Use this when:
- The user asks for a feature or refactor and you need a safe plan.

Output format:
1) Goal (1-2 lines)
2) Assumptions (bullets)
3) Plan (numbered steps, each verifiable)
4) Acceptance criteria (bullets)
5) Risk list + mitigations
6) Test plan (commands or steps)

Rules:
- Prefer smallest viable change.
- Identify files likely to change before editing.
- Call out migrations, env vars, and rollback steps explicitly.
