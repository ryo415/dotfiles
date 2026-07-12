# Quickshell Desktop Modules

現在は通知デーモン、右上の通知ポップアップ、Power Menuを起動します。Waybar から移行するための `Bar.qml` はプロトタイプとして残していますが、`shell.qml` では一時的に無効化しています。

## Power Menu

Power Menuは `Super+M`、WaybarのArchアイコン、または次のIPCコマンドで開閉できます。

```sh
quickshell ipc call powerMenu toggle
```

Lockはクリックするとすぐに実行します。Logout、Shutdown、Suspend、Rebootは、3秒以内に同じボタンをもう一度クリックすると実行します。Escape、背景クリック、または再度トグルすると閉じます。

wlogoutへ戻す場合は、Power Menuを閉じて次を実行できます。

```sh
wlogout
```

## Notification Test

mako と Quickshell は同時に通知デーモンとして動かせないため、テスト前に mako を停止します。

```sh
systemctl --user stop mako.service
quickshell --path ~/.config/quickshell --no-duplicate
notify-send "Quickshell test" "This notification should be shown by Quickshell"
```

mako に戻す場合:

```sh
pkill quickshell
systemctl --user start mako.service
```

## Layout

- Left: Hyprland workspaces, active window title
- Center: clock, app launchers
- Right: audio sink/source, network, bluetooth, temperature, CPU, memory, system tray

Waybar の対応元:

- `group/workspace`: `hyprland/workspaces`, `hyprland/window`
- `clock`: short / long clock
- `group/distro-group`: Arch, terminal, Steam, Discord, Notion launcher
- `group/audio`: sink and source volume
- `group/connections`: network and bluetooth
- `group/system`: temperature and CPU
- `group/storage`: memory
- `group/tray-group`: system tray

## Files

- `shell.qml`: Quickshell entrypoint
- `modules/notifications/NotificationOverlay.qml`: notification server and top-right overlay
- `modules/notifications/NotificationCard.qml`: notification popup presentation and timeout
- `modules/power/PowerMenu.qml`: power menu overlay, IPC handler, and commands
- `modules/power/PowerButton.qml`: power action button and confirmation state
- `modules/bar/Bar.qml`: bar layout, colors, Quickshell service integration, small inline components
- `scripts/status.sh`: CPU, memory, and temperature polling helper

## Design Notes

- Quickshell: `0.3.0`
- Bar height: `30px`
- Background: transparent
- Module style: compact capsules based on the existing Waybar CSS
- Colors: copied from the current matugen-generated Waybar palette
- Font: `JetBrainsMono Nerd Font`

This is intentionally a prototype. Once the shape feels right, split `Bar.qml` into smaller widgets such as `Workspaces.qml`, `Audio.qml`, `SystemStats.qml`, and `Tray.qml`.

## Commands

Run manually:

```sh
quickshell --path ~/.config/quickshell --no-duplicate
```

Run with verbose logs:

```sh
quickshell --path ~/.config/quickshell --no-duplicate --verbose
```

If Waybar is still running, stop it before checking final placement:

```sh
pkill waybar
```

## Interactions

- Workspace click: switch workspace
- Clock click: toggle short / long clock format
- Audio left click: toggle default sink mute
- Audio right click: toggle default source mute
- Tray left click: activate item
- Tray middle click: secondary activate
- Tray right click: show item menu

## Current Limits

- Network display is intentionally simple: Wi-Fi SSID if available, otherwise device name.
- The Waybar calendar tooltip is not implemented yet.
- Drawer animations from Waybar groups are not implemented yet.
- Per-monitor persistent workspace mapping is simplified to fixed workspaces `1..10`.
