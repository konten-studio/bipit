#!/bin/sh
# Shell test suite for path-lib.sh, install.sh, uninstall.sh, verify-install.sh.
# No external test framework — plain assertions over temp dirs.
set -eu

here=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
. "$here/scripts/path-lib.sh"

fail=0
check() {
  if [ "$1" = "$2" ]; then
    echo "ok   - $3"
  else
    echo "FAIL - $3 (got '$1' want '$2')"
    fail=1
  fi
}
ok() { echo "ok   - $1"; }
bad() { echo "FAIL - $1"; fail=1; }

work=$(mktemp -d)
cleanup() { rm -rf "$work"; }
trap cleanup EXIT HUP INT TERM

# --- path-lib: bipit_resolve_reldir -------------------------------------------
check "$(bipit_resolve_reldir claude user)" ".claude/skills" "claude user dir"
check "$(bipit_resolve_reldir claude project)" ".claude/skills" "claude project dir"
check "$(bipit_resolve_reldir codex user)" ".codex/skills" "codex user dir"
check "$(bipit_resolve_reldir codex project)" ".agents/skills" "codex project dir"
check "$(bipit_resolve_reldir cursor user)" ".cursor/skills" "cursor user dir"
check "$(bipit_resolve_reldir cursor project)" ".cursor/skills" "cursor project dir"
check "$(bipit_resolve_reldir opencode user)" ".config/opencode/skills" "opencode user dir"
check "$(bipit_resolve_reldir opencode project)" ".opencode/skills" "opencode project dir"

# --- path-lib: bipit_validate_prefix ----------------------------------------
if (bipit_validate_prefix "relative/path") 2>/dev/null; then bad "rejects relative prefix"; else ok "rejects relative prefix"; fi
if (bipit_validate_prefix "/tmp/../etc") 2>/dev/null; then bad "rejects traversal prefix"; else ok "rejects traversal prefix"; fi
if (bipit_validate_prefix "/tmp/./x") 2>/dev/null; then bad "rejects dot-segment prefix"; else ok "rejects dot-segment prefix"; fi
if (bipit_validate_prefix "$work") 2>/dev/null; then ok "accepts clean absolute prefix"; else bad "accepts clean absolute prefix"; fi

# --- install.sh -------------------------------------------------------------
t1=$work/t1; mkdir -p "$t1"
sh "$here/scripts/install.sh" --agent claude --scope user --prefix "$t1" --dry-run >"$work/dry.out" 2>&1
if [ -e "$t1/.claude" ]; then bad "dry-run creates nothing"; else ok "dry-run creates nothing"; fi
grep -q "Would install" "$work/dry.out" && ok "dry-run prints plan" || bad "dry-run prints plan"

sh "$here/scripts/install.sh" --agent claude --scope user --prefix "$t1" --symlink >/dev/null
if [ -L "$t1/.claude/skills/bipit" ]; then ok "symlink install creates a link"; else bad "symlink install creates a link"; fi
if grep -q "bipit-v1	claude	user	symlink" "$t1/.claude/skills/.bipit-install.tsv"; then ok "manifest records the install"; else bad "manifest records the install"; fi

if sh "$here/scripts/install.sh" --agent claude --scope user --prefix "$t1" --symlink 2>/dev/null; then bad "refuses to overwrite existing target"; else ok "refuses to overwrite existing target"; fi

t2=$work/t2; mkdir -p "$t2"
sh "$here/scripts/install.sh" --agent codex --scope project --prefix "$t2" --copy >/dev/null
if [ -d "$t2/.agents/skills/bipit" ] && [ ! -L "$t2/.agents/skills/bipit" ]; then ok "copy install creates a real directory"; else bad "copy install creates a real directory"; fi
if [ -f "$t2/.agents/skills/bipit/SKILL.md" ]; then ok "copy install includes SKILL.md"; else bad "copy install includes SKILL.md"; fi

if sh "$here/scripts/install.sh" --agent bogus --scope user --prefix "$t2" 2>/dev/null; then bad "rejects unknown agent"; else ok "rejects unknown agent"; fi

# --- uninstall.sh ---------------------------------------------------------
t3=$work/t3; mkdir -p "$t3"
sh "$here/scripts/install.sh" --agent claude --scope user --prefix "$t3" --symlink >/dev/null
sh "$here/scripts/uninstall.sh" --agent claude --scope user --prefix "$t3" >/dev/null
if [ -e "$t3/.claude/skills/bipit" ] || [ -L "$t3/.claude/skills/bipit" ]; then bad "uninstall removes the skill"; else ok "uninstall removes the skill"; fi
if [ -e "$t3/.claude/skills/.bipit-install.tsv" ]; then bad "uninstall removes the emptied manifest"; else ok "uninstall removes the emptied manifest"; fi
if sh "$here/scripts/uninstall.sh" --agent claude --scope user --prefix "$t3" >/dev/null 2>&1; then ok "uninstall is idempotent"; else bad "uninstall is idempotent"; fi

# --- verify-install.sh --------------------------------------------------
if sh "$here/scripts/verify-install.sh" "$here/skills/bipit" >/dev/null 2>&1; then ok "verify-install passes on the shipped skill"; else bad "verify-install passes on the shipped skill"; fi

exit $fail
