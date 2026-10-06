# Promotion: subfolder child → package child

Use when a subfolder child gets a second user or needs its own releases. Plan it in
revise mode as one PLAN task in the parent. Do these steps in order; skipping one
leaves the child with no clear owner.

## Before

1. Verify the child's current work by the "Verifying a delegated task" rules. Record
   the verdict and commit in the parent's `STATUS.md`. This is the last diff-based
   verdict on the child.

## Move

2. Extract the folder with its history into a new repository:
   `git filter-repo --subdirectory-filter <child>` on a fresh clone (preferred), or
   `git subtree split --prefix=<child> -b <child>-split`.
3. In the new repository, the child is now a top-level project. Its `AGENTS.md`,
   `SPEC.md`, `PLAN.md`, `STATUS.md` stay as they are. Make it installable (for
   Python, a `pyproject.toml`) and tag the first release.

## Change ownership

4. **Planner:** the package's planner is now the user. The parent may no longer edit
   its `SPEC.md` or `PLAN.md`. Interface changes go to the user as Proposals.
5. **Contract tests:** move them from `<child>/contracts/` to the parent's
   `package-contracts/<package>/`. Keep a copy in the package's own tests if its
   planner wants it there; the parent's copy is the one that counts.
6. **Verification:** from now on, verdicts use pinned releases, not the git diff.

## Connect

7. In the parent: add `<package>==<version>` to `SPEC.md` Constraints, with a
   Decisions entry citing the reason for promotion. Point the interface's contract
   tests at `package-contracts/<package>/`.
8. Remove the subfolder from the parent, in the same commit that adds the dependency.

## Done when

- `package-contracts/<package>/` tests pass in the parent against `<package>==<version>`
  installed from the release, not an editable install.
- The parent no longer contains `<child>/`.
- `SPEC.md` lists the pin and the Decisions entry.
