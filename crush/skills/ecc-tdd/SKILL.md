# ECC TDD Workflow

Default cycle:
1) Write/extend tests (failing)
2) Implement minimal code to pass
3) Refactor (only after green)
4) Re-run tests and lint

Checklist:
- Tests cover: happy path, edge cases, error cases
- Deterministic: no time/network flakes unless mocked
- Clear assertions; avoid over-mocking

If tests are expensive:
- Add a fast unit layer first
- Add integration/E2E only where needed
