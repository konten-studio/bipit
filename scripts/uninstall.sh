#!/bin/sh
# Remove the bipit skill from one agent's skill-discovery directory.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
. "$ROOT/scripts/path-lib.sh"

AGENT=
SCOPE=user
PREFIX=

usage() {
  echo "Usage: uninstall.sh --agent AGENT [--scope user|project] [--prefix DIR]"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --agent) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; AGENT=$2; shift 2 ;;
    --scope) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; SCOPE=$2; shift 2 ;;
    --prefix) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; PREFIX=$2; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

[ -n "$AGENT" ] || { echo "--agent is required" >&2; usage >&2; exit 2; }
reldir=$(bipit_resolve_reldir "$AGENT" "$SCOPE")

if [ "$SCOPE" = user ]; then
  base=${PREFIX:-$HOME}
else
  base=${PREFIX:-$(pwd)}
fi
bipit_validate_prefix "$base"

dest=$base/$reldir
target=$dest/bipit
manifest=$dest/.bipit-install.tsv

removed=0
if [ -L "$target" ]; then
  unlink "$target"
  removed=1
elif [ -d "$target" ]; then
  find "$target" -depth -delete
  removed=1
fi

if [ -f "$manifest" ]; then
  tmpf=$manifest.$$.tmp
  grep -v "^bipit-v1	$AGENT	$SCOPE	" "$manifest" > "$tmpf" 2>/dev/null || :
  if [ -s "$tmpf" ]; then
    mv "$tmpf" "$manifest"
  else
    rm -f "$tmpf" "$manifest"
  fi
fi

if [ "$removed" -eq 1 ]; then
  echo "Removed bipit skill from $target"
else
  echo "Nothing to remove at $target"
fi
