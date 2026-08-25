# Hooks — optional, enforced guardrails

`CLAUDE.md` is where DoGoDev's rigor actually lives: it's read at the start of every
session, on every OS, by every role. Hooks are a second, *optional* layer on top of
that — Claude Code commands that run automatically at specific moments (after an edit,
before a Bash command, and others), whether or not the agent remembers to.

They're opt-in here, not part of the default setup, for one concrete reason below.

## Why opt-in, not default

A hook's `command` can run two different ways:

- **Exec form** — you give it an `args` array. Claude Code runs the `command` directly as
  a program, no shell involved. This works identically on Windows, macOS, and Linux.
- **Shell form** — you omit `args` and just give a command string. Claude Code runs it
  through a shell — on Windows, that means **Git Bash**, not `cmd.exe` or PowerShell. A
  hook written as a `.sh` script, or copied from a Mac/Linux example, silently fails on a
  Windows machine that doesn't have Git Bash installed.

DoGoDev's first users are exactly the people least equipped to debug that failure — so
hooks stay off by default, and the one pattern documented here is the exec form, in
Node.js, which sidesteps the shell question entirely.

## Where they live

Project-wide: `.claude/settings.json`. Personal-only (not committed, doesn't affect
teammates): `.claude/settings.local.json`. Shape:

```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "ToolName|AnotherTool",
        "hooks": [
          { "type": "command", "command": "node", "args": ["path/to/hook.mjs"] }
        ]
      }
    ]
  }
}
```

Three levels, all required: the event, a matcher group (which tool calls this applies
to), and the handler(s) to run. `matcher` accepts `|`-separated exact names (`"Edit|Write"`)
or a regex (`"^Notebook"`).

**The Windows-safe pattern:** always use the exec form — `command` is the program
(`"node"`), `args` is an array with the script path and any arguments. Never put the
whole command as one string; that's what triggers shell form.

The two events used below — `PreToolUse` (fires before a tool call, can block it) and
`PostToolUse` (fires after, informational only) — are stable and well documented. Claude
Code has more events than these two; check the current list at
[code.claude.com/docs/en/hooks](https://code.claude.com/docs/en/hooks) before wiring up
anything beyond what's shown here — the full event set evolves, and this doc only vouches
for what's demonstrated and tested below.

## Two working examples

Both scripts are in [`.claude/hooks/examples/`](../.claude/hooks/examples/) in this repo,
already written and tested — copy them into your project's `.claude/hooks/` and edit the
one line each calls out, rather than writing from scratch.

### Auto-run tests after every edit

[`run-tests.mjs`](../.claude/hooks/examples/run-tests.mjs) — a `PostToolUse` hook on
`Edit|Write` that re-runs your project's test command (edit the `TEST_COMMAND` line at
the top to match what `CLAUDE.md` names) after every change, so a red suite shows up
immediately instead of at the builder's "done" claim.

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "node", "args": [".claude/hooks/run-tests.mjs"] }
        ]
      }
    ]
  }
}
```

### Block a stray dependency

[`block-dependency.mjs`](../.claude/hooks/examples/block-dependency.mjs) — a
`PreToolUse` hook on `Bash` that denies any command matching an `npm install`, `pnpm
add`, `yarn add`, or `pip install` pattern, enforcing a zero-dependency covenant
mechanically instead of by hoping the builder remembers `CLAUDE.md`'s rule. Exit code `2`
is what actually blocks the call (`0` allows it) — the JSON on stdout is just the
human-readable reason shown alongside the block.

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "node", "args": [".claude/hooks/block-dependency.mjs"] }
        ]
      }
    ]
  }
}
```

Only add this one if your project's covenant actually is zero dependencies — it's a
template for *enforcing a written rule*, not a rule itself. A project that's fine with
dependencies doesn't need it.

## Trying one

1. Copy the example script(s) you want from `.claude/hooks/examples/` into your own
   project's `.claude/hooks/`.
2. Edit the one line each calls out (the test command in `run-tests.mjs`; nothing to
   edit in `block-dependency.mjs` unless you want to change the pattern).
3. Add the matching JSON above into your project's `.claude/settings.json`.
4. Trigger the tool call the hook is watching for, and confirm it actually fired — don't
   assume; Claude Code shows hook output inline.
