---
name: sp-finish-branch
description: "Finish development branch: verify tests, present 4 options (merge/PR/keep/discard), then cleanup worktree safely."
---
# Superpowers: Finishing a Development Branch (Crush Adaptation)

Based on obra/superpowers `finishing-a-development-branch` skill. (MIT)  
Upstream reference: skills/finishing-a-development-branch/SKILL.md

## Step 1: verify tests (mandatory)
Run the full suite. If failing, stop and fix before proceeding.

## Step 2: present exactly 4 options
1) Merge back to base locally  
2) Push and create PR  
3) Keep branch as-is (handle later)  
4) Discard this work (requires typed confirmation: `discard`)

## Step 3: execute choice + cleanup
- Only cleanup worktree for options 1/2/4
- Never delete work without explicit confirmation
