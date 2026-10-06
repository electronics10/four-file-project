# SPEC: <project name>

Written by the level above. Read-only for agents in this folder.

<!-- What the project is and why. Changes rarely. The "how" and the tasks go in PLAN.md. -->

## Purpose

<!-- One short paragraph: the problem, and who it is for. -->

## Requirements

<!-- Numbered so PLAN.md and STATUS.md can refer to them. Make each one checkable. -->

- **R1** ...
- **R2** ...

## Constraints

<!-- Language, versions, allowed dependencies, folder layout, platforms.
     List every package child with its exact version. -->

- ...
- **Packages:** `<package>==<exact version>` (package child; contract tests in
  `package-contracts/<package>/`).

## Non-goals

<!-- What NOT to build. Agents tend to expand scope, so be explicit. -->

- ...

## Decisions

<!-- Settled questions, so no one reopens them. Newest last. -->

- **D1** (YYYY-MM-DD) <decision>. *Reason:* <why>. *Evidence:* <run or commit, if a
  result motivated it>.

## Interfaces

<!-- Only if this project has children, or is used by siblings.
     Name, signature, data formats and conventions (units, axis order, coordinates),
     and behavior on errors. The parent owns these. Every interface lists its
     contract tests: small reference inputs with fixed expected outputs. -->

- `<child>` provides `<function, API, or file format>`: <behavior>.
  *Contract tests:* `<child>/contracts/<test>` (subfolder child) or
  `package-contracts/<package>/<test>` (package child).

## Glossary

<!-- Optional. Domain terms with a precise meaning in this project. -->

- **<term>**: <definition>.
