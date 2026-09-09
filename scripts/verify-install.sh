#!/bin/sh
# Check that a bipit skill directory is discoverable with valid frontmatter.
set -eu

arg=${1:-}
[ -n "$arg" ] || { echo "Usage: verify-install.sh <skill-dir-or-SKILL.md>" >&2; exit 1; }

if [ -d "$arg" ]; then
  skill=$arg/SKILL.md
else
  skill=$arg
fi

[ -f "$skill" ] || { echo "SKILL.md not found at $skill" >&2; exit 1; }

fm=$(awk 'NR==1 && $0=="---"{f=1;next} f && $0=="---"{exit} f{print}' "$skill")
printf '%s\n' "$fm" | grep -Eq '^name:[[:space:]]*[^[:space:]]' || { echo "frontmatter: missing or empty 'name'" >&2; exit 1; }
printf '%s\n' "$fm" | grep -Eq '^description:[[:space:]]*[^[:space:]]' || { echo "frontmatter: missing or empty 'description'" >&2; exit 1; }

echo "OK: $skill has valid frontmatter"
