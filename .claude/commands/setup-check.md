---
description: Verify this machine and project are ready for DoGoDev — tools, git identity, and the suite itself
---

You are running DoGoDev's setup check. The person asking may be brand new to development —
report in plain language, never assume they know what a term means, and never make them
feel behind for a missing piece. Check everything below, then give one tidy report.

Run each check with the shell available to you (PowerShell on Windows is fine — do not
require bash). All checks are read-only; the only changes you may make are the two
explicitly offered fixes at the end, and only with the user's yes.

## The checks

1. **Node.js** — `node --version`. Needs v22.5.0 or newer. If missing or too old, the fix
   is the installer at nodejs.org (they should close and reopen the terminal after).
2. **Git** — `git --version`. Any version passes. If missing: git-scm.com/downloads.
3. **Git knows who they are** — `git config user.name` and `git config user.email`. If
   either is empty, their first save-to-history ("commit") will fail with a confusing
   error. This is the most common silent trap on a fresh machine.
4. **This folder is a project** — `git rev-parse --is-inside-work-tree`. If not, they
   likely skipped `git init` in the walkthrough.
5. **The DoGoDev suite is here** — confirm `.claude/agents/` contains the five role files
   (analyst, designer, builder, dba, operator), `.claude/pipeline/_TEMPLATE.md` exists,
   and `CLAUDE.md` exists at the project root.
6. **House rules are filled in** — read `CLAUDE.md`'s "Your project's house rules"
   section. If it still contains the template's italic `_e.g. ..._` placeholder lines,
   it hasn't been filled in yet. Partial is fine — Stack and covenant alone is a valid
   start. Completely untouched means the agents will be flying blind.
7. **GitHub (optional — report only)** — try `git remote -v`, and `ssh -T git@github.com`
   or `gh auth status` if available. No remote or no auth is NOT a failure — the
   walkthrough treats GitHub as the last step. Just say what state it's in.

## The report

A short checklist, one line per item: a clear pass/fail marker, what was found, and — for
anything failing — the exact fix in one sentence. Order it so failures are impossible to
miss. End with one plain-language sentence: either "You're ready — describe what you want
to build" or "Fix the items above first; the top one matters most."

## Offered fixes (ask first, then do)

- Item 3 failing: offer to run `git config --global user.name "..."` / `user.email "..."`
  with values they give you. Suggest they use the same email as their GitHub account.
- Item 4 failing: offer to run `git init` right here.

Never install software yourself, never change anything not listed above, and never push
anything anywhere during this check.
