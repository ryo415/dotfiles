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

# if os is Debian, batcat will be installed instead bat.
if type batcat > /dev/null 2>&1; then
  alias bat='batcat'
fi

if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi

if type bat > /dev/null 2>&1; then
  alias cat='bat'
fi

if type eza > /dev/null 2>&1; then
  alias ls='eza'
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
if type starship > /dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# mise
if type mise > /dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

