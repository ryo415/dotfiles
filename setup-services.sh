#!/usr/bin/env bash

link_user_service() {
  mkdir -p "$HOME/.config/systemd/user"
  ln -sf "$HOME/dotfiles/.config/systemd/user/$1" "$HOME/.config/systemd/user/$1"
}

link_user_service waybar.service
link_user_service quickshell.service
link_user_service hypridle.service
link_user_service cliphist-text.service
link_user_service cliphist-image.service

systemctl --user daemon-reload
