---
name: sp-writing-plans
description: "SUPERPOWERS-style implementation planning: turn an approved design into 2–5 minute tasks with exact file paths, commands, verifications, and frequent commits."
---
# Superpowers: Writing Plans (Crush Adaptation)

Based on obra/superpowers `writing-plans` skill. (MIT)  
Upstream reference: skills/writing-plans/SKILL.md

## Announce
Start with: “I’m using **sp-writing-plans** to create the implementation plan.”

## Output location
Save to: `docs/plans/YYYY-MM-DD--<feature>.md` (or your repo convention)

## Task granularity (strict)
Each task is 2–5 minutes and one action at a time:
- Write failing test
- Run to confirm failure (show expected failure)
- Write minimal implementation
- Run to confirm pass
- Commit

## Plan header template
```markdown
# <Feature> Implementation Plan
> For agent: execute with sp-executing-plans (batch) or sp-subagent-dev (per-task).
**Goal:** <one sentence>
**Architecture:** <2–3 sentences>
**Tech stack:** <key libs/tools>
---
```

## Per-task template
````markdown
### Task N: <name>
**Files:**
- Create: `path/to/new`
- Modify: `path/to/existing:line-range`
- Test: `path/to/test`

**Step 1: Write failing test**
```<lang>
...
```

**Step 2: Run to verify RED**
Run: `<exact command>`
Expect: `<FAIL message you expect>`

**Step 3: Minimal implementation**
```<lang>
...
```

**Step 4: Run to verify GREEN**
Run: `<exact command>`
Expect: `PASS`

**Step 5: Commit**
```bash
git add ...
git commit -m "feat: ..."
```
````

## After saving plan
Ask which execution mode:
1) **sp-subagent-dev** (per-task, review loops)  
2) **sp-executing-plans** (batch execution with checkpoints)
