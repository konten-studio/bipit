# Adapter notes

`skills/bipit/` is the single source of truth. The installer
(`scripts/install.sh`, wrapped by `npx bipit`) maps that one directory into
each agent's skill-discovery location — there are no forked skill copies here.

| Agent | How bipit is discovered |
|---|---|
| Claude Code | native plugin manifest (`.claude-plugin/`) or installer symlink into `~/.claude/skills` |
| Codex | native plugin manifest (`.codex-plugin/`) or installer symlink into `~/.codex/skills` |
| Cursor | installer symlink into `~/.cursor/skills` |
| opencode | installer symlink into `~/.config/opencode/skills` |
| pi, agy, others | `AGENTS.md` fallback — read as repository instructions |

`AGENTS.md` is the thin fallback for tools that read repository instructions
but do not discover skills automatically. When pi and agy skill-directory
conventions are confirmed they will become first-class installer targets.
