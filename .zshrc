# ============================================
# ~/.zshrc
# Interactive shell configuration
# - Loaded for interactive shells
# - Aliases / completion / prompt / plugins
# ============================================

# --------------------------------------------
# Safety: run only in interactive shells
# --------------------------------------------

[[ -o interactive ]] || return

# --------------------------------------------
# Aliases
# --------------------------------------------

alias la='ls -a'
alias ll='ls -l'

if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi

if type bat > /dev/null 2>&1; then
  alias cat='bat'
fi

# --------------------------------------------
# Completion
# --------------------------------------------

autoload -Uz compinit
compinit

# --------------------------------------------
# Prompt
# --------------------------------------------

# starship
# eval "$(starship init zsh)"



# rbenv
# export RBENV_ROOT="/usr/local/lib/rbenv"
# export PATH="${RBENV_ROOT}/bin:${PATH}"
# eval "$(rbenv init -)"
# zstyle ':completion:*:default' menu select=2

# node
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

