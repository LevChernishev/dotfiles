eval "$(starship init zsh)"
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Включение стандартного автодополнения по Tab
autoload -Uz compinit && compinit -u
zstyle ':completion:*' menu select

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# Перенаправление вызовов vim и vi на neovim
alias vim="nvim"
alias vi="nvim"
alias v="nvim"

# Назначение Neovim системным редактором по умолчанию
export EDITOR="nvim"
export VISUAL="nvim"
# Настройка vi-режима (по умолчанию Normal mode)
function zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_NORMAL
}

source /opt/homebrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# Интеграция fzf (Ctrl+T для поиска файлов, Ctrl+R для поиска по истории)
eval "$(fzf --zsh)"

# Интеграция zoxide (быстрая навигация z <папка>)
eval "$(zoxide init zsh)"

# Алиасы для современных утилит
alias ls="eza --icons"
alias ll="eza -l --icons --git"
alias la="eza -la --icons --git"
alias tree="eza --tree --icons"

alias cat="bat --paging=never"
alias lg="lazygit"

# Postgres.app CLI tools
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

