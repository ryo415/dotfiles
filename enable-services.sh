#!/usr/bin/env bash

systemctl --user daemon-reload

# Quickshell provides org.freedesktop.Notifications. Mask mako because disabling
# it alone still allows D-Bus activation to start it as the notification server.
systemctl --user mask --now mako.service

systemctl --user enable waybar.service
systemctl --user enable --now quickshell.service
systemctl --user enable hypridle.service
systemctl --user enable cliphist-text.service
systemctl --user enable cliphist-image.service

# パッケージ付属
systemctl --user enable hyprpolkitagent.service
