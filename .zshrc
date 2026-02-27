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

# mise
# eval "$(mise activate zsh)"

