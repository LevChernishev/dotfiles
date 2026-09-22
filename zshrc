# Homebrew окружение
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"

# Доступ к CLI-утилитам Postgres.app (psql, pg_dump и др.)
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

# Системный редактор по умолчанию
export EDITOR="nvim"

# Конфигурация Starship Prompt
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# ------------------------------------------------------------------------------
# 1. Расширенная история команд
# ------------------------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY          # Запись таймштампов в историю
setopt HIST_EXPIRE_DUPS_FIRST    # Удалять дубликаты первыми при переполнении истории
setopt HIST_IGNORE_DUPS          # Не записывать подряд повторяющиеся команды
setopt HIST_IGNORE_SPACE         # Игнорировать команды, начинающиеся с пробела (для секретов)
setopt HIST_VERIFY               # Показывать команду перед выполнением при вызове из истории
setopt SHARE_HISTORY             # Делиться историей между всеми вкладками/окнами терминала

# ------------------------------------------------------------------------------
# 2. Быстрое перемещение по папкам (zoxide -> z)
# ------------------------------------------------------------------------------
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# ------------------------------------------------------------------------------
# 3. Интерактивный нечеткий поиск (fzf)
# ------------------------------------------------------------------------------
if command -v fzf &>/dev/null; then
  # Использование fd для поиска файлов и папок
  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type d --strip-cwd-prefix --hidden --follow --exclude .git"
  fi

  # Цветовая схема Catppuccin Mocha для fzf
  export FZF_DEFAULT_OPTS=" \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a \
  --prompt='❯ ' --pointer='▶' --marker='✓' --layout=reverse --border"

  # Интеграция fzf (Ctrl+R для истории, Ctrl+T для файлов, Alt+C для папок)
  source <(fzf --zsh)
fi

# ------------------------------------------------------------------------------
# 4. Автодополнение команд из истории (Fish-like)
# ------------------------------------------------------------------------------
if [[ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#585b70"
fi

# ------------------------------------------------------------------------------
# 5. Подсветка синтаксиса (подключается в конце списка плагинов)
# ------------------------------------------------------------------------------
if [[ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ------------------------------------------------------------------------------
# 6. Красивая строка ввода (Starship Prompt)
# ------------------------------------------------------------------------------
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi
