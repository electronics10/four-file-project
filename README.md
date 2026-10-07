# four-file-project

One skill, two modes:

- **Start**: grill the seed, scaffold the folder, draft SPEC.md and PLAN.md with contract tests, stop for review.
- **Revise**: after results, Proposals, or blocked tasks, change SPEC.md and PLAN.md as the planner, with evidence, append-only task IDs, and a new baseline commit.

Rules version 2 (`templates/AGENTS.md`) adds: contract tests, subfolder vs package children, pinned versions for verdicts, run recording, tracker-free skills only, superseded tasks.

`reference/grilling.md` is adapted from SuperMatt (MIT); see `reference/grilling-LICENSE`.

## Install

In Claude Code:

```text
/plugin marketplace add YOUR-GITHUB-USERNAME/four-file-project
/plugin install four-file-project@four-file-project
```

In the Claude app, install the `.plugin` file built from this repository (`zip -r four-file-project.plugin . -x ".git/*"`).

## License

MIT, see `LICENSE`. `reference/grilling.md` keeps its own MIT notice from SuperMatt.
