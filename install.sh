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
    if ! grep -q 'brew shellenv' "$HOME/.zprofile" 2>/dev/null; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    fi
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

# 4. Clash Verge Rev
echo -e "\n${GREEN}[4/7] Checking Clash Verge Rev...${NC}"
if [ ! -d "/Applications/Clash Verge.app" ] && [ ! -d "$HOME/Applications/Clash Verge.app" ]; then
    echo -e "${YELLOW}Installing Clash Verge Rev...${NC}"
    brew install --cask clash-verge-rev 2>/dev/null || {
        curl -Lo /tmp/Clash.Verge.dmg "https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v2.5.2/Clash.Verge_2.5.2_aarch64.dmg"
        hdiutil attach /tmp/Clash.Verge.dmg -nobrowse -mountpoint /tmp/clash_mount
        cp -R "/tmp/clash_mount/Clash Verge.app" /Applications/
        hdiutil detach /tmp/clash_mount
        rm -f /tmp/Clash.Verge.dmg
        xattr -dr com.apple.quarantine "/Applications/Clash Verge.app" 2>/dev/null || true
    }
    echo -e "Clash Verge Rev installed to /Applications/Clash Verge.app."
else
    echo -e "Clash Verge Rev is already installed."
fi

# 5. Shell symlinks (Zsh & dotfiles)
echo -e "\n${GREEN}[5/7] Linking dotfiles and shell config...${NC}"
for file in zshrc zshenv gitconfig psqlrc; do
    if [ -f "$DIR/$file" ]; then
        ln -sf "$DIR/$file" "$HOME/.$file"
        echo -e "Linked $DIR/$file -> ~/.$file"
    fi
done

# 6. Antigravity & Open AG Patcher
echo -e "\n${GREEN}[6/7] Setting up Open AG Patcher...${NC}"
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

# 7. Neovim plugins sync
echo -e "\n${GREEN}[7/7] Pre-installing Neovim plugins (Lazy.nvim)...${NC}"
if command -v nvim &>/dev/null; then
    echo -e "Syncing Neovim plugins headlessly..."
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
    echo -e "Neovim plugins synchronized."
else
    echo -e "${YELLOW}Neovim binary not found, skipping plugin sync.${NC}"
fi

echo -e "\n${GREEN}===========================================${NC}"
echo -e "${GREEN}    Installation & Configuration Complete! ${NC}"
echo -e "${GREEN}===========================================${NC}\n"
echo -e "${BLUE}Next steps to finalize setup:${NC}"
echo -e "1. ${YELLOW}Permissions:${NC} Open System Settings -> Privacy & Security -> Accessibility:"
echo -e "   - Enable ${GREEN}AeroSpace${NC}"
echo -e "   - Enable ${GREEN}LinearMouse${NC}"
echo -e "2. ${YELLOW}PostgreSQL:${NC} Open ${GREEN}Postgres.app${NC} once to initialize local cluster on port 5432."
echo -e "3. ${YELLOW}GitHub Auth:${NC} Run ${GREEN}gh auth login${NC} to authenticate Git & CLI."
echo -e "4. ${YELLOW}SSH Key:${NC} If not already generated: ${GREEN}ssh-keygen -t ed25519 -C \"chernishevlev@gmail.com\"${NC}"
echo -e "5. ${YELLOW}Language Switch:${NC} System Settings -> Keyboard -> Input Sources -> Enable 'Use Caps Lock to switch'."
if [ -f "$PATCHER_DIR/Open_AG_Patcher_macOS" ]; then
    echo -e "6. ${YELLOW}Antigravity:${NC} Run ${GREEN}sudo $PATCHER_DIR/Open_AG_Patcher_macOS${NC} to patch Antigravity apps."
fi
