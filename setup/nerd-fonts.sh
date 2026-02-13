#!/bin/zsh

if ! which git 1>/dev/null 2>&1; then
  echo 'ERROR: git command required...'
  exit 1
fi

cd $HOME/dotfiles/opt
git clone https://github.com/ryanoasis/nerd-fonts.git

cd nerd-fonts
./install.sh
