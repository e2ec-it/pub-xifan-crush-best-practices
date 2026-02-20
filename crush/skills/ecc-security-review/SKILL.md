# ECC Security Review

Checklist:
- Input validation and output encoding
- AuthN/AuthZ boundaries (who can call what)
- Secrets: no hardcoded tokens/keys; env vars only
- Dependency risk: check lockfile changes; prefer pinned versions
- SSRF / RCE vectors (URLs, file paths, shells)
- SQL/NoSQL injection checks

Deliver:
- Top risks + severity
- Concrete mitigations
- Tests for the highest-risk paths
