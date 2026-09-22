# ==============================================================================
# XDG Base Directory Specification
# Prevents CLI tools and runtime environments from cluttering $HOME root
# ==============================================================================

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Developer & CLI Tools redirection
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export SQLITE_HISTORY="$XDG_STATE_HOME/sqlite_history"
