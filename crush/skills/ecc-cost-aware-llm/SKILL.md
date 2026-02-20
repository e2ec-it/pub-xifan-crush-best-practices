# ECC Cost-Aware LLM Workflow

Rules:
- Choose smallest capable model for the job
- Cache and reuse results where feasible
- Avoid sending large logs/blobs; summarize first
- Track token usage and set budgets

Practical:
- Add logging for prompt+response sizes (sanitized)
- Add "budget exceeded" fallback behavior
- Provide a test mode that uses a cheaper model
