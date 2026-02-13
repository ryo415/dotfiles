#!/bin/zsh

if ! which git 1>/dev/null 2>&1; then
  echo 'ERROR: git command required...'
  exit 1
fi

DOTFILES_DIR="$HOME/dotfiles"

if [ ! -d "$DOTFILES_DIR/opt" ]; then
  mkdir "$DOTFILES_DIR/opt"
fi

cd $DOTFILES_DIR/opt
git clone https://github.com/ryanoasis/nerd-fonts.git

cd nerd-fonts
./install.sh
