# DoGoDev — operating rules for this repo

This project is built with **DoGoDev**: five role agents (analyst → designer → builder → dba →
operator) that move work through a file-based pipeline. The full method is in
`.claude/pipeline/README.md`. These rules apply to every session and every agent.

## The pipeline rule (never broken)

- Every task is ONE file: `.claude/pipeline/WI-NNN-short-name.md`, created from `_TEMPLATE.md`.
- Each stage **appends** its own section; nothing earlier is edited or deleted.
- Context travels in that file plus the standing docs below. Nothing is pasted between stages.
- If an agent needs something not in the item file or this repo, it writes the question into the
  item's **Open questions** section and **stops**. It never invents an answer to keep moving.
- Only the **operator** may write `Status: shipped`, and only when every earlier section shows
  real evidence (tests run, screens seen) rather than intention.

## Standing docs — read before acting

<!-- List the docs that define this project so every agent grounds in them. Trim/extend freely. -->
- `README.md` — what this project is and its core rules. (Brand-new project with no README yet?
  That's fine — a listed doc that doesn't exist yet is a note to create it, not a blocker.)

---

## Your project's house rules  — FILL THIS IN

> This section is what makes the agents fit *your* code. Replace each example with your project's
> truth, keep it short and concrete, and the agents will treat it as law. (Example values shown are
> from the project DoGoDev was extracted from — swap them out.)

- **Stack:** _e.g. Node 22.5+, `node:sqlite`, no npm dependencies, no build step._
- **Where things live:** _e.g. `lib/` modules by domain; pages in `public/`; tests in `tests/`._
- **Run the tests:** _the ONE command — e.g. `node tests/run.js`. Builder and dba run the WHOLE
  suite, not just the new file, and report the tail as evidence. A red suite is reported RED._
- **Data lives in:** _e.g. schema in `lib/db.js`, seeds in `lib/seed.js`. A change that only works
  on a fresh database isn't done — state what happens to existing data on upgrade._
- **Ship it:** _e.g. version + changelog location, and the deploy path (never invent a new one)._
- **The covenant (non-negotiable):** _the rules an agent must never break without a human — e.g.
  "zero dependencies: if you reach for a package, STOP and put it in Open questions."_
- **Match the code you find:** read the two nearest neighbors of anything you touch before writing;
  follow the existing naming, error, and logging idioms. Consistency beats novelty.
