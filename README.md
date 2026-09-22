# 🛠️ Lev's macOS Dotfiles & Setup

A lean, minimal development environment for macOS. Designed for maximum speed, keyboard-driven navigation, and zero unnecessary bloat.

## 🎯 Philosophy

- **Leverage Defaults**: Keep configurations clean and close to upstream defaults to avoid maintenance debt.
- **Terminal & Keyboard First**: Fast navigation with AeroSpace, Ghostty, Neovim, and Zsh.
- **Zero Hacks**: Everything is installed via official Homebrew packages and configured through standard XDG directories.

---

## ⚡ Quick Start (Fresh Mac)

Open **Terminal.app** on a fresh macOS installation and run:

```bash
git clone https://github.com/LevChernishev/dotfiles.git ~/.dotfiles && ~/.dotfiles/install.sh
```

### What `install.sh` does:
1. Installs Apple Xcode Command Line Tools (if missing).
2. Installs Homebrew (if missing).
3. Installs all packages and applications via `brew bundle`.
4. Creates standard XDG directories (`~/.config`, `~/.local/state`, etc.).
5. Symlinks root dotfiles to `$HOME` and app configurations to `~/.config/`.
6. Pre-syncs Neovim plugins headlessly.
7. Applies optimal macOS system defaults via `macos.sh`.

---

## 📦 What Gets Installed

### 🪟 Window & Input Management
- **[AeroSpace](https://github.com/nikitabobko/AeroSpace)** — Tiling window manager for macOS.
- **[LinearMouse](https://linearmouse.app/)** — Disables mouse acceleration, enables linear scrolling distance.

### 💻 Terminal & Shell
- **[Ghostty](https://ghostty.org/)** — GPU-accelerated terminal with Catppuccin Mocha theme.
- **Zsh** with:
  - `starship` (minimal prompt)
  - `zsh-vi-mode` (modal editing)
  - `zsh-autosuggestions` & `zsh-syntax-highlighting`
  - `fzf` & `zoxide` (fuzzy finding & directory jumping)

### 🧑‍💻 Code & Editor
- **[Neovim](https://neovim.io/) with [AstroNvim v4](https://astronvim.com/)** — full-featured, community-maintained Neovim IDE with LSP, Treesitter, and modal navigation out of the box.

### 🐘 Databases
- **[Postgres.app](https://postgresapp.com/)** — Native PostgreSQL server for macOS.
- **[DBeaver](https://dbeaver.io/)** — Universal database GUI client.
- **`lazysql`** — Terminal UI for database queries and exploration.
- **`pgformatter`** — Automatic SQL formatting via `pg_format`.
- Custom `~/.psqlrc` with rich prompts, unicode borders, timing, and monitoring macros.

### 🧰 CLI Utilities
- `displayplacer` (multi-monitor resolution, frequency & position manager)
- `git-delta` (syntax-highlighting pager for git)
- `lazygit` (terminal git client)
- `yazi` (blazing fast terminal file manager)
- `eza` (modern `ls` replacement)
- `bat` (`cat` clone with syntax highlighting)
- `btop` (resource monitor)
- `ripgrep` & `fd` (lightning-fast search tools)
- `jq`, `gh`, `python`, `uv`, `node`, `mole`

### 📱 Applications
- **Firefox** (web browser)
- **MonitorControl** (external display brightness control)
- **Keka** (archive manager)
- **OnlyOffice** (document editing)
- **Clash Verge Rev** (proxy & TUN manager)

---

## 📁 Repository Structure

```text
~/.dotfiles/
├── aerospace/      # AeroSpace tiling configuration
├── btop/           # Resource monitor theme & settings
├── ghostty/        # Ghostty terminal styling & font settings
├── git/            # Global gitignore patterns
├── linearmouse/    # LinearMouse acceleration settings
├── nvim/           # Neovim init.lua & lazy-lock.json
├── yazi/           # Yazi terminal file manager
├── Brewfile        # Complete Homebrew bundle manifest
├── install.sh      # Idempotent bootstrap script
├── macos.sh        # System defaults (AeroSpace, key repeat, Finder, Dock)
├── starship.toml   # Starship prompt configuration
├── zshrc           # Shell aliases, history, and plugin hooks
├── zshenv          # XDG base directory specification
├── gitconfig       # Git user info, delta pager, and diff3
└── psqlrc          # PostgreSQL interactive shell setup
```

---

## ⚙️ Post-Install Checklist

After running `install.sh`:
1. **Accessibility Permissions**: Open *System Settings → Privacy & Security → Accessibility* and enable **AeroSpace** and **LinearMouse**.
2. **Postgres.app**: Launch Postgres.app once to initialize the default cluster on port 5432.
3. **Caps Lock**: Open *System Settings → Keyboard → Input Sources* and enable *"Use Caps Lock to switch to and from ABC"*.
4. **GitHub CLI**: Run `gh auth login` to link git credentials.
