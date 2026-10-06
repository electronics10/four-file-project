#!/usr/bin/env bash
# Create a project (or subproject) folder in the four-file system.
#
#   bash scaffold.sh <folder>
#
# - Copies AGENTS.md verbatim, and SPEC.md, PLAN.md, STATUS.md as templates to fill in.
# - Runs `git init` only if <folder> is not already inside a git repository.
#   Inside a repository, the folder is a subproject of the enclosing project.
# - Refuses to overwrite a folder that already has any of the four files.

set -euo pipefail

target="${1:?usage: scaffold.sh <folder>}"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
files=(AGENTS.md SPEC.md PLAN.md STATUS.md)

for f in "${files[@]}"; do
  if [ -e "$target/$f" ]; then
    echo "error: $target/$f already exists; not overwriting" >&2
    exit 1
  fi
done

mkdir -p "$target"
for f in "${files[@]}"; do
  cp "$here/templates/$f" "$target/$f"
done

if git -C "$target" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  root="$(git -C "$target" rev-parse --show-toplevel)"
  echo "created subproject $target (inside repository $root)"
else
  git -C "$target" init -q
  echo "created project $target (new git repository)"
fi
