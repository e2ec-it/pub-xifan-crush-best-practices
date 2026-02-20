---
name: sp-request-code-review
description: "Request review between tasks and before merge. Use git SHAs to scope changes and produce actionable findings."
---
# Superpowers: Requesting Code Review (Crush Adaptation)

Based on obra/superpowers `requesting-code-review` skill. (MIT)  
Upstream reference: skills/requesting-code-review/SKILL.md

## When
- After each task (especially in sp-subagent-dev)
- Before merge / PR
- When stuck

## How
1) Determine diff range (example):
```bash
BASE_SHA=$(git rev-parse HEAD~1)
HEAD_SHA=$(git rev-parse HEAD)
git diff --stat "$BASE_SHA..$HEAD_SHA"
```
2) Review along two axes:
- Spec compliance: matches plan/requirements, no extra scope
- Code quality: tests, readability, error handling, security
3) Severity labels: Critical / Important / Minor
- Fix Critical immediately
- Fix Important before proceeding
