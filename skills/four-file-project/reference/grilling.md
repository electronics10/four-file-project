# Grilling

Adapted from the `grilling` skill of SuperMatt (svyatov/supermatt), itself forked from
mattpocock/skills. MIT License; see `grilling-LICENSE`. Changes: trimmed to one
harness, and given a fixed end state (what SPEC.md and PLAN.md need).

## Goal

Interview the user until the frontier is empty: every decision that changes what gets
built is settled. In this skill, "settled" must cover at least the purpose, the
requirements and how each is checked, the non-goals, the constraints (language,
dependencies, platform, packages), and which parts are children.

## Method

Map the idea as a **design tree**: every decision branches into the decisions that
hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites
are already settled: the questions you can ask now without guessing at answers you
have not heard yet. Ask at most four frontier questions in one round, starting with the
ones whose answers remove the most other questions. Number each question (Q1, Q2, …)
across rounds and give your recommended answer. Before sending, test each pair: when
any option of one question would answer or reshape another, move the second to the
next round. Then wait for the answers.

Every choice question includes the smallest option: do nothing, reuse what exists, or
defer. Recommend it unless you can name a concrete case the user will hit where it
fails. When you recommend more, name what it adds (a field, a state, a command, a
file, a concept) and what breaks without it.

## Asking

Use the harness's native question tool when it is available (in Claude Code,
`AskUserQuestion`), following its live limits. Put the recommended option first and
mark it as recommended. Describe each option's tradeoff. Keep the Q-number in the
prompt. Use the tool's built-in custom-answer field instead of adding an "Other"
option. Ask an open question in chat rather than inventing choices to fit a schema.
Without a question tool, use chat:

```
❓ **Q1** - **<title>**: <question, with choices>

➡️ <recommended answer>
```

Wait for actual answers. A timeout, cancellation, or unanswered question leaves the
decision open.

## Facts are yours, decisions are the user's

Never ask the user for a fact you can find yourself (files, tools, versions, existing
code). Find it, with a sub-agent if it takes time; only questions that depend on it
wait. When the user disputes a premise, settle it with the most direct evidence you
can get before the decision goes back to them.

Ask only questions whose answer changes what gets built or what the user sees. A
detail the executor can settle alone is not a question.

## End

When the frontier is empty, summarize every settled decision in one table and ask the
user to confirm the shared understanding. Do not write files before they confirm.
