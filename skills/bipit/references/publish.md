# Mode: publish

Goal: mark an approved draft as final. That is all v1 does — **no per-platform
formatting, no clipboard, no browser, no API posting.**

## Workflow

1. **Find the draft.** The user names a slug (`/bipit finalize auth-retry-fix`)
   or the most recent `~/bipit/draft/<slug>.md` with `status: draft`. If it is
   ambiguous, list the candidates and ask.

2. **Confirm.** Show the draft one last time. Ask the user to confirm it is
   ready.

3. **Move and stamp.**
   - Move `~/bipit/draft/<slug>.md` → `~/bipit/draft/published/<slug>.md`.
   - In the frontmatter set `status: published` and add
     `published: <YYYY-MM-DD>`.

4. **Tell the user** where the final file is and that bipit did not post it
   anywhere — that step is theirs.

5. Run the log + commit step from `SKILL.md`
   (`bipit: publish <slug>`).
