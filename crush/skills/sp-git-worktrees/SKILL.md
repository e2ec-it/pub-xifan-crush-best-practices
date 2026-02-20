---
name: sp-git-worktrees
description: "Create isolated worktree for feature work; verify ignore rules; run baseline tests before work."
---
# Superpowers: Using Git Worktrees (Crush Adaptation)

Based on obra/superpowers `using-git-worktrees` skill. (MIT)  
Upstream reference: skills/using-git-worktrees/SKILL.md

## Directory priority
1) `.worktrees/` if exists (preferred)  
2) `worktrees/` if exists  
3) If neither exists: check `CLAUDE.md` / project docs for preference; otherwise ask user.

## Safety check (mandatory for project-local worktrees)
Verify worktree directory is ignored:
```bash
git check-ignore -q .worktrees 2>/dev/null || git check-ignore -q worktrees 2>/dev/null
```
If not ignored: add to `.gitignore`, commit, then proceed.

## Create worktree (example)
```bash
BRANCH_NAME="feature/<name>"
git worktree add ".worktrees/$BRANCH_NAME" -b "$BRANCH_NAME"
cd ".worktrees/$BRANCH_NAME"
```

## Baseline verification
Auto-detect setup (npm/cargo/poetry/go) then run the test suite.
If baseline tests fail: report and ask whether to proceed or investigate first.
