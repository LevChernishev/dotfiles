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
echo "Installing packages from Brewfile..."
brew bundle --file="$DIR/Brewfile"

# 3. Проверка и настройка AeroSpace (приложение + CLI)
echo "Checking AeroSpace..."
if [ ! -d "/Applications/AeroSpace.app" ] || ! command -v aerospace &>/dev/null; then
  echo "Configuring AeroSpace..."
  brew trust nikitabobko/tap 2>/dev/null || true
  brew install --cask --no-quarantine nikitabobko/tap/aerospace --force 2>/dev/null || {
    echo "Falling back to direct AeroSpace download..."
    curl -fsSL -o /tmp/aerospace.zip "https://github.com/nikitabobko/AeroSpace/releases/download/v0.21.3-Beta/AeroSpace-v0.21.3-Beta.zip"
    unzip -qo /tmp/aerospace.zip -d /tmp/aerospace_extracted
    cp -R /tmp/aerospace_extracted/*/AeroSpace.app /Applications/ 2>/dev/null || cp -R /tmp/aerospace_extracted/AeroSpace.app /Applications/
    AERO_BIN="$(find /tmp/aerospace_extracted -type f -name "aerospace" 2>/dev/null | head -n 1)"
    if [[ -n "$AERO_BIN" ]]; then
      mkdir -p /opt/homebrew/bin
      cp "$AERO_BIN" /opt/homebrew/bin/aerospace 2>/dev/null || true
      chmod +x /opt/homebrew/bin/aerospace 2>/dev/null || true
    fi
    rm -rf /tmp/aerospace*
    xattr -dr com.apple.quarantine "/Applications/AeroSpace.app" 2>/dev/null || true
  }
  echo "AeroSpace ready."
fi

# 4. Установка Clash Verge Rev (рабочая стабильная версия v2.5.2)
if [ ! -d "/Applications/Clash Verge.app" ]; then
  echo "Installing Clash Verge Rev v2.5.2..."
  CLASH_URL="https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v2.5.2/Clash.Verge_2.5.2_aarch64.dmg"
  curl -fsSL -o /tmp/Clash.Verge.dmg "$CLASH_URL"
  hdiutil attach /tmp/Clash.Verge.dmg -nobrowse -mountpoint /tmp/clash_mount
  cp -R "/tmp/clash_mount/Clash Verge.app" /Applications/
  hdiutil detach /tmp/clash_mount
  rm -f /tmp/Clash.Verge.dmg
  xattr -dr com.apple.quarantine "/Applications/Clash Verge.app" 2>/dev/null || true
  echo "Clash Verge Rev installed."
fi

# 5. Симлинки конфигураций
echo "Linking dotfiles..."
mkdir -p "$HOME/.config"
ln -sf "$DIR/zshrc"     "$HOME/.zshrc"
ln -sf "$DIR/gitconfig" "$HOME/.gitconfig"

ln -sfn "$DIR/aerospace"   "$HOME/.config/aerospace"
ln -sfn "$DIR/ghostty"     "$HOME/.config/ghostty"
ln -sfn "$DIR/linearmouse" "$HOME/.config/linearmouse"
ln -sfn "$DIR/nvim"        "$HOME/.config/nvim"
ln -sfn "$DIR/starship"    "$HOME/.config/starship"
ln -sf  "$DIR/starship/starship.toml" "$HOME/.config/starship.toml"

# 6. Настройки macOS
echo "Configuring macOS..."
# Отключение автоперемешивания столов (критично для AeroSpace)
defaults write com.apple.dock mru-spaces -bool false
killall Dock 2>/dev/null || true

# Переключение языка по Caps Lock
defaults write -g TISRomanSwitchState -int 1

# Настройки Finder: вид списком, строка пути и строка состояния
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
killall Finder 2>/dev/null || true

echo ""
echo "========================================="
echo "     Setup complete successfully!        "
echo "========================================="
echo ""
echo "Next steps:"
echo "1. System Settings -> Privacy & Security -> Accessibility: Enable AeroSpace & LinearMouse."
echo "2. Open Postgres.app once to initialize default database cluster."
echo "3. Restart terminal or log out to ensure all macOS defaults take effect."
