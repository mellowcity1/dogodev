# The pipeline — how work moves through DoGoDev

Five role agents live in `.claude/agents/`: **analyst → designer → builder → dba →
operator**. Not every item visits every stage — the analyst says which stages an item
needs, and pure-backend work skips the designer the same way a copy change skips the dba.

## The one rule: context travels with the work

Each work item is ONE file in this folder: `WI-NNN-short-name.md`, created from
`_TEMPLATE.md`. Every stage APPENDS its section to that file and never deletes an earlier
one. The next agent reads the file — plus `CLAUDE.md` and the standing docs it names —
and starts working. Nothing is ever pasted between stages; if an agent needs something
that is not in the item file or the repo, it writes the question into the item's **Open
questions** section and stops rather than inventing an answer.

## Driving it

From a normal Claude Code session in this repo:

- "Have the **analyst** open a work item for &lt;the idea&gt;" — creates the next `WI-NNN`
  file with requirements + acceptance criteria + stage plan.
- "Send WI-003 to the **builder**" — the builder reads the file, implements, runs the
  project's test suite, appends its section.
- "**operator**, take WI-003 out" — release notes, deploy, support notes.

The main session is the router; the agents are the specialists. A finished item ends with
the operator's section and a final `Status: shipped` line.

## Why the stages are these five

Matched to how a traditional shop is organized: analyst (what and why), designer (what it
looks like), builder (make it so), dba (the data survives everything), operator (it runs,
ships, and gets supported). The dba exists as a named stage precisely because it is the
role everyone forgets until the outage.
