---
name: sp-executing-plans
description: "Execute a written plan in batches with checkpoints; stop on blockers; finish via sp-finish-branch."
---
# Superpowers: Executing Plans (Crush Adaptation)

Based on obra/superpowers `executing-plans` skill. (MIT)  
Upstream reference: skills/executing-plans/SKILL.md

## Steps
1. Load and review the plan critically. Raise concerns before starting.
2. Execute a batch (default: first 3 tasks), following steps exactly.
3. After each batch: report what changed + verification output, then wait for feedback.
4. Repeat until all tasks done.
5. Finish with **sp-finish-branch**.

## Stop immediately when
- Blocked mid-batch (deps missing, tests failing, instructions unclear)
- Plan has critical gaps
- Verification repeatedly fails

Do not guess. Ask for clarification.
