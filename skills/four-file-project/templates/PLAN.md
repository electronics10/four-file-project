# PLAN: <project name>

Written by the level above. Read-only for agents in this folder.

**Goal of this plan:** <what "finished" means for this iteration, citing R-numbers in SPEC.md>.

<!-- Each task: an ID, direct or delegated, dependencies, and executable "Done when" checks.
     Each task should fit in one fresh session; if not, make it a subproject.
     Write the tests before execution when possible, and mark them "(provided)".
     Task IDs are append-only: do not edit a task after work on it has started.
     Keep it, add "(superseded by Tn)" to its heading, and add a new task. -->

## Tasks

### T1 <short name> (direct)

- **Do:** ...
- **Done when:**
  - `<command>` exits with code 0
  - `pytest tests/<file>.py` passes (provided)

### T2 <short name> (delegated → `<child>/`)

- **Depends on:** T1
- **Do:** plan and verify child `<child>/`, implementing the interface in SPEC.md.
- **Done when:**
  - all `<child>/` tasks are verified by you
  - `<child>/contracts/<test>` passes (provided)

### T3 Upgrade `<package>` to `<version>` (direct)

- **Do:** update the dependency file to the version pinned in SPEC.md Constraints.
- **Done when:**
  - `package-contracts/<package>/` tests pass against `<package>==<version>` (provided)

## Not in this plan

<!-- Things deliberately left for a later plan (not the same as SPEC non-goals,
     which are never to be built). -->

- ...
