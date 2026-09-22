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
git clone https://github.com/LevChernishev/dotfiles.git ~/.config && ~/.config/install.sh
```

### What `install.sh` does:
1. Installs Apple Xcode Command Line Tools (if missing).
2. Installs Homebrew (if missing).
3. Installs all packages and applications via `brew bundle`.
4. Symlinks standard dotfiles (`.zshrc`, `.zshenv`, `.gitconfig`, `.psqlrc`) to `$HOME`.

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

### 🧑‍💻 Code & Editors
- **[Neovim](https://neovim.io/)** — Fast modal editor configured with `lazy.nvim`, `vim-dadbod-ui` (SQL client), `fzf-lua`, `oil.nvim`, and Tree-sitter.
- **[Zed](https://zed.dev/)** — High-performance GUI code editor.

### 🐘 Databases
- **[Postgres.app](https://postgresapp.com/)** — Native PostgreSQL server for macOS.
- **[DBeaver](https://dbeaver.io/)** — Universal database GUI client.
- **`lazysql`** — Terminal UI for database queries and exploration.
- **`pgformatter`** — Automatic SQL formatting via `pg_format`.
- Custom `~/.psqlrc` with rich prompts, unicode borders, timing, and monitoring macros.

### 🧰 CLI Utilities
- `git-delta` (syntax-highlighting pager for git)
- `lazygit` (terminal git client)
- `yazi` (blazing fast terminal file manager)
- `eza` (modern `ls` replacement)
- `bat` (`cat` clone with syntax highlighting)
- `btop` (resource monitor)
- `ripgrep` & `fd` (lightning-fast search tools)
- `jq`, `gh`, `python`, `node`, `mole`

### 📱 Applications
- **Firefox** (web browser)
- **MonitorControl** (external display brightness control)
- **Keka** (archive manager)
- **OnlyOffice** (document editing)
- **Clash Verge Rev** (proxy & TUN manager)

---

## 📁 Repository Structure

```text
~/.config/
├── aerospace/      # AeroSpace tiling configuration
├── ghostty/        # Ghostty terminal styling & font settings
├── linearmouse/    # LinearMouse acceleration settings
├── nvim/           # Neovim init.lua & lazy-lock.json
├── zed/            # Zed editor settings
├── yazi/           # Yazi terminal file manager
├── btop/           # Resource monitor theme & settings
├── Brewfile        # Complete Homebrew bundle manifest
├── install.sh      # 30-line idempotent bootstrap script
├── zshrc           # Shell aliases and plugin hooks
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
