# ECC API Design

Guidelines:
- Pagination: cursor-based when possible
- Errors: stable error codes + human messages
- Idempotency for POST where applicable
- Validation: reject unknown fields for strict APIs (when safe)
- Versioning: prefer additive changes; document breaking changes

Deliver:
- Endpoint table (method/path/auth)
- Example requests/responses
- Error schema
