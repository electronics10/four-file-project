# The four-file system

To facilitate AI-aided programming, I came up with a ***four-file system***.

## The folder and git

A project should always be self-contained in a folder, and the folder is a git
repository. Git is not optional here, and the whole system rests on it. It does four jobs:

1. **History.** No one needs to keep a diary by hand.
2. **Detection.** Any edit to a protected file shows up in the diff.
3. **Rollback.** A failed attempt can simply be discarded.
4. **Unit of verification.** What gets checked is a commit, not "the folder at some moment."

## The four files

| File | Written by | Changes | Content |
|---|---|---|---|
| `AGENTS.md` | level above | never (same everywhere) | rules: how to behave |
| `SPEC.md` | level above | rarely | what the project is, and why |
| `PLAN.md` | level above | per iteration | tasks with IDs and acceptance criteria |
| `STATUS.md` | this level | constantly | current state |

- `AGENTS.md` is identical in every project and subproject. It is auto-loaded by most
  tools, so it stays short.
- `SPEC.md` holds the purpose, requirements, constraints, non-goals, key decisions with
  reasons, interfaces, and a glossary if needed.
- `PLAN.md` holds the tasks. Each task has an ID, is either *direct* (executed here) or
  *delegated* (to a subproject), and has acceptance criteria, meaning concrete checks
  (preferably tests) that decide whether it is done.
- `STATUS.md` holds each task's status by ID, notes that git cannot explain, and
  proposals for changing the plan. It is overwritten, not appended, and committed after
  each update. As one can see, `git log -p STATUS.md` then gives the full history for free.

The rule for splitting files: a new file is justified only when its owner, its rate of
change, or its loading behavior differs. Otherwise it is a section, not a file.

Obviously, the agent at a given level should not edit `AGENTS.md`, `SPEC.md`, or
`PLAN.md`. I do not try to prevent this mechanically. Instead, the level above detects
it with git: between its last trusted commit and the reported commit, the diff on those
three files must be empty.

## Three roles

There are three roles: **planner**, **executor**, and **verifier**. Roles are not the
same as agents, and what matters is which roles may be merged:

- **Planner + verifier:** acceptable, since the criteria are fixed before the work exists.
- **Planner + executor:** avoided for the same work, since the plan bends toward what
  was easy to build.
- **Executor + verifier:** never, since that is self-grading.

For a personal project, one agent acting as planner and verifier, with a separate
subagent as executor, is fine.

**The planner** works before any work starts. It writes the child's `AGENTS.md` (a
copy), `SPEC.md`, and `PLAN.md`, and it does not touch code. Ideally it also writes the
tests first, so the acceptance criteria are executable. It checks the handoff: could a
new contractor do the job from these files alone? It also sizes tasks so each fits in
one fresh session. A task that is too big becomes a subproject.

**The executor** writes code and its own `STATUS.md`, and nothing else. If it is
blocked or keeps failing, it marks the task `blocked` with the reason and stops, rather
than looping.

**The verifier** works after the executor reports. It treats `STATUS.md` as a *claim*,
never as evidence. In a fresh session, it checks out the reported commit, runs the
acceptance criteria itself, and checks with git that the protected files were not
touched. It does not fix anything; if it finds a bug, it reports it. Its verdict, e.g.
"T2 verified at `abc123`," goes into the parent's `STATUS.md`.

A parent may revise a child's `SPEC.md` or `PLAN.md` as its planner. But it asks upward
first when the change would alter what it was given itself (a requirement, constraint,
or non-goal in its own `SPEC.md`), change an interface others depend on, or loosen
acceptance criteria after seeing failing work. That is to say, one can only re-delegate
authority one has.

## Subprojects and recursion

The working agent does not do the work in subprojects but leaves it to subagents.
Toward a subproject it is a parent acting as planner and verifier, and the subagent
works under exactly the same four-file system. Every role at one level is an
"executor" from the viewpoint of the level above. At the top, I am the final verifier.
The best place for me to step in is reviewing plans before execution, because a bad
plan wastes a whole subtree while a bad commit wastes one task.

Knowledge flows in a loop. Executors record discoveries in the notes of their
`STATUS.md`. The planner above reads them and, if they matter beyond one task, promotes
them into the child's `SPEC.md` as decisions. When two sibling subprojects must fit
together, the interface is owned by the parent and written into the specs.

## Children: subfolders and packages

A child is a **subfolder child** by default: a subproject folder in the same
repository, verified with the git diff on its protected files. It becomes a **package
child** only when it crosses a reuse boundary: another project uses it, or it needs its
own releases. Delegation ("too big for one session") and reuse ("someone else installs
it") are different boundaries, and only reuse justifies a package.

A package child is its own top-level four-file project. The parent cannot see its
history, so the parent governs it by pinning instead: the exact version is listed in
`SPEC.md`, upgrades are `PLAN.md` tasks, and a verdict is recorded only against a
released, pinned version.

## Contracts

Every interface the parent owns comes with **contract tests**: small reference inputs
with fixed expected outputs, written by the parent before the work. Prose interfaces do
not fail when broken; tests do. Most integration bugs are convention bugs (units, axis
order, coordinate frames), and each child passing its own tests does not catch them.

## Specs that change

A spec may change with results, for example after an experiment. Only the planner above
changes it, so the executor is never confused about what is current. Task IDs are
append-only: a revised task is kept and marked superseded, and a new ID carries the new
criteria, so every recorded verdict points at one fixed definition. Each run records
its commit, config, run ID and metrics in `STATUS.md`, and a SPEC decision cites the run
that motivated it.

## Starting a project

I write a rough **seed**: what I want, what I do not want, and how I would check it
works. An agent grills me until every decision that changes what gets built is
settled, because at the start I often do not know exactly what I want. Then it
scaffolds the folder, copying `AGENTS.md` verbatim, and drafts `SPEC.md` and
`PLAN.md`. I review
and edit, and then it commits. That commit is the first trusted point for verification.

## Practical notes

- Many tools load every `AGENTS.md` from the repository root down, so a subagent may
  also read its parent's copy. Since every copy is identical and scoped to "this
  folder," this does no harm.
- Parallel subagents each work in their own git worktree, to avoid collisions.
- Executors run code, so they run in a sandbox. Secrets stay out of the repository, and
  anything read from the web or dependencies is untrusted input.
