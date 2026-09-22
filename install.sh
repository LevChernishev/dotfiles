#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Homebrew
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  BREW_BIN="/opt/homebrew/bin/brew"
  [[ -f "$BREW_BIN" ]] || BREW_BIN="/usr/local/bin/brew"
  eval "$($BREW_BIN shellenv)"
fi

# 2. Установка пакетов из Brewfile
echo "Installing packages..."
brew bundle --file="$DIR/Brewfile"

# 3. Симлинки конфигураций
echo "Linking dotfiles..."
mkdir -p "$HOME/.config"
ln -sf "$DIR/zshrc"     "$HOME/.zshrc"
ln -sf "$DIR/gitconfig" "$HOME/.gitconfig"

ln -sfn "$DIR/aerospace"   "$HOME/.config/aerospace"
ln -sfn "$DIR/ghostty"     "$HOME/.config/ghostty"
ln -sfn "$DIR/linearmouse" "$HOME/.config/linearmouse"
ln -sfn "$DIR/nvim"        "$HOME/.config/nvim"

# 4. Настройки macOS
echo "Configuring macOS..."
# Отключение автоперемешивания столов (критично для AeroSpace)
defaults write com.apple.dock mru-spaces -bool false
killall Dock 2>/dev/null || true

# Переключение языка по Caps Lock
defaults write -g TISRomanSwitchState -int 1

echo ""
echo "Setup complete! Next steps:"
echo "1. System Settings -> Privacy & Security -> Accessibility: Enable AeroSpace & LinearMouse."
echo "2. Open Postgres.app once to initialize default database cluster."
echo "3. Restart terminal or log out to ensure all macOS defaults take effect."
