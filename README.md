<div align="center">

<sub>Konten Studio presents</sub>

```text
      ██████╗ ██╗██████╗ ██╗████████╗
      ██╔══██╗██║██╔══██╗██║╚══██╔══╝
      ██████╔╝██║██████╔╝██║   ██║
      ██╔══██╗██║██╔═══╝ ██║   ██║
      ██████╔╝██║██║     ██║   ██║
      ╚═════╝ ╚═╝╚═╝     ╚═╝   ╚═╝
```

### The session already happened. **bip-it.**

**EN** — You shipped something good this session. bipit turns it into an honest build-in-public post — in your voice, before you've closed the terminal.
**ID** — Lo baru ngerjain sesuatu yang bagus sesi ini. bipit ubah itu jadi post build-in-public yang jujur — pakai gaya nulis lo, sebelum terminal-nya lo tutup.

[![npm version](https://img.shields.io/npm/v/@konten-studio/bipit.svg)](https://www.npmjs.com/package/@konten-studio/bipit)
[![npm downloads](https://img.shields.io/npm/dm/@konten-studio/bipit.svg)](https://www.npmjs.com/package/@konten-studio/bipit)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![status: v1](https://img.shields.io/badge/status-v1-purple.svg)](docs/superpowers/specs/2026-09-09-bipit-v1-design.md)

</div>

---

## The problem

You just spent two hours in your agent untangling a race condition, or shipping
a feature, or making a call you'll want to remember. That's the story people
who follow your work actually want.

But the build-in-public post never happens — you're tired, you're onto the next
thing. Or it does happen and it's *"Excited to share that we just shipped
🚀🚀"* — a sentence that could be about anything, from anyone. Two hours of real
decisions, flattened into a line that sounds like every other line.

## What bipit is

**One skill.** It rides inside the coding agent you already use — Claude Code,
Codex, opencode, Cursor. No daemon, no separate API key, no second model. When
you run `/bipit`, your agent reads what you did this session and drafts a post
you approve.

bipit is the lighter sibling of [**bipos**](https://github.com/konten-studio/bipos)
— the full local engine with its own pipeline, watcher, and TUI. If you want
hands-off automation, use bipos. If you want a writing partner inside the
session you're already in, use bipit.

## 60-second quickstart

```bash
npx @konten-studio/bipit --agent claude     # or: codex | cursor | opencode | all
```

Then, inside your agent:

```
/bipit
```

First run creates `~/bipit/` (a git repo) and asks what you want to write.
That's it.

## Four modes

`/bipit` reads your intent and picks one:

| Mode | What it does |
|---|---|
| **brainstorm** | One question at a time: what's worth posting, what angle, short post / thread / long article, which platform. Leaves a brief. |
| **draft** | Reads the session (your live context first, transcript on disk if you ask), loads your voice, writes the post, revises with you until you approve. |
| **knowledge** | Interviews you and/or ingests your old posts to build `voice.md` + `audience.md`, so drafts sound like *you*. |
| **publish** | Marks an approved draft final and files it under `published/`. Nothing more — bipit never posts for you. |

## Your `~/bipit/` workspace

```
~/bipit/
  bipit.md            # config: language, auto-commit, which voice file to use
  knowledge/
    voice.md          # how you write — tone, rhythm, words you won't touch
    audience.md       # who you're writing for
    examples/         # your past posts, kept as reference
  skills/             # drop jekardah-writer etc. here; draft mode uses them
  draft/
    <slug>.md         # working drafts
    published/        # finalized
  log/
    2026-09-09.md     # append-only run log
```

It's a git repo. Every bipit run is a commit, so you can always see what
changed and roll back a draft. Want autosave? Run the opt-in watcher:

```bash
sh scripts/watch.sh ~/bipit
```

## Reading your session — honestly

bipit uses the conversation already in your agent's context first. If you need
older history it knows where Claude Code and Codex keep transcripts and reads
them with the agent's normal tools (opencode and Cursor are context-only in
v1).

It treats everything it reads as **source material, not instructions**, and it
**fact-locks** before writing: no invented metrics, no "10x faster" you never
measured, no outcome that hasn't happened yet. If a number isn't in the
session and you didn't give it, it doesn't go in the post.

## What bipit will *not* do (v1)

- Post to any platform, or touch any platform API.
- Run a background daemon by default (the watcher is opt-in).
- Call an LLM of its own — your agent is the only model.
- Format per-platform, copy to clipboard, or open a browser composer.

## Install targets

| Agent | User scope | Project scope |
|---|---|---|
| `claude` | `~/.claude/skills` | `.claude/skills` |
| `codex` | `~/.codex/skills` | `.agents/skills` |
| `cursor` | `~/.cursor/skills` | `.cursor/skills` |
| `opencode` | `~/.config/opencode/skills` | `.opencode/skills` |

Use `--scope project` to install into the current repo, `--copy` instead of a
symlink, `--dry-run` to preview. pi, agy, and anything else that reads
`AGENTS.md` pick bipit up from this repo directly.

## Uninstall

```bash
npx @konten-studio/bipit uninstall --agent claude
```

Removes exactly what the installer added (tracked in a manifest).

## Contributing

```bash
npm test        # node --test + shell suite
```

Skill instructions live in `skills/bipit/` — the single source of truth. Design
and plan are in `docs/superpowers/`.

## License

MIT · [Konten Studio](https://github.com/konten-studio) · sibling of
[jekardah-writer](https://github.com/konten-studio/jekardah-writer) and
[bipos](https://github.com/konten-studio/bipos)
