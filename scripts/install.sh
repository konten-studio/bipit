#!/bin/sh
# Install the bipit skill into one agent's skill-discovery directory.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
. "$ROOT/scripts/path-lib.sh"

AGENT=
SCOPE=user
PREFIX=
METHOD=symlink
DRY_RUN=0

usage() {
  echo "Usage: install.sh --agent AGENT [--scope user|project] [--prefix DIR] [--copy|--symlink] [--dry-run]"
  echo "  AGENT: claude | codex | cursor | opencode"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --agent) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; AGENT=$2; shift 2 ;;
    --scope) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; SCOPE=$2; shift 2 ;;
    --prefix) [ "$#" -ge 2 ] || { usage >&2; exit 2; }; PREFIX=$2; shift 2 ;;
    --copy) METHOD=copy; shift ;;
    --symlink) METHOD=symlink; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
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

src=$ROOT/skills/bipit
[ -f "$src/SKILL.md" ] || { echo "Cannot find skill source at $src" >&2; exit 1; }

dest=$base/$reldir
target=$dest/bipit
manifest=$dest/.bipit-install.tsv

if [ -e "$target" ] || [ -L "$target" ]; then
  echo "Refusing to overwrite existing path: $target" >&2
  exit 1
fi

if [ "$DRY_RUN" -eq 1 ]; then
  echo "Would install bipit skill to $target using $METHOD"
  exit 0
fi

mkdir -p "$dest"

complete=0
cleanup_partial() {
  [ "$complete" -eq 1 ] && return
  if [ -L "$target" ]; then
    unlink "$target"
  elif [ -d "$target" ]; then
    find "$target" -depth -delete
  fi
}
trap cleanup_partial EXIT HUP INT TERM

if [ "$METHOD" = symlink ]; then
  ln -s "$src" "$target"
else
  cp -R "$src" "$target"
fi

printf 'bipit-v1\t%s\t%s\t%s\n' "$AGENT" "$SCOPE" "$METHOD" >> "$manifest"
complete=1
echo "Installed bipit skill to $target ($METHOD)"
echo "Now open your agent and run: /bipit"
