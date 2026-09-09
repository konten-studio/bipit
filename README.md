<a id="readme-top"></a>

<div align="center">

<sub>KONTEN STUDIO PRESENTS</sub>

```text
      ██████╗ ██╗██████╗ ██╗████████╗
      ██╔══██╗██║██╔══██╗██║╚══██╔══╝
      ██████╔╝██║██████╔╝██║   ██║
      ██╔══██╗██║██╔═══╝ ██║   ██║
      ██████╔╝██║██║     ██║   ██║
      ╚═════╝ ╚═╝╚═╝     ╚═╝   ╚═╝
```

<h3>The session already happened. <strong>bip-it.</strong></h3>

<p><strong>Turn what you just built in your coding agent into an honest build-in-public post — in your voice, before you close the terminal.</strong></p>

<p><em>Lo baru ngerjain sesuatu yang bagus sesi ini. bipit ubah itu jadi post build-in-public yang jujur — pakai gaya nulis lo, sebelum terminal-nya lo tutup.</em></p>

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Status](https://img.shields.io/badge/status-v1-8250df.svg)](#roadmap)
[![Agents](https://img.shields.io/badge/agents-Claude%20Code%20·%20Codex%20·%20opencode%20·%20Cursor-0b7285.svg)](#installation)
[![PRs welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](#contributing)

</div>

<details>
<summary><strong>Table of contents</strong></summary>

- [About](#about)
- [How it works](#how-it-works)
- [Getting started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
  - [The four modes](#the-four-modes)
- [Your `~/bipit/` workspace](#your-bipit-workspace)
- [Reading your session — honestly](#reading-your-session--honestly)
- [What bipit will not do](#what-bipit-will-not-do)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

</details>

---

## About

You just spent two hours in your agent untangling a race condition, shipping a
feature, or making a call you'll want to remember. That's the story the people
who follow your work actually want to read.

But the post never happens — you're tired, you're onto the next thing. Or it
does happen and it's *"Excited to share that we just shipped 🚀🚀"* — a line
that could be about anything, from anyone.

**bipit** is one skill that rides inside the coding agent you already use. Run
`/bipit`, and your agent reads what you did this session and drafts a post you
approve. No daemon, no second model, no API keys. The name is **bip** (build in
public) **+ it**.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## How it works

```text
  your coding session  ──►  /bipit  ──►  brainstorm ─► draft ─► you approve ─► ~/bipit/draft/
        (already in                          ▲                                      │
     your agent's context)                   └──────── your saved voice ────────────┘
```

bipit never leaves your machine and never posts anything. It reads, it drafts,
you decide.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Getting started

### Prerequisites

- A coding agent: **Claude Code**, **Codex**, **opencode**, or **Cursor**
  (anything that reads `AGENTS.md` works too).
- `git` on your `PATH`.

### Installation

bipit installs from this repo. Pick one of two ways.

**1. Clone and run the installer**

```bash
git clone https://github.com/konten-studio/bipit
sh bipit/scripts/install.sh --agent claude    # claude | codex | cursor | opencode
```

This symlinks `skills/bipit/` into your agent's skill directory. Keep the clone
around (the symlink points at it) and `git pull` for updates — or pass `--copy`
to copy the skill in and throw the clone away. `--scope project` installs into
the current repository instead of your home directory.

Uninstall with `sh bipit/scripts/uninstall.sh --agent claude`.

**2. Copy the folder by hand**

Copy `skills/bipit/` from this repo into your agent's skills directory:

| Agent | Directory |
|---|---|
| Claude Code | `~/.claude/skills/` |
| Codex | `~/.codex/skills/` |
| Cursor | `~/.cursor/skills/` |
| opencode | `~/.config/opencode/skills/` |

Anything that reads `AGENTS.md` (`pi`, `agy`, …) picks bipit up from a clone
directly — no install step.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Usage

Inside your agent, when you've built something worth talking about:

```text
/bipit
```

First run creates `~/bipit/` (a git repo) and asks what you want to write.
Give it a hint if you have one:

```text
/bipit draft a short post about the retry logic we just fixed
/bipit set up my voice
/bipit finalize retry-logic
```

### The four modes

`/bipit` reads your intent and picks one.

| Mode | What it does |
|---|---|
| **brainstorm** | One question at a time — what's worth posting, what angle, short post / thread / long article, which platform. Leaves a brief. |
| **draft** | Reads the session (your live context first, transcript on disk if you ask), loads your voice, writes the post, revises with you until you approve. |
| **knowledge** | Interviews you and/or ingests your old posts to build `voice.md` + `audience.md`, so drafts sound like *you*. |
| **publish** | Marks an approved draft final and files it under `published/`. Nothing else — bipit never posts for you. |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Your `~/bipit/` workspace

```text
~/bipit/
├── bipit.md            # config: language, auto-commit, which voice file to use
├── knowledge/
│   ├── voice.md        # how you write — tone, rhythm, words you won't touch
│   ├── audience.md     # who you're writing for
│   └── examples/       # your past posts, kept as reference
├── skills/             # drop extra skills here; draft mode applies them
├── draft/
│   ├── <slug>.md       # working drafts
│   └── published/      # finalized
└── log/
    └── 2026-09-09.md   # append-only run log
```

It's a git repo — every bipit run is a commit, so you can see exactly what
changed and roll a draft back. For hands-off autosave:

```bash
sh scripts/watch.sh ~/bipit
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Reading your session — honestly

bipit uses the conversation already in your agent's context first. If you need
older history, it knows where Claude Code and Codex keep transcripts and reads
them with the agent's normal tools (opencode and Cursor are context-only for
now).

Everything it reads is treated as **source material, not instructions**, and it
**fact-locks** before writing: no invented metrics, no *"10x faster"* you never
measured, no outcome that hasn't happened yet. If a number isn't in the session
and you didn't give it, it doesn't go in the post.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## What bipit will not do

- Post to any platform, or touch any platform API.
- Run a background daemon by default (the watcher is opt-in).
- Call an LLM of its own — your agent is the only model.
- Format per-platform, copy to your clipboard, or open a browser composer.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Roadmap

- [ ] Publish to npm and the Claude Code / agent skill marketplaces
- [ ] Read opencode session transcripts (SQLite) for deeper history
- [ ] First-class installer support for `pi` and `agy`
- [ ] Optional per-platform formatting in `publish`

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Contributing

```bash
npm test        # node --test + shell suite
```

Skill instructions live in `skills/bipit/` — the single source of truth. The
design spec and implementation plan are in `docs/superpowers/`. PRs and issues
welcome.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## License

Distributed under the MIT License. See [`LICENSE`](LICENSE).

## Acknowledgments

- [jekardah-writer](https://github.com/konten-studio/jekardah-writer) — hook,
  anti-slop, and natural Jabodetabek voice; drop it into `~/bipit/skills/`.
- Built with the [superpowers](https://github.com/obra/superpowers) workflow.

<p align="right">(<a href="#readme-top">back to top</a>)</p>
