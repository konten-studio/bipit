# The `~/bipit/` workspace

bipit keeps everything in one place: `~/bipit/` (literally `$HOME/bipit`). It
is a git repository. Every mode run adds a commit, so the workspace doubles as
a full history of what you have written and how your voice file evolved.

## Directory tree

```
~/bipit/
  bipit.md            # config (see below)
  knowledge/
    voice.md          # your writing voice — filled in by `knowledge` mode
    audience.md       # who you write for
    examples/         # your past posts, one file each, kept as reference
  skills/
    README.md         # drop extra skill folders here (see below)
  draft/
    <slug>.md         # working drafts
    published/        # finalized drafts (moved here by `publish` mode)
  log/
    YYYY-MM-DD.md      # append-only run log
  .gitignore
```

## Bootstrap sequence (first `/bipit` run only)

Do these steps in order. Use your normal shell and file tools.

1. Create the tree above. `knowledge/examples/` and `draft/published/` start
   empty — add a `.gitkeep` file to each so git tracks them.
2. Write the starter files below.
3. `git -C ~/bipit init`
4. `git -C ~/bipit add -A`
5. `git -C ~/bipit commit -m "bipit: initialize workspace"`
6. Tell the user: the workspace is at `~/bipit/`, it is a git repo, and every
   bipit run will add a commit.

If `~/bipit/` already exists, do none of this.

## Starter file contents

### `~/bipit/bipit.md`

```markdown
# bipit config

created: <YYYY-MM-DD>
harness: <the agent you are running in, e.g. claude-code / codex / opencode / cursor>
language: auto        # auto = match the user; or set a fixed language
auto_commit: ask      # ask | on | off
voice_file: knowledge/voice.md
```

### `~/bipit/knowledge/voice.md`

```markdown
# My writing voice

<!-- Empty stub. Run `/bipit set up my voice` to fill this in. -->

## Tone

## Sentence rhythm

## Structure I tend to use

## Words and phrases I use

## Words and phrases I avoid

## Sample openers that sound like me
```

### `~/bipit/knowledge/audience.md`

```markdown
# Who I write for

<!-- Empty stub. Run `/bipit set up my voice` to fill this in. -->

## Who they are

## What they already know

## What they want from me

## Platforms I post on
```

### `~/bipit/skills/README.md`

```markdown
# Extra skills for bipit

**EN** — Drop skill folders here (each a directory with its own `SKILL.md`).
`draft` mode reads every `SKILL.md` in this folder and applies the relevant
ones — hook writing, anti-AI-slop editing, storytelling structure, voice.

**ID** — Taruh folder skill di sini (masing-masing punya `SKILL.md` sendiri).
Mode `draft` bakal baca semua `SKILL.md` di folder ini dan pakai yang relevan.

Recommended: [`jekardah-writer`](https://github.com/konten-studio/jekardah-writer)
— hook, anti-slop, and natural Jabodetabek voice. Install it here with:

    npx jekardah-writer --prefix ~/bipit --agent claude
```

### `~/bipit/.gitignore`

```
.DS_Store
*.tmp
```

## Config reference (`bipit.md`)

| Key | Values | Meaning |
|---|---|---|
| `created` | date | when the workspace was made |
| `harness` | string | which agent bipit was first run in |
| `language` | `auto` or a language name | output language; `auto` matches the user |
| `auto_commit` | `ask` \| `on` \| `off` | whether to commit `~/bipit/` without asking after each run |
| `voice_file` | path | which knowledge file `draft` mode loads as the voice |

## Log line format

One line per run, appended to `~/bipit/log/YYYY-MM-DD.md`:

```
14:03  draft  "auth retry fix"  files=2  -> saved draft/auth-retry-fix.md (thread, 5 posts)
```

## Git rules

- The workspace is initialized once, during bootstrap.
- Every mode run ends with one commit (see `SKILL.md` → "Every run ends with").
- Only ever commit paths inside `~/bipit/`.
- For hands-off autosaving, the user can run `scripts/watch.sh ~/bipit` from
  the bipit repo — an opt-in poller that commits on any change. It is never
  started automatically.
