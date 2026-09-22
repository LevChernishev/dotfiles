#!/usr/bin/env bash
set -euo pipefail

echo "Applying macOS system defaults..."

# 1. Для AeroSpace: отключаем автоперемешивание рабочих столов
defaults write com.apple.dock mru-spaces -bool false

# 2. Для Vim/Neovim: отключаем акценты при зажатии и ускоряем повтор клавиш
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 10

# 3. Finder: скрытые файлы, расширения, строка пути
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true

# 4. Dock: скрывать автоматически и убрать задержку показа
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0

# Перезапуск затронутых служб
killall Dock Finder 2>/dev/null || true

echo "macOS defaults applied!"
