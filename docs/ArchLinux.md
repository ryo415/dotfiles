# Arch Linux
## ENVIRONMENT
### GUI
- main: hyprland
  - temp: sway
- sub: KDE

### Apps
- Terminal: wezterm
```bash
# install latest wezterm
yay -S wezterm-nightly-bin

# configure drowing by software(not GPU)
# in wezterm config
# config.front_end = "Software"

```
- Application Launcher: wofi
```bash
# boot
wofi --show drun    # list
wofi --show run     # run command
wofi --show window  # switch window
```
- status bar: waybar
- browser: firefox
  - sub: qutebrowser

