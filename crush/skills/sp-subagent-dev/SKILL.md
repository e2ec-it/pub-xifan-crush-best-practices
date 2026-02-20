---
name: sp-subagent-dev
description: "Execute plan per task with role separation and review loops (spec then quality). In Crush, simulate subagents via role prompts / new sessions."
---
# Superpowers: Subagent-Driven Development (Crush Adaptation)

Based on obra/superpowers `subagent-driven-development` skill. (MIT)  
Upstream reference: skills/subagent-driven-development/SKILL.md

## Core idea
For each plan task:
1) **Implementer** executes the task using **sp-tdd** and commits.  
2) **Spec reviewer** checks compliance to the plan/spec.  
3) **Quality reviewer** checks code quality and maintainability.  
Repeat review loops until ✅.

## Crush note
Crush may not have a native “Task tool” / “subagent tool”. Simulate this by:
- Spawning a new Crush session per role, or
- Using explicit role headers in prompts (“ROLE: Implementer”, “ROLE: Spec reviewer”, etc.).

## Non-negotiables
- Spec review happens **before** quality review.
- If reviewer finds issues, fix then re-review.
- Do not start on main/master without explicit user consent.
