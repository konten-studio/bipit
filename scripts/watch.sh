#!/bin/sh
# Opt-in autosave: poll a git repo and commit any change.
# Never started automatically by bipit — run it yourself if you want it.
#
#   sh scripts/watch.sh ~/bipit
#
set -eu

DIR=${1:-$HOME/bipit}
[ -d "$DIR/.git" ] || { echo "Not a git repo: $DIR" >&2; exit 1; }

echo "Watching $DIR for changes — Ctrl-C to stop."
while :; do
  if [ -n "$(git -C "$DIR" status --porcelain)" ]; then
    git -C "$DIR" add -A
    git -C "$DIR" commit -q -m "bipit: autosave $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "committed $(date -u +%H:%M:%S)"
  fi
  sleep 5
done
