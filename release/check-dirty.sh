#!/usr/bin/bash
set -euxo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
cd $DIR

if ! git diff-index --quiet HEAD --; then
  echo "Dirty working tree after build:"
  git status --porcelain
  read -p "You have uncommitted changes, would you like to commit or stash them before continuing? (c/s)" choice
  case "$choice" in
    c) git commit -m "Committed changes before continuing";;
    s) git stash;;
    *) echo "Invalid choice";;
  esac
fi

echo "Latest commit message: $(git log -1 --pretty=%B)"
if [ -n "$(git ls-files --others --exclude-standard)" ]; then
  echo "Untracked files:"
  git ls-files --others --exclude-standard
fi
