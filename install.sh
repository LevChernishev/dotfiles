#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
fi

# 2. Homebrew
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 3. Applications via Brewfile
if [[ -f "$DIR/Brewfile" ]]; then
  echo "Installing applications from Brewfile..."
  brew bundle --file="$DIR/Brewfile"
fi

# 4. Dotfiles symlinks
echo "Linking dotfiles..."
ln -sf "$DIR/zshrc"     "$HOME/.zshrc"
ln -sf "$DIR/zshenv"    "$HOME/.zshenv"
ln -sf "$DIR/gitconfig" "$HOME/.gitconfig"
ln -sf "$DIR/psqlrc"    "$HOME/.psqlrc"

echo "Setup complete!"
