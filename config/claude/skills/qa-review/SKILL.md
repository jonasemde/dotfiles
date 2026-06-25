---
name: qa-review
description: Pre-commit/pre-PR quality assurance review. Analyzes uncommitted changes and branch diff against origin main/master to catch issues, question solution quality, and verify completeness before shipping.
---

# QA Review

Run this skill before creating a commit or pull request to critically review your changes.

## Workflow

### Step 1: Gather context

Run all of the following in parallel:

```bash
# Uncommitted changes (staged + unstaged)
git diff HEAD

# Untracked files
git status --short

# Determine default branch
git remote show origin | grep 'HEAD branch'
```

Then diff the full branch against origin:

```bash
# Replace <default-branch> with main or master as detected
git fetch origin <default-branch>
git diff origin/<default-branch>...HEAD
```

Also combine with the uncommitted diff to get the **complete picture** of what would ship.

### Step 2: Read all changed files in full

For every file that appears in the diffs, read the **full current version** of the file (not just the diff hunks). You need surrounding context to judge whether the solution fits.

### Step 3: Critical QA analysis

Analyze the changes through these lenses. Be honest and direct — the goal is to catch problems before they ship, not to validate the author.

#### 3a. Is this the best solution?

- Is the approach appropriate for the problem, or is there a simpler/more idiomatic way?
- Are there unnecessary abstractions, over-engineering, or premature generalizations?
- Does it duplicate logic that already exists elsewhere in the codebase?
- Would a different data structure, pattern, or library make this cleaner?

#### 3b. Are there remaining QA concerns?

- Are edge cases handled (nulls, empty collections, boundary values, concurrency)?
- Is error handling sufficient and consistent with the rest of the codebase?
- Are there missing or inadequate tests for the changed behavior?
- Could this break existing tests or functionality?
- Are there performance implications (N+1 queries, unbounded loops, missing indexes)?

#### 3c. Was everything considered?

- Are all acceptance criteria or requirements addressed?
- Are related files that should have been updated but weren't (migrations, configs, docs, translations, routes)?
- Are there TODO/FIXME/HACK comments that should be resolved before merging?
- Is the change complete, or does it leave the codebase in a halfway state?

#### 3d. What could go wrong?

- Could this introduce a regression in related features?
- Are there security concerns (injection, auth bypass, data exposure, path traversal)?
- Are there race conditions or state consistency issues?
- Could this cause problems in production that wouldn't surface in dev/test (environment differences, data volume, permissions)?
- Is backwards compatibility preserved where needed (APIs, database schema, config)?

### Step 4: Report

Present findings in this format:

```
## QA Review Summary

### Critical Issues
[Issues that MUST be fixed before shipping — bugs, security holes, data loss risks]

### Warnings
[Things that are likely problematic but may be acceptable with justification]

### Suggestions
[Improvements that would make the code better but aren't blockers]

### Verdict
[PASS / PASS WITH WARNINGS / FAIL — with a one-line justification]
```

If there are no issues at all, say so — but be genuinely critical, not rubber-stamping. An empty review is a red flag that the review wasn't thorough enough.

## Important

- Do NOT just summarize the diff. The author knows what they changed. Focus on what they might have **missed**.
- If unsure about project conventions, check existing code for patterns before flagging something as wrong.
- Consider the **combined effect** of all changes together, not just each file in isolation.
- If the branch diff reveals pre-existing issues that are unrelated to the current work, mention them separately under a "Pre-existing issues" section — don't mix them with the current review.
