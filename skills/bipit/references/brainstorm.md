# Mode: brainstorm

Goal: help the user decide *what* to post and *how*, then leave a brief the
`draft` mode can pick up. No prose drafting here.

## Workflow

1. **Skim the session.** Per `session-sources.md` (context first), get a quick
   read on what happened this session — the shipped thing, the fixes, the
   decisions.

2. **Ask, one question at a time.** Wait for each answer before the next.
   - Which of these is worth telling people about? (offer 2–4 specifics you saw)
   - What is the angle — the shipped feature, the gnarly fix, the design call,
     or the lesson?
   - Format: short post, thread, or long article?
   - Which platform? Any call to action, or none?
   - Anything the reader must know that was *not* in the session? (context,
     numbers, links — captured as the user's own claim, not invented)

3. **Reflect it back.** One short paragraph: the angle, the format, the hook
   idea, the ask. Confirm with the user.

4. **Write the brief.** Save to `~/bipit/draft/<slug>.md` where `<slug>` is a
   short kebab-case name from the angle:

   ```markdown
   ---
   status: brief
   source: <session summary source — "context" or a transcript path>
   format: <short | thread | long>
   platform: <platform or "unspecified">
   created: <YYYY-MM-DD>
   ---

   # <working title>

   ## Angle

   ## Hook idea

   ## Points to hit

   ## Call to action

   ## Facts the user supplied (not from the session)
   ```

5. **Offer to continue.** Ask if they want you to draft it now — if yes, load
   `references/draft.md` and proceed from an existing brief.

6. End with the log + commit step from `SKILL.md`.
