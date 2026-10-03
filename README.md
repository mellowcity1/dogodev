# 🔥 DoGoDev

Small, guided dev tooling for building real software with Claude Code — from an idea to a
running app, without giving up at the setup wall.

> *dogo — Swahili for "small." Part of the dogomoto family.*

## What it is

Six role agents that move work through a file-based pipeline:

**analyst → designer → dba → builder → tester → operator**

You describe what you want in plain English; each stage does its job and hands the next a
**single file**, so context never gets lost between steps. Stages that don't apply are skipped.
The tester runs what was built; when it isn't right, the item goes back around — to the
designer, dba, or builder — until it is.

## New to all this?

Start with the front door — **[dogodev.com](https://dogodev.com)**: prerequisites, a
Windows-first install, and your first project, step by step. The page's source is
[`site/`](site/) in this repo.

## Install into your project

**Windows, one command** (checks your tools, guides missing installs from official sources, scaffolds
the project — read it first at [dogodev.com/new.ps1](https://dogodev.com/new.ps1)):

```powershell
irm https://dogodev.com/new.ps1 | iex
```

Or by hand:

1. From the root of your repo, copy in the **`.claude/`** folder and **`CLAUDE.md`**:

   PowerShell (Windows):
   ```powershell
   git clone --depth 1 https://github.com/mellowcity1/dogodev.git $env:TEMP\dogodev-src
   Copy-Item $env:TEMP\dogodev-src\.claude . -Recurse
   Copy-Item $env:TEMP\dogodev-src\CLAUDE.md .
   Remove-Item $env:TEMP\dogodev-src -Recurse -Force
   ```

   Mac/Linux:
   ```bash
   git clone --depth 1 https://github.com/mellowcity1/dogodev.git /tmp/dogodev-src
   cp -r /tmp/dogodev-src/.claude . && cp /tmp/dogodev-src/CLAUDE.md .
   rm -rf /tmp/dogodev-src
   ```

2. Open `CLAUDE.md` and fill in the **“Your project’s house rules”** section — your stack, where
   things live, the test command, how you ship. *This is what makes the agents fit your code.*
3. Open Claude Code in the repo and type **`/setup-check`** — Claude verifies Node, Git, your git
   identity, and that the suite landed correctly, and reports the exact fix for anything off.
4. Start the relay:
   > Have the analyst open a work item for &lt;your idea&gt;.

## How work moves

See [`.claude/pipeline/README.md`](.claude/pipeline/README.md). In short: one file per task
(`WI-NNN`), each stage **appends** its section, and **nobody invents** — an agent missing
something writes the question down and stops. When the tester finds a problem, the owner
appends a **round 2** section and the item is tested again; the file keeps every lap.

## The six roles

| Role | Does | Model | Skipped when |
|------|------|-------|--------------|
| **analyst** | What & why; requirements + numbered acceptance criteria | `opus` | never (opens every item) |
| **designer** | What the user sees — screens, copy, every state | `sonnet` | pure backend work |
| **dba** | Settles the data shape before the code; migrations, backups — the outage nobody planned for | `opus` | no data surface touched |
| **builder** | Writes the code, runs the whole test suite, reports evidence | `sonnet` | — |
| **tester** | Runs it for real, criterion by criterion; passes it on or sends it back around | `opus` | never |
| **operator** | Version, ship, smoke-test, and the support notes a future 2am needs | `haiku` | never (closes every item) |

Each agent names its Claude model in its file's `model:` line, matched to the job: Opus where a
mistake is expensive, Sonnet for the heavy lifting, Haiku for quick release chores. DoGoDev
needs a paid Claude plan (Pro or above), and all three are available on it. Change any line to
suit your plan — the trade-offs and a one-switch override are in
[`.claude/pipeline/README.md`](.claude/pipeline/README.md#each-role-runs-on-the-model-that-fits-its-job).

## Optional: enforced guardrails (hooks)

DoGoDev’s rigor lives in **`CLAUDE.md`** — loaded every session, reliable on every OS. You can
*additionally* enforce rules with Claude Code hooks (auto-run tests after edits, block a stray
dependency). One caveat worth knowing: **hook commands aren’t cross-platform out of the box** — a
bash script fails on Windows without Git Bash — so hooks are an **opt-in** layer here, not a
default. Notes and two tested, ready-to-copy examples: [`docs/hooks.md`](docs/hooks.md).

## Status

**v0.7** — the method was extracted from a real product build (ITAuditgo, an IT-audit tool) and
proven on a fresh project, a to-do CLI, through two full work items, the second including two laps
of the test loop. Still young: expect rough edges, and say so when you hit one.
