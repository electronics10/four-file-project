---
name: four-file-project
description: Start or revise a project in the four-file system (AGENTS.md, SPEC.md, PLAN.md, STATUS.md with git). Use when the user gives a seed or idea and wants a project folder scaffolded with SPEC.md and PLAN.md drafted for review, or when results, proposals, or blocked tasks in STATUS.md mean SPEC.md or PLAN.md must change.
---

# Four-file project

This skill acts as the **planner** for one folder in the four-file system. It has two
modes:

- **Start**: turn the user's seed into a new project folder.
- **Revise**: change an existing folder's `SPEC.md` or `PLAN.md` after results,
  Proposals, or blocked tasks.

Choose the mode from the folder: no four files → start. Four files present → revise.
If the user names a mode, use it.

The rules are in `templates/AGENTS.md`; read `reference/system.md` once if you need
the reasons behind them. Verifying a child's work is not a mode of this skill: the
"Verifying a delegated task" rules in `AGENTS.md` cover it.

In both modes you plan; you never execute tasks. The user, or the level above, is
the verifier of your output.

## Start mode

### 1. Get the seed

The seed comes from a file the user gives, or from the prompt itself. If the user has
nothing written, offer `seed-template.md` as a guide, but accept any form.

### 2. Grill

Always grill the user before writing anything, following `reference/grilling.md`.
Its end state is the content `SPEC.md` and `PLAN.md` need: purpose, requirements and
how each is checked, non-goals, constraints, and which parts are children. For each
child, settle whether it is a subfolder child (the default) or a package child (only
when another project uses it, or it needs its own releases), and what its interface
is.

If the user is not available, choose the most reasonable reading of the seed, and
record each assumption in `SPEC.md` under Decisions with the reason "assumed from
seed".

### 3. Scaffold the folder

After the user confirms the shared understanding, run `bash scaffold.sh <folder>`
from this skill's directory. It copies the four templates and runs `git init` if the
folder is not already inside a repository.

- **Never write or edit `AGENTS.md` yourself.** It is copied verbatim so the rules are
  identical in every project. If you think a rule should change, tell the user; do not
  change it.
- If the script refuses because files exist, stop and ask the user.

### 4. Write `SPEC.md`

Fill the template in the folder. Rules:

- Requirements are numbered (`R1`, `R2`, …) and each one is checkable.
- Non-goals are explicit. Include anything the seed says it does not want, and any
  obvious scope creep an agent might try.
- Constraints include the language and the dependency policy, since `AGENTS.md` forbids
  adding dependencies that `SPEC.md` does not allow. List every package child with its
  exact version.
- Interfaces are written only if there are children. Each interface states data
  formats and conventions (units, axis order, coordinate frames) and lists its contract
  tests.
- Remove template comments and unused optional sections.

### 5. Write `PLAN.md` and the contract tests

Fill the template in the folder. Rules:

- Every task has an ID (`T1`, `T2`, …), is marked **direct** or **delegated**, and
  lists `Depends on` where needed.
- Every task has **executable** "Done when" checks: commands with an expected result,
  or tests. "Works correctly" is not a check.
- Where you can, write the tests now, in the folder, and mark them "(provided)" in
  the plan. Tests written before execution are the strongest form of criteria.
- Write the contract tests for every interface now: in `<child>/contracts/` for a
  subfolder child, in `package-contracts/<package>/` for a package child. Every
  delegated task's "Done when" includes them.
- Each task fits one fresh session. A larger part becomes a delegated task; its
  subfolder is created later by the agent that plans it, not now. A package child is
  its own top-level project; suggest starting it with this skill in its own
  repository.
- The goal line cites the R-numbers it covers. Anything deferred goes under
  "Not in this plan".

### 6. Write `STATUS.md`

One row per task in `PLAN.md`, all `todo`. Empty Notes and Proposals. Remove template
comments.

### 7. Hand over for review

Show the user a short summary: the requirements, the children and their interfaces,
the tasks, and every assumption you made. Point out anything you are unsure about.
Then **stop and wait**.

- Do not commit before the user approves. They may edit the files themselves.
- After approval, commit everything with the message
  `PLAN: initial spec and plan`, and tell the user the commit hash. This commit is the
  baseline that later verification compares against.
- If the commit fails because git has no user name or email, tell the user the
  command to set them; do not set them yourself.

Do not start executing tasks. That is a separate session, run by the user.

## Revise mode

You revise a folder as its planner: the level above it. Never edit that folder's
`STATUS.md`; it belongs to the folder's own agent.

### 1. Read the state

Read the folder's `SPEC.md`, `PLAN.md`, `STATUS.md`, and `git log` since the last
`PLAN:` commit. Collect what triggers the revision: run results in Notes, Proposals,
`blocked` or `failed` tasks. Treat each as a claim. If a decision rests on a task being
done, verify it first by the "Verifying a delegated task" rules in `AGENTS.md`. A run
result without commit, config, and metrics is not evidence; ask for the run to be
recorded instead of deciding on it.

### 2. Decide who decides

Apply rule 7 of "Verifying a delegated task" in `AGENTS.md`. The decision goes to the
user when:

- the user is the planner of this folder (the top level), or
- the change would alter a requirement, constraint, or non-goal given from above,
  change an interface others depend on, or loosen criteria after failing work.

When the decision goes to the user, **grill them on it** with `reference/grilling.md`,
starting from the evidence: what was expected, what happened, which run. When it does
not, decide within your authority and record the reason in your own `STATUS.md` Notes.

### 3. Draft the changes

- **SPEC.md**: add a Decisions entry for every change, citing the run or commit that
  motivated it. Change requirements, constraints, non-goals, or interfaces only as
  decided in step 2.
- **PLAN.md**: never edit a task after work on it has started. Keep it, add
  `(superseded by Tn)` to its heading, and add the new task `Tn` with its own "Done
  when". Tasks not yet started may be edited or removed.
- **Contract tests**: change them only together with an interface decision in
  `SPEC.md`. Update every child that uses the interface.
- **Packages**: a new version is a new pin in `SPEC.md` Constraints plus an upgrade
  task whose "Done when" includes the contract tests. Turning a subfolder child into a
  package (promotion) is also a task: follow `reference/promotion.md`, and use its
  "Done when".
- If the folder's `AGENTS.md` has an older rules version, do not replace it. Tell the
  user; upgrading the rules is their decision.

### 4. Hand over

Show the user what changed and why, each change next to its evidence. If the user
decides (step 2), **stop and wait** for approval. Then commit with the message
`PLAN: revise after <task or run>`, and give the hash: it is the new baseline. If you
decided within your own authority, commit and record the hash in your own
`STATUS.md` Notes.

## Checks before handing over

Both modes:

- `AGENTS.md` is identical to `templates/AGENTS.md` (`cmp` prints nothing), or, in
  revise mode, unchanged since the baseline.
- Every task ID in `PLAN.md` appears once in `STATUS.md`, and vice versa (in revise
  mode, new IDs are added by the folder's agent; list them for the user).
- Every requirement in `SPEC.md` is covered by some task, or listed as deferred.
- Every "Done when" line is something a program can check.
- Every interface lists contract tests, and the files exist.

Revise mode also:

- `git diff` of `PLAN.md` changes no started task except its `(superseded by Tn)`
  marker, and every superseded task has a replacement.
- Every `SPEC.md` change has a Decisions entry with its evidence.
