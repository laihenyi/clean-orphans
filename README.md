# Clean Orphans

A smart cleanup script for macOS development environments. It safely kills orphaned processes (PPID=1) and reclaims memory without affecting active development sessions like Claude Code or Antigravity.

It specifically targets memory hogs like:
- Orphaned Playwright/MCP servers
- Stuck Flutter/Dart daemons
- Stale ADB logcat streams
- Runaway Kotlin LSP
- iOS Simulators

## Installation

```bash
./install.sh
```

Ensure `~/.local/bin` is in your `PATH` by adding `export PATH="$HOME/.local/bin:$PATH"` to your `~/.zshrc`.

## Usage

Run the script safely to clean up orphaned background processes:
```bash
clean-orphans
```

Run with `--deep` to aggressively shut down heavy memory consumers like Kotlin LSP and all iOS Simulators:
```bash
clean-orphans --deep
```
