---
name: sp-tdd
description: "SUPERPOWERS TDD enforcement: NO production code without a failing test first. Delete code written before tests."
---
# Superpowers: Test-Driven Development (Crush Adaptation)

Based on obra/superpowers `test-driven-development` skill. (MIT)  
Upstream reference: skills/test-driven-development/SKILL.md

## The iron law
**NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST**

If you wrote code before seeing the test fail:
- Delete that code.
- Re-implement from the tests.

## Cycle: RED → GREEN → REFACTOR
- RED: write one minimal behavior test, run it, confirm it fails **for the right reason** (not syntax).
- GREEN: write the smallest implementation to pass.
- REFACTOR: clean up while staying green.

## Exceptions
Only with explicit user approval (throwaway prototypes, config-only changes, etc.).

## Stop conditions
If you cannot get a clean RED (fails correctly), stop and fix the test until it fails correctly.
