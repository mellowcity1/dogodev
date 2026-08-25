#!/usr/bin/env node
// PreToolUse example hook: block a Bash command that would add a dependency, so a
// "zero dependencies" covenant in CLAUDE.md is enforced by the tool, not just honor
// system. Reads the tool call as JSON on stdin (Claude Code's hook contract), matches
// the command being run, and denies it if it looks like a package install.
//
// Exit code is what actually blocks: 2 = deny, 0 = allow. The JSON on stdout is only
// the human-readable reason shown alongside the block.

import { readFileSync } from 'node:fs';

const INSTALL_PATTERN = /\b(npm|pnpm|yarn)\s+(add|install)\b|\bpip\s+install\b/;

let input;
try {
  input = JSON.parse(readFileSync(0, 'utf8'));
} catch {
  process.exit(0); // can't parse the call — fail open, don't block on a hook bug
}

const command = input?.tool_input?.command ?? '';

if (INSTALL_PATTERN.test(command)) {
  console.log(JSON.stringify({
    hookSpecificOutput: {
      hookEventName: 'PreToolUse',
      permissionDecision: 'deny',
      permissionDecisionReason:
        "This project's covenant (CLAUDE.md) is zero dependencies. If you actually need " +
        "this package, put it in the work item's Open questions instead of installing it.",
    },
  }));
  process.exit(2);
}

process.exit(0);
