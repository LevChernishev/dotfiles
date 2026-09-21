#!/usr/bin/env bash
set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}    macOS Environment Setup & Installer    ${NC}"
echo -e "${BLUE}===========================================${NC}\n"

# 1. Xcode Command Line Tools
echo -e "${GREEN}[1/7] Checking Xcode Command Line Tools...${NC}"
if ! xcode-select -p &>/dev/null; then
    echo -e "${YELLOW}Installing Xcode Command Line Tools...${NC}"
    xcode-select --install
    echo -e "${YELLOW}Please complete the installation dialog and run this script again.${NC}"
    exit 1
else
    echo -e "Xcode Command Line Tools already installed."
fi

# 2. Homebrew
echo -e "\n${GREEN}[2/7] Checking Homebrew...${NC}"
if ! command -v brew &>/dev/null; then
    echo -e "${YELLOW}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
else
    echo -e "Homebrew is already installed."
fi

# 3. Brewfile packages & apps
echo -e "\n${GREEN}[3/7] Installing packages and apps from Brewfile...${NC}"
if [ -f "$DIR/Brewfile" ]; then
    brew bundle --file="$DIR/Brewfile"
else
    echo -e "${RED}Error: Brewfile not found in $DIR${NC}"
    exit 1
fi

# 4. Hiddify (from GitHub Releases)
echo -e "\n${GREEN}[4/7] Checking Hiddify...${NC}"
if [ ! -d "/Applications/Hiddify.app" ]; then
    echo -e "${YELLOW}Downloading and installing latest Hiddify...${NC}"
    HIDDIFY_PKG_URL=$(curl -s https://api.github.com/repos/hiddify/hiddify-app/releases/latest | grep "browser_download_url.*Hiddify-MacOS-Installer.pkg" | head -n1 | cut -d '"' -f 4)
    if [ -n "$HIDDIFY_PKG_URL" ]; then
        curl -Lo /tmp/Hiddify.pkg "$HIDDIFY_PKG_URL"
        sudo installer -pkg /tmp/Hiddify.pkg -target /
        rm -f /tmp/Hiddify.pkg
        echo -e "Hiddify installed."
    else
        echo -e "${YELLOW}Could not resolve Hiddify pkg URL. You can download it from: https://github.com/hiddify/hiddify-app/releases${NC}"
    fi
else
    echo -e "Hiddify is already installed."
fi

# 5. Shell symlinks (Zsh & dotfiles)
echo -e "\n${GREEN}[5/7] Linking dotfiles and shell config...${NC}"
if [ -f "$DIR/zshrc" ]; then
    ln -sf "$DIR/zshrc" "$HOME/.zshrc"
    echo -e "Linked $DIR/zshrc -> ~/.zshrc"
fi

# 6. macOS System Preferences
echo -e "\n${GREEN}[6/7] Configuring macOS system settings...${NC}"
# Нативное переключение языка по Caps Lock
defaults write -g TISRomanSwitchState 1

# Отключение задержки зажатия клавиш (нужно для Neovim/Vim h/j/k/l)
defaults write -g ApplePressAndHoldEnabled -bool false

# Максимальная скорость повтора клавиш
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

# Показывать скрытые файлы в Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Не создавать .DS_Store на сетевых и внешних накопителях
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Быстрая анимация скрытия Dock
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15

echo -e "macOS defaults applied."

# 7. Antigravity & Open AG Patcher
echo -e "\n${GREEN}[7/7] Setting up Open AG Patcher...${NC}"
PATCHER_DIR="$HOME/Projects/open-antigravity-patcher"
if [ ! -d "$PATCHER_DIR" ]; then
    echo -e "${YELLOW}Cloning open-antigravity-patcher...${NC}"
    mkdir -p "$HOME/Projects"
    git clone https://github.com/AvenCores/open-antigravity-patcher.git "$PATCHER_DIR"
else
    echo -e "open-antigravity-patcher repository already exists in $PATCHER_DIR."
fi

if [ -f "$PATCHER_DIR/Open_AG_Patcher_macOS" ]; then
    chmod +x "$PATCHER_DIR/Open_AG_Patcher_macOS"
    xattr -dr com.apple.quarantine "$PATCHER_DIR/Open_AG_Patcher_macOS" 2>/dev/null || true
    echo -e "${BLUE}Open_AG_Patcher_macOS is ready.${NC}"
    echo -e "To patch Antigravity & Antigravity IDE, run:"
    echo -e "  ${YELLOW}sudo $PATCHER_DIR/Open_AG_Patcher_macOS${NC}"
fi

echo -e "\n${GREEN}===========================================${NC}"
echo -e "${GREEN}    Installation & Configuration Complete! ${NC}"
echo -e "${GREEN}===========================================${NC}\n"
echo -e "Next steps:"
echo -e "1. Run ${YELLOW}sudo $PATCHER_DIR/Open_AG_Patcher_macOS${NC} to patch Antigravity apps."
echo -e "2. Launch AeroSpace and grant Accessibility permissions."
echo -e "3. Launch LinearMouse and enable 'Disable scrolling acceleration'."
echo -e "4. Restart your Mac to ensure all system defaults and services take effect."
