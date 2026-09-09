# shellcheck shell=sh
# Shared helpers for install.sh / uninstall.sh and the test suite.
# Sourcing this file has no side effects.

# bipit_validate_prefix ABSOLUTE_PATH
# Exits 2 with a message if the path is not absolute, contains control
# characters, or contains path-traversal segments.
bipit_validate_prefix() {
  _p=$1
  case "$_p" in
    /*) ;;
    *) echo "Prefix must be an absolute path" >&2; exit 2 ;;
  esac
  case "$_p" in
    *'/../'*|*/..|*'/./'*|*/.) echo "Unsafe prefix: path traversal segments are not allowed" >&2; exit 2 ;;
  esac
  if [ "$(printf '%s' "$_p" | wc -l | tr -d ' ')" -ne 0 ] || printf '%s' "$_p" | grep -q "$(printf '\t')"; then
    echo "Unsafe prefix: control characters are not allowed" >&2
    exit 2
  fi
}

# bipit_resolve_reldir AGENT SCOPE
# Echoes the skill directory (relative to the install base) for the given
# agent and scope, or exits 2 for an unsupported agent/scope.
bipit_resolve_reldir() {
  _agent=$1
  _scope=$2
  case "$_scope" in
    user)
      case "$_agent" in
        claude) echo ".claude/skills" ;;
        codex) echo ".codex/skills" ;;
        cursor) echo ".cursor/skills" ;;
        opencode) echo ".config/opencode/skills" ;;
        *) echo "Unsupported agent: $_agent" >&2; exit 2 ;;
      esac
      ;;
    project)
      case "$_agent" in
        claude) echo ".claude/skills" ;;
        codex) echo ".agents/skills" ;;
        cursor) echo ".cursor/skills" ;;
        opencode) echo ".opencode/skills" ;;
        *) echo "Unsupported agent: $_agent" >&2; exit 2 ;;
      esac
      ;;
    *) echo "Unsupported scope: $_scope" >&2; exit 2 ;;
  esac
}
