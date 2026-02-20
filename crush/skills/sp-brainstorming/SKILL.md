---
name: sp-brainstorming
description: "SUPERPOWERS-style brainstorming: MUST run before implementing features/behavior changes. Clarify intent, propose options, present design, get approval."
---
# Superpowers: Brainstorming (Crush Adaptation)

Based on obra/superpowers `brainstorming` skill. (MIT)  
Upstream reference: skills/brainstorming/SKILL.md

## Rules
- Do **not** write production code or change files until a design is presented and the user approves it.
- Ask **one** clarifying question per message.
- Always propose **2–3 approaches** with tradeoffs and a recommendation.

## Checklist (do in order)
1. Explore repo context (read relevant files/docs; check conventions).
2. Ask clarifying questions (one at a time) until constraints + success criteria are clear.
3. Propose 2–3 approaches with tradeoffs; recommend one.
4. Present the design in sections (architecture/components/data flow/errors/testing). Ask for approval after each section.
5. Save a design note to `docs/plans/YYYY-MM-DD--design.md` (or your repo's convention) and commit.
6. Transition to **sp-writing-plans** to produce a task-by-task implementation plan.

## Terminal state
The only valid next skill after this is **sp-writing-plans**.
