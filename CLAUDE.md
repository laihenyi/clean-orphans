# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Bash script that safely kills orphaned development processes (PPID=1) to reclaim memory. Supports macOS and Linux. Two modes: safe mode (orphans only) and `--deep` mode (heavy daemons like Gradle, Kotlin LSP, iOS Simulators).

**Why orphaned processes occur:**
- macOS lacks `prctl(PR_SET_PDEATHSIG)` — child processes don't auto-die when parent exits
- MCP servers spawned by IDEs/terminals become orphaned when parent crashes or is force-quit
- Node.js `child.kill()` doesn't wait for cleanup; signals don't propagate through nested `npm exec` wrappers
- Flutter's shell wrapper receives SIGTERM but doesn't forward it to the underlying Dart VM

## Development Commands

```bash
./clean-orphans                 # Run safe orphan cleanup
./clean-orphans --deep          # Aggressive cleanup (Gradle, Flutter daemon, simulators)
./clean-orphans --dry-run       # Preview what would be killed without terminating
./install.sh                    # Install to ~/.local/bin/clean-orphans
bash -n clean-orphans           # Syntax check
shellcheck clean-orphans        # Static lint (recommended)
```

## Architecture

Single-file script (`clean-orphans`) with this flow:

1. **Argument parsing** — Supports `--deep`, `--dry-run`, `--help`; flags are combinable in any order
2. **OS detection** — `uname -s` to distinguish Darwin/Linux
3. **Pattern matching** — `ORPHAN_PATTERNS` array defines regex patterns for targetable processes (MCP servers, AI language servers, Node wrappers, frontend dev servers, Dart/Flutter tooling, iOS logging)
4. **Safe cleanup** — Finds processes matching patterns with `PPID=1`, plus orphaned `adb logcat`; kills via `kill_and_report()`
5. **Deep cleanup** (`--deep`) — `cleanup_by_name()` targets non-orphaned heavy daemons (Kotlin LSP, Gradle, Flutter daemon); `cleanup_orphaned_by_name()` for xcodebuild (PPID=1 only); macOS-specific `xcrun simctl shutdown all` for iOS Simulators

**Safety strategy:**
| Mode | What it targets | Safe for active work? |
|------|-----------------|----------------------|
| Safe (default) | Only `PPID=1` orphans matching `ORPHAN_PATTERNS` | Yes — active children always have living parent |
| `--deep` | Adds Gradle, Kotlin LSP, Flutter daemon, iOS Simulators | May interrupt active builds |
| `--dry-run` | Read-only preview | N/A |

**Key functions:**
- `report_stats(PIDS, LABEL)` — Calculates memory usage via `ps -o rss=` and prints report
- `graceful_kill(PIDS)` — SIGTERM → wait 2s → SIGKILL fallback for stubborn processes; respects `--dry-run`
- `kill_and_report(PIDS, LABEL)` — Combines `report_stats` + `graceful_kill`
- `cleanup_by_name(LABEL, PATTERN)` — Uses `pgrep -f` to find and kill matching processes
- `cleanup_orphaned_by_name(LABEL, PATTERN)` — Same but restricted to PPID=1 (safe for tools like xcodebuild that may be actively in use)

## Coding Conventions

- Bash with `#!/bin/bash`; uppercase for globals (`ORPHAN_PATTERNS`, `REGEX_PATTERN`), `snake_case` for functions
- `ORPHAN_PATTERNS` array is the primary extension point — add new patterns there when supporting new tools
- Comments in Chinese (繁體中文) are normal for this project
- Commit style: `feat:`, `refactor:`, `style:` prefixed, imperative, single logical change
