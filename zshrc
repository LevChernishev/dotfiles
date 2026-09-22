# 1. Prompt (Starship)
eval "$(starship init zsh)"

# 2. История команд
export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
export HISTSIZE=50000
export SAVEHIST=50000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# 3. Автодополнение по Tab
autoload -Uz compinit && compinit -u
zstyle ':completion:*' menu select

# 4. Редактор по умолчанию и алиасы
export EDITOR="nvim"
export VISUAL="nvim"
alias vim="nvim"
alias vi="nvim"
alias v="nvim"

# 5. Vi-режим (дефолтный insert-режим, Esc для перехода в normal mode)
function zvm_after_init() {
  eval "$(fzf --zsh)"
}

HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

if [[ -f "$HOMEBREW_PREFIX/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]]; then
  source "$HOMEBREW_PREFIX/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
fi

if [[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# 6. Интеграция zoxide (быстрая навигация z <папка>)
eval "$(zoxide init zsh)"

# 7. Алиасы
alias ls="eza --icons"
alias ll="eza -l --icons --git"
alias la="eza -la --icons --git"
alias tree="eza --tree --icons"
alias cat="bat --plain --paging=never"
alias lg="lazygit"

# 8. PATH
export PATH="$HOME/.local/bin:${CARGO_HOME:-$HOME/.local/share/cargo}/bin:/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

# 9. Синтаксическая подсветка (всегда загружается последней)
if [[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
