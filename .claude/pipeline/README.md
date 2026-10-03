# The pipeline — how work moves through DoGoDev

Six role agents live in `.claude/agents/`: **analyst → designer → dba → builder → tester →
operator**. Not every item visits every stage — the analyst says which stages an item
needs, and pure-backend work skips the designer the same way a copy change skips the dba.
The tester and operator are never skipped.

## The one rule: context travels with the work

Each work item is ONE file in this folder: `WI-NNN-short-name.md`, created from
`_TEMPLATE.md`. Every stage APPENDS its section to that file and never deletes an earlier
one. The next agent reads the file — plus `CLAUDE.md` and the standing docs it names —
and starts working. Nothing is ever pasted between stages; if an agent needs something
that is not in the item file or the repo, it writes the question into the item's **Open
questions** section and stops rather than inventing an answer.

The one line every stage may update is `Status:` at the top — it always says where the
item is right now. Everything below it is history.

## The loop: test, then go around again

Building is not a straight line. The tester checks every acceptance criterion by running
the software, and when something is wrong it sends the item back to whoever owns the fix:

- the **builder** — it's a bug;
- the **designer** — it works as specified but doesn't serve the ask, or you tried it and
  it isn't what you pictured;
- the **dba** — it's the data;
- the **analyst** — the acceptance criteria themselves were wrong.

The owner appends a **round N** section, the item comes back to the tester, and the loop
repeats until the tester says PASS. Rounds are appended, never rewritten, so the file
shows every lap. After three rounds without a PASS the tester stops the loop and asks you —
at that point the ask itself usually needs a fresh look.

There is a second, bigger loop: shipping isn't the end. You use what you built, you have
the next idea, and that becomes a new work item. Software grows one small item at a time.

## Driving it

From a normal Claude Code session in this repo:

- "Have the **analyst** open a work item for &lt;the idea&gt;" — creates the next `WI-NNN`
  file with requirements + acceptance criteria + stage plan.
- "Send WI-003 to the **builder**" — the builder reads the file, implements, runs the
  project's test suite, appends its section.
- "**Tester**, check WI-003" — runs it for real, criterion by criterion; passes it on or
  sends it back around.
- "**operator**, take WI-003 out" — release notes, deploy, support notes.

Or just say "move WI-003 along" — the `Status:` line tells the main session which stage is
next. The main session is the router; the agents are the specialists. A finished item ends
with the operator's section and a final `Status: shipped` line.

## Why the stages are these six

Matched to how a traditional shop is organized: analyst (what and why), designer (what it
looks like), dba (where the data lives, settled before anyone codes against it), builder
(make it so), tester (prove it — someone other than the person who built it), operator (it
runs, ships, and gets supported). The dba exists as a named stage precisely because it is
the role everyone forgets until the outage; the tester exists because whoever wrote the
code is the worst-placed person to certify it.

## Each role runs on the model that fits its job

Every agent file names its Claude model in its `model:` line:

| Role | Model | Why |
|------|-------|-----|
| analyst | `opus` | A wrong requirement poisons every stage after it — think hard here. |
| designer | `sonnet` | Screens, copy, and states: everyday production work. |
| dba | `opus` | Data mistakes are the expensive, hard-to-undo kind. |
| builder | `sonnet` | Writing code is the bulk of the work; Sonnet is built for it. |
| tester | `opus` | The checker should be at least as sharp as the maker. |
| operator | `haiku` | Version, changelog, smoke run — quick, routine release chores. |

Change any line to suit your plan (`opus`, `sonnet`, `haiku`, `fable`, or `inherit` to
use whatever your session is on). To put every agent on one model for a while — say,
you're near your plan's limit — set two environment variables before starting `claude`
(PowerShell; needs Claude Code v2.1.257 or later):

```powershell
$env:CLAUDE_CODE_SUBAGENT_MODEL = "sonnet"
$env:CLAUDE_CODE_SUBAGENT_MODEL_FORCE = "1"
```
