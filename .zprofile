# ============================================
# ~/.zprofile
# Login shell configuration
# - Loaded only for login shells
# - Environment variables / PATH definitions
# ============================================


# --------------------------------------------
# PATH
# --------------------------------------------

if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# --------------------------------------------
# Environment Variables
# --------------------------------------------

# export EDITOR="vim"
export LANG="ja_JP.UTF-8"

# --------------------------------------------
# Custom shared profile (optional)
# --------------------------------------------

# If you want to share settings with bash:
# [ -f "$HOME/.profile" ] && source "$HOME/.profile"
