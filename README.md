# 🛠️ Lev's Minimal macOS Dotfiles

A pure, zero-bloat developer environment for macOS. Built strictly around upstream defaults with zero unnecessary maintenance overhead.

## 🎯 Philosophy

- **True Upstream Defaults**: Let tools do what their creators designed them to do. Avoid over-customization ("ricing").
- **Bare Minimum Toolset**: Only what is strictly necessary — window management, terminal, editor, VPN, database, and mouse scrolling.
- **Instant Speed**: Shell opens in milliseconds without heavy plugin frameworks.

---

## ⚡ Quick Start (Fresh Mac)

Open **Terminal.app** on a fresh macOS installation and run:

```bash
git clone https://github.com/LevChernishev/dotfiles.git ~/.dotfiles && ~/.dotfiles/install.sh
```

### What `install.sh` does:
1. Installs Homebrew (if missing).
2. Installs core packages via `brew bundle`.
3. Symlinks app configurations to `~/.config/` and dotfiles to `$HOME`.
4. Configures macOS essentials (AeroSpace spaces fix and Caps Lock input source switching).

---

## 📦 What Gets Installed

- **[AeroSpace](https://github.com/nikitabobko/AeroSpace)** — Tiling window manager for macOS (GUI app & CLI).
- **[LinearMouse](https://linearmouse.app/)** — Disables mouse acceleration, enables linear scrolling distance.
- **[MonitorControl](https://github.com/MonitorControl/MonitorControl)** — Controls external monitor brightness & volume.
- **[Ghostty](https://ghostty.org/)** — GPU-accelerated terminal with tabs and Catppuccin Mocha.
- **[Firefox](https://www.mozilla.org/firefox/)** — Fast, private web browser.
- **[Neovim](https://neovim.io/) with [AstroNvim v4](https://astronvim.com/)** — Modern modal editor with built-in LSP & Treesitter.
- **[Postgres.app](https://postgresapp.com/)** — Native PostgreSQL server.
- **[Clash Verge Rev](https://github.com/clash-verge-rev/clash-verge-rev)** — VPN & TUN proxy client.
- **CLI Utilities**:
  - `ripgrep` — Fast regex code search for terminal & Neovim.
  - `fd` — Simple, fast alternative to `find`.
  - `lazygit` — Terminal UI for git.
  - `displayplacer` — Multi-display resolutions and arrangements.
  - `mole` — System cleanup utility.
- **Font**: FiraCode Nerd Font for editor and terminal glyphs.

---

## 📁 Repository Structure

```text
~/.dotfiles/
├── aerospace/          # AeroSpace tiling configuration
├── ghostty/            # Ghostty terminal styling & font
├── linearmouse/        # LinearMouse acceleration & scroll settings
├── nvim/               # AstroNvim v4 template & Catppuccin theme
├── Brewfile            # Minimal Homebrew bundle manifest
├── install.sh          # Idempotent bootstrap script
├── gitconfig           # Git user identity and default branch
└── zshrc               # Vanilla Zsh with Homebrew & Postgres PATH
```

---

## ⚙️ Post-Install Checklist

After running `install.sh`:
1. **Accessibility Permissions**: Open *System Settings → Privacy & Security → Accessibility* and enable **AeroSpace** and **LinearMouse**.
2. **Postgres.app**: Launch Postgres.app once to initialize the default cluster on port 5432.
3. **Log Out & Log Back In**: Ensures macOS keyboard input daemon applies the Caps Lock language switch.
