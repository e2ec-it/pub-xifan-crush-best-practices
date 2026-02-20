# ECC Code Review

Review checklist:
- Correctness: logic matches requirements; handles errors; no silent failure
- Readability: naming, small functions, clear invariants
- Tests: coverage for new behavior; no brittle tests
- Performance: no obvious N+1, unbounded loops, large allocations
- DX: helpful logs; clear errors; docs updated if needed

Provide:
- Must-fix items
- Nice-to-have improvements
- Suggested patch/diff if practical
