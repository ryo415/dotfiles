# setup scripts

This directory contains helper scripts to set up shell tools, fonts, and Docker-related packages.

## scripts overview

### `zsh.sh`
- Purpose: Install `zplug` for Zsh.
- Action:
  - Downloads the official installer script and runs it with `zsh`.
- Requirements:
  - `curl`
  - `zsh`
- Run:
```bash
./zsh.sh
```

### `starship.sh`
- Purpose: Install Starship prompt and link your config.
- Action:
  - Runs the Starship install script.
  - Creates `~/.config` if missing.
  - Symlinks `$HOME/dotfiles/.config/starship.toml` to `~/.config/starship.toml`.
- Requirements:
  - `curl`
  - `bash`
- Run:
```bash
./starship.sh
```
- Notes:
  - If `~/.config/starship.toml` already exists, `ln -s` may fail.

### `powerline.sh`
- Purpose: Install Powerline and Powerline fonts.
- Action:
  - Clones `powerline`, installs with `python3 setup.py install`, then removes the repo.
  - Clones `powerline/fonts`, runs `./install.sh`, then removes the repo.
- Requirements:
  - `git`
  - `python3`
- Run:
```bash
./powerline.sh
```

### `nerd-fonts.sh`
- Purpose: Install Nerd Fonts (all fonts or one target font).
- Usage:
```bash
./nerd-fonts.sh all
./nerd-fonts.sh <FontName>
```
- Action:
  - `all`:
    - Clones `ryanoasis/nerd-fonts` into `$HOME/dotfiles/opt/nerd-fonts` (if not cloned yet).
    - Runs `./install.sh` from the cloned repo.
  - `<FontName>`:
    - Downloads only `https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/<FontName>.zip`.
    - Extracts into:
      - macOS: `~/Library/Fonts`
      - Linux: `~/.local/share/fonts`
    - Runs `fc-cache -fv` when `fc-cache` exists.
- Requirements:
  - `git`
  - `curl`
  - `unzip`
- Notes:
  - `<FontName>` must match the Nerd Fonts release asset name exactly (without `.zip`).

### `docker.sh`
- Purpose: Install Docker Engine packages from Docker's official Debian repository.
- Action:
  - Adds Docker apt key and repository.
  - Installs `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, `docker-compose-plugin`.
- Requirements:
  - Debian-based system with `apt`
  - Root user
- Run:
```bash
sudo ./docker.sh
```
- Notes:
  - The script itself checks `whoami` and exits unless run as `root`.
  - This script is intended for Debian-family Linux environments.
