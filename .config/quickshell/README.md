# Quickshell Desktop Modules

現在はマルチモニターBar、通知デーモン、右上の通知ポップアップ、Power Menuを起動します。

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

## System Monitor

Rust製の常駐プロセスが2秒ごとにCPU、RAM、温度を1行JSONで出力し、`SystemStats` Singletonが読み取ります。

ビルドと配置:

```sh
cd ~/.config/quickshell/scripts-src/system-monitor
cargo build --release
mkdir -p ../../scripts
cp target/release/system-monitor ../../scripts/system-monitor
```

単体実行:

```sh
~/.config/quickshell/scripts/system-monitor
```

更新間隔を変更する場合:

```sh
~/.config/quickshell/scripts/system-monitor --interval 1
```

出力例:

```json
{"cpu":12.3,"ram":48.1,"temp":55.0}
```

QMLからは `SystemStats.cpuUsage`、`SystemStats.ramUsage`、`SystemStats.temp` で参照できます。CPUとRAMは `0.0`〜`1.0`、温度は摂氏です。

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

- FullBar (main monitor): three floating islands for workspaces, clock, and network/system stats/tray/power
- MiniBar (other monitors): monitor-local workspaces and clock

Set the main monitor name in `modules/bar/BarConfig.qml`. Check available names with `hyprctl monitors`.
If the configured monitor is disconnected, the first entry in `Quickshell.screens` receives the FullBar.
Persistent workspace IDs for each monitor are also configured in `BarConfig.workspaceIdsFor()`.
With only one connected monitor, the FullBar exposes workspaces `1..10` on that screen.

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
- `modules/services/SystemStats.qml`: Rust monitor process and parsed resource values
- `modules/services/NetworkAddresses.qml`: active IPv4/IPv6 address polling for the Bar
- `modules/services/AudioState.qml`: tracked default PipeWire sink/source state for the Bar
- `modules/bar/Bars.qml`: per-screen FullBar/MiniBar selection and main-monitor fallback
- `modules/bar/BarConfig.qml`: configured main monitor name
- `modules/bar/FullBar.qml`: full main-monitor bar
- `modules/bar/MiniBar.qml`: compact secondary-monitor bar
- `modules/bar/Bar.qml`: shared floating-island layout, monitor-local workspace filtering, and Bar data bindings
- `modules/bar/components/BarIsland.qml`: shared translucent island surface
- `modules/bar/components/WorkspaceButton.qml`: active/inactive/urgent workspace pill
- `modules/bar/components/StatusPill.qml`: shared status label surface
- `scripts-src/system-monitor`: Rust source for the resource monitor
- `scripts/system-monitor`: release build consumed by Quickshell
- `scripts/status.sh`: legacy CPU, memory, and temperature polling helper (not used by the Bar)

## Design Notes

- Quickshell: `0.3.0`
- Island height: FullBar `34px`, MiniBar `30px`
- Background: transparent
- Module style: three floating islands on FullBar and two on MiniBar
- Colors: Catppuccin Mocha surfaces with a restrained Material You lavender accent
- Font: `FiraCode Nerd Font Mono`

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
- Network click: toggle IPv4 / IPv6
- Tray left click: activate item
- Tray middle click: secondary activate
- Tray right click: show item menu
- Power click: toggle the existing Power Menu through Quickshell IPC

## Current Limits

- Network display is intentionally simple: Wi-Fi SSID if available, otherwise device name.
- The Waybar calendar tooltip is not implemented yet.
- Drawer animations from Waybar groups are not implemented yet.
- Per-monitor persistent workspace mapping is simplified to fixed workspaces `1..10`.
