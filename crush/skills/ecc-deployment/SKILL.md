# ECC Deployment Patterns

Checklist:
- Health checks (readiness/liveness) + timeouts
- Rollback plan (previous image/tag, config rollback)
- Migrations: forward-only or safe rollback strategy
- Observability: logs, metrics, alerting basics
- Release: staged rollout if possible (canary/blue-green)

Artifacts to produce:
- A deploy script template with rollback
- A short runbook (how to deploy, verify, rollback)
