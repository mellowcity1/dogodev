#!/usr/bin/env node
// PostToolUse example hook: re-run the project's test command after every Edit/Write.
//
// Edit the line below to match your CLAUDE.md's "Run the tests" command, then wire it
// into .claude/settings.json — see docs/hooks.md for the full config.

import { spawnSync } from 'node:child_process';

const TEST_COMMAND = ['node', '--test']; // <-- change to your project's real test command

const result = spawnSync(TEST_COMMAND[0], TEST_COMMAND.slice(1), {
  stdio: 'inherit',
  shell: false,
});

// Non-zero here is informational only for PostToolUse (nothing to block, the edit
// already happened) — Claude Code just shows the hook's output. A failing suite still
// exits non-zero so it's visible, but it can't undo the edit.
process.exit(result.status ?? 0);
