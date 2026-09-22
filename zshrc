# Homebrew окружение
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"

# Доступ к CLI-утилитам Postgres.app (psql, pg_dump и др.)
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

# Системный редактор по умолчанию
export EDITOR="nvim"
