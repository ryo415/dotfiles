#!/bin/zsh

curl -fsSL https://starship.rs/install.sh | bash

ln -s $HOME/dotfiles/.config/starship.toml $HOME/.config/starship.toml
