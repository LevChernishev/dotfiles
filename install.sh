#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install || true
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
fi

# 2. Homebrew
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  BREW_BIN="/opt/homebrew/bin/brew"
  [[ -f "$BREW_BIN" ]] || BREW_BIN="/usr/local/bin/brew"
  if ! grep -q 'brew shellenv' "$HOME/.zprofile" 2>/dev/null; then
    echo "eval \"\$($BREW_BIN shellenv)\"" >> "$HOME/.zprofile"
  fi
  eval "$($BREW_BIN shellenv)"
fi

# 3. Приложения через Brewfile
if [[ -f "$DIR/Brewfile" ]]; then
  echo "Installing applications from Brewfile..."
  brew bundle --file="$DIR/Brewfile"
fi

# 4. Создание XDG и локальных каталогов
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/state/zsh"

# 5. Симлинки основных dotfiles в $HOME
echo "Linking root dotfiles..."
ln -sf "$DIR/zshrc"     "$HOME/.zshrc"
ln -sf "$DIR/zshenv"    "$HOME/.zshenv"
ln -sf "$DIR/gitconfig" "$HOME/.gitconfig"
ln -sf "$DIR/psqlrc"    "$HOME/.psqlrc"

# 6. Симлинки папок конфигураций в ~/.config/
echo "Linking apps into ~/.config..."
for config_dir in aerospace ghostty git linearmouse nvim; do
  if [[ -d "$DIR/$config_dir" ]]; then
    ln -sfn "$DIR/$config_dir" "$HOME/.config/$config_dir"
  fi
done
ln -sf "$DIR/starship.toml" "$HOME/.config/starship.toml"

# 7. Предварительная синхронизация плагинов Neovim
if command -v nvim &>/dev/null; then
  echo "Syncing Neovim plugins headlessly..."
  nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
fi

# 8. Системные настройки macOS
if [[ -f "$DIR/macos.sh" ]]; then
  echo "Applying macOS system defaults..."
  bash "$DIR/macos.sh"
fi

echo ""
echo "==========================================="
echo "     Setup complete successfully!          "
echo "==========================================="
echo ""
echo "Next steps to finalize setup:"
echo "1. System Settings -> Privacy & Security -> Accessibility:"
echo "   - Enable AeroSpace"
echo "   - Enable LinearMouse"
echo "2. Launch Postgres.app once to initialize default cluster (port 5432)."
echo "3. Run 'gh auth login' to authenticate GitHub CLI."
echo "4. Generate SSH key if needed: ssh-keygen -t ed25519 -C \"chernishevlev@gmail.com\""
echo "5. Restart your terminal or run: source ~/.zshrc"
