---
name: four-file-project
description: Start a new project in the four-file system (AGENTS.md, SPEC.md, PLAN.md, STATUS.md with git). Use when the user gives a seed or idea and wants a project folder scaffolded, with SPEC.md and PLAN.md drafted for review.
---

# Four-file project

This skill turns the user's **seed** (a rough description of a project) into a project
folder that follows the four-file system. Read `reference/system.md` once if you need
the reasoning behind the rules; the rules themselves are in `templates/AGENTS.md`.

In this skill you act as the **top-level planner**. The user is the verifier of your
output. You do not execute any task.

## Steps

### 1. Get the seed

The seed comes from a file the user gives, or from the prompt itself. If the user has
nothing written, offer `seed-template.md` as a guide, but accept any form.

### 2. Scaffold the folder

Run `bash scaffold.sh <folder>` from this skill's directory. It copies the four templates
and runs `git init` if the folder is not already inside a repository.

- **Never write or edit `AGENTS.md` yourself.** It is copied verbatim so the rules are
  identical in every project. If you think a rule should change, tell the user; do not
  change it.
- If the script refuses because files exist, stop and ask the user.

### 3. Ask about what is missing

Read the seed and ask the user only about what it leaves unclear. At most five
questions, in one message. Seeds usually miss:

- **non-goals**: what not to build,
- **done**: how each main feature will be checked,
- **constraints**: language, allowed dependencies, platform,
- **size**: whether some part should be a subproject.

If the user is not available, choose the most reasonable reading, and record each
assumption in `SPEC.md` under Decisions with the reason "assumed from seed".

### 4. Write `SPEC.md`

Fill the template in the folder. Rules:

- Requirements are numbered (`R1`, `R2`, …) and each one is checkable.
- Non-goals are explicit. Include anything the seed says it does not want, and any
  obvious scope creep an agent might try.
- Constraints include the language and the dependency policy, since `AGENTS.md` forbids
  adding dependencies that `SPEC.md` does not allow.
- Interfaces are written only if there are subprojects.
- Remove template comments and unused optional sections.

### 5. Write `PLAN.md`

Fill the template in the folder. Rules:

- Every task has an ID (`T1`, `T2`, …), is marked **direct** or **delegated**, and
  lists `Depends on` where needed.
- Every task has **executable** "Done when" checks: commands with an expected result,
  or tests. "Works correctly" is not a check.
- Where you can, write the tests now, in the folder, and mark them "(provided)" in
  the plan. Tests written before execution are the strongest form of criteria.
- Each task fits one fresh session. A larger part becomes a delegated task; its
  subproject folder is created later by the agent that plans it, not now.
- The goal line cites the R-numbers it covers. Anything deferred goes under
  "Not in this plan".

### 6. Write `STATUS.md`

One row per task in `PLAN.md`, all `todo`. Empty Notes and Proposals. Remove template
comments.

### 7. Hand over for review

Show the user a short summary: the requirements, the tasks, and every assumption you
made. Point out anything you are unsure about. Then **stop and wait**.

- Do not commit before the user approves. They may edit the files themselves.
- After approval, commit everything with the message
  `PLAN: initial spec and plan`, and tell the user the commit hash. This commit is the
  baseline that later verification compares against.
- If the commit fails because git has no user name or email, tell the user the
  command to set them; do not set them yourself.

Do not start executing tasks. That is a separate session, run by the user.

## Checks before handing over

- `AGENTS.md` is identical to `templates/AGENTS.md` (`cmp` prints nothing).
- Every task ID in `PLAN.md` appears once in `STATUS.md`, and vice versa.
- Every requirement in `SPEC.md` is covered by some task, or listed as deferred.
- Every "Done when" line is something a program can check.
