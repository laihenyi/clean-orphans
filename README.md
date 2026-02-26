# 🧹 Clean Orphans

[![macOS](https://img.shields.io/badge/os-macOS-black?logo=apple)](#) [![Linux](https://img.shields.io/badge/os-Linux-blue?logo=linux)](#) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A smart, safe, and lightning-fast cleanup script for development environments. 

It identifies and kills orphaned background processes (processes where `PPID=1`) to reclaim memory **without affecting your active development sessions** (like your IDE, terminal, or Claude Code/AI agents). 

Specially optimized for **macOS** mobile developers (Flutter/iOS/Android) and developers using modern AI tools (MCP servers).

## ✨ Why do you need this?

When IDEs crash, terminals close unexpectedly, or AI development agents stop, they often leave behind "zombie" or "orphaned" background processes. These can quickly eat up gigabytes of RAM.

Instead of manually hunting them down in Activity Monitor or restarting your computer, `clean-orphans` safely sweeps them away in milliseconds.

### Targets Include:
- 🤖 **AI & MCP Servers:** `playwright-mcp`, `mcp-server`, custom tools (`context7`, `mobile-mcp`).
- 📱 **Mobile Dev Tooling:** Stuck `flutter_tester`, Dart tooling daemons, and stale `adb logcat` streams.
- 📦 **Node Wrappers:** Orphaned `npm exec` processes.
- 💥 **Deep Clean (Optional):** Gigabyte-heavy daemons like Gradle (`org.gradle.launcher.daemon`), Kotlin LSP, xcodebuild, and iOS Simulators.

---

## 🚀 Installation

Install it directly into your local binary folder (`~/.local/bin`):

```bash
git clone https://github.com/YOUR_USERNAME/clean-orphans.git
cd clean-orphans
./install.sh
```

> **Note:** Ensure `~/.local/bin` is in your `PATH`. You can add this line to your `~/.zshrc` or `~/.bashrc`:
> ```bash
> export PATH="$HOME/.local/bin:$PATH"
> ```

---

## 🛠️ Usage

### 1. Safe Mode (Default)
Safe mode ONLY targets detached, orphaned tools (`PPID=1`). **It is 100% safe to run anytime.** It will never kill processes attached to an active terminal or IDE.

```bash
clean-orphans
```
*Output Example:*
```text
🔍 Scanning for orphaned development processes...
🔪 Killing 3 orphaned/stale processes (Reclaiming ~45.50 MB)...
✅ Safe orphans cleaned.
💡 Tip: Run 'clean-orphans --deep' to also kill heavy background processes like Gradle, Kotlin LSP, and iOS Simulators.
```

### 2. Deep Clean Mode (Aggressive)
When you feel your system lagging, use the `--deep` flag. This will safely shut down heavy background daemons that aren't technically orphaned but can consume GBs of RAM when idle. *(Don't worry, tools like Gradle will automatically restart on your next build).*

```bash
clean-orphans --deep
```
*Output Example:*
```text
🔍 Scanning for orphaned development processes...
✅ No safe orphans found. Clean!

⚠️ Deep cleanup requested...
🔪 Killing 2 Kotlin LSP processes (Reclaiming ~4120.00 MB)...
🔪 Killing 1 Gradle Daemon processes (Reclaiming ~1200.50 MB)...
🔪 Shutting down iOS Simulators (330 processes, Reclaiming ~14319.00 MB)...
✅ Deep cleanup completed.
```

---

## 🛠️ Customization

Want to add your own custom tools to the cleanup list? Open `clean-orphans` and add your regex pattern to the `ORPHAN_PATTERNS` array:

```bash
ORPHAN_PATTERNS=(
  # AI & MCP Servers (Common)
  "mcp-server|playwright-mcp"
  
  # ... add yours here!
  "my-custom-heavy-daemon"
)
```
Then run `./install.sh` again to apply the changes globally.

---

## 🤝 Contributing

Pull requests are welcome! If you know of other development tools that frequently leave orphaned background processes, feel free to open a PR to add them to the default regex patterns.

## 📄 License
This project is licensed under the MIT License.
