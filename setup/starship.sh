#!/bin/zsh

curl -fsSL https://starship.rs/install.sh | bash


if [ ! -e "$HOME/.config" ]; then
  mkdir $HOME/.config
fi

ln -s $HOME/dotfiles/.config/starship.toml $HOME/.config/starship.toml
