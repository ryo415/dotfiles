#!/bin/zsh

if ! which git 1>/dev/null 2>&1; then
  echo 'ERROR: git command required...'
  exit 1
fi

if ! which curl 1>/dev/null 2>&1; then
  echo 'ERROR: curl command required...'
  exit 1
fi

if ! which unzip 1>/dev/null 2>&1; then
  echo 'ERROR: unzip command required...'
  exit 1
fi

NERD_VERSION="3.4.0"
DOTFILES_DIR="$HOME/dotfiles"
TARGET_FONT="$1"
NERD_REPO_DIR="$DOTFILES_DIR/opt/nerd-fonts"

if [ -z "$TARGET_FONT" ]; then
  echo "Usage: $0 <font-name|all>"
  exit 1
fi

if [ ! -d "$DOTFILES_DIR/opt" ]; then
  mkdir "$DOTFILES_DIR/opt"
fi

if [ "$TARGET_FONT" = "all" ]; then
  cd "$DOTFILES_DIR/opt"
  if [ ! -d "$NERD_REPO_DIR/.git" ]; then
    git clone https://github.com/ryanoasis/nerd-fonts.git "$NERD_REPO_DIR"
  fi

  cd "$NERD_REPO_DIR"
  ./install.sh
else
  case "$(uname -s)" in
    Darwin*)
      FONT_DIR="$HOME/Library/Fonts"
      ;;
    *)
      FONT_DIR="$HOME/.local/share/fonts"
      ;;
  esac

  mkdir -p "$FONT_DIR"

  TMP_DIR="$(mktemp -d)"
  FONT_ZIP="$TMP_DIR/$TARGET_FONT.zip"
  FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERD_VERSION/$TARGET_FONT.zip"

  if ! curl -fL -o "$FONT_ZIP" "$FONT_URL"; then
    echo "ERROR: failed to download font '$TARGET_FONT' from $FONT_URL"
    rm -rf "$TMP_DIR"
    exit 1
  fi

  if ! unzip -o "$FONT_ZIP" -d "$FONT_DIR"; then
    echo "ERROR: failed to extract font '$TARGET_FONT'"
    rm -rf "$TMP_DIR"
    exit 1
  fi

  rm -rf "$TMP_DIR"

  if which fc-cache 1>/dev/null 2>&1; then
    fc-cache -fv "$FONT_DIR"
  fi
fi
