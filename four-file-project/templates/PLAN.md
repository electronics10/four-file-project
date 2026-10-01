# PLAN: <project name>

Written by the level above. Read-only for agents in this folder.

**Goal of this plan:** <what "finished" means for this iteration, citing R-numbers in SPEC.md>.

<!-- Each task: an ID, direct or delegated, dependencies, and executable "Done when" checks.
     Each task should fit in one fresh session; if not, make it a subproject.
     Write the tests before execution when possible, and mark them "(provided)". -->

## Tasks

### T1 <short name> (direct)

- **Do:** ...
- **Done when:**
  - `<command>` exits with code 0
  - `pytest tests/<file>.py` passes (provided)

### T2 <short name> (delegated → `<subproject>/`)

- **Depends on:** T1
- **Do:** plan and verify subproject `<subproject>/`, implementing the interface in SPEC.md.
- **Done when:**
  - all `<subproject>/` tasks are verified by you
  - `<contract test>` passes (provided)

## Not in this plan

<!-- Things deliberately left for a later plan (not the same as SPEC non-goals,
     which are never to be built). -->

- ...
