# Mode: draft

Goal: produce a post the user approves, saved to `~/bipit/draft/`.

You may arrive here with a brief already written (`status: brief` in
`~/bipit/draft/<slug>.md`) or straight from `/bipit draft ...`. Either way:

## Workflow

1. **Gather material — context first.**
   Following `references/session-sources.md`, write yourself a short internal
   summary of what was built this session. Offer the user a disk read only if
   they want fuller history or context was compacted.

2. **Load the voice.**
   Read `~/bipit/knowledge/voice.md` and `~/bipit/knowledge/audience.md`. If
   `voice.md` is still the empty stub, tell the user their draft will use a
   neutral voice and they can run `/bipit set up my voice` later.

3. **Consult extra skills.**
   List `~/bipit/skills/`. For each subdirectory, read its `SKILL.md` and apply
   the ones relevant to writing a post — typically hook writing, anti-AI-slop
   editing, storytelling structure, register/voice. Follow those skills as
   written; do not weaken their rules.

4. **Fact-lock before writing.**
   Write only what the session or the user actually supports. For each of these,
   know whether you have it or not — if not, leave it out, qualify it, or ask:
   - events (what happened, in what order)
   - people (who did what)
   - numbers (durations, counts, sizes, %s, benchmarks)
   - results (did it work, is it shipped, is it live)
   - dialogue / quotes (only if verbatim in the source)
   - motive and internal state (only if the user stated it)
   - causality (X caused Y only if shown)
   - uncertainty (say "not sure yet" rather than resolving it)

   Never upgrade a maybe into a claim. Never invent a metric to make the post
   land harder.

5. **Draft it** in the chosen format:
   - **short** — one hook line, 2–4 lines of substance, optional CTA.
   - **thread** — hook post, then one idea per post, last post lands or asks.
   - **long** — title, hook paragraph, 3–6 short sections, close.

6. **Approve / revise loop.**
   Show the draft. Ask what to change. Revise. Repeat until the user approves.

7. **Save.** Write to `~/bipit/draft/<slug>.md` (reuse the brief's slug if there
   was one):

   ```markdown
   ---
   status: draft
   source: <"context" or transcript path>
   format: <short | thread | long>
   platform: <platform or "unspecified">
   created: <YYYY-MM-DD>
   updated: <YYYY-MM-DD>
   ---

   <the approved draft>
   ```

8. End with the log + commit step from `SKILL.md`. To finalize later, the user
   runs `/bipit finalize <slug>` (publish mode).
