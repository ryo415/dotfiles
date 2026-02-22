# Repository Guidelines

## Project Structure & Module Organization
This repository stores personal shell/editor dotfiles and setup helpers.
- Root configs: `.zshrc`, `.zprofile`, `.tmux.conf`, and installer scripts.
- App configs: `.config/nvim/` (Neovim Lua config), `.config/wezterm/` (terminal), `.config/starship.toml`.
- Setup helpers: `setup/*.sh` for optional tooling (zsh, starship, fonts, Docker).
- Documentation: `README.md` (main usage), `setup/README.md` and `setup/README_ja.md` (helper scripts).

## Build, Test, and Development Commands
There is no compile/build step; workflows are script-driven.
- `./setup.sh`: install core packages (`tmux`, `vim`, `zsh`) and create dotfile links.
- `./dotfile_installer.sh link`: create symlinks only.
- `./dotfile_installer.sh update`: recreate symlinks after config changes.
- `./setup/zsh.sh` / `./setup/starship.sh` / `./setup/nerd-fonts.sh <FontName>`: optional environment add-ons.

## Coding Style & Naming Conventions
- Shell scripts use `bash` or `zsh` shebangs; keep scripts POSIX-aware where practical.
- Use 2-space indentation in shell code, avoid tabs, and quote variable expansions (`"$HOME"`).
- Keep file names lowercase with separators when needed (e.g., `nerd-fonts.sh`).
- Neovim/WezTerm Lua modules should stay under `.config/*/lua` with clear, single-purpose files.

## Testing Guidelines
This repo has no automated test framework yet; use syntax and behavior checks before PRs.
- Shell syntax checks: `bash -n setup.sh` and `zsh -n dotfile_installer.sh`.
- Validate links in a clean shell session after running installer commands.
- For Neovim config changes, open Neovim and confirm plugins/options load without errors.

## Commit & Pull Request Guidelines
Recent history follows short, imperative commit subjects (examples: `Update README.md`, `Add nvim install script`).
- Commit format: `Add|Update|Fix|Delete <target>`.
- Keep one logical change per commit.
- PRs should include: purpose, changed paths, manual verification steps, and screenshots for UI-visible terminal/editor changes.

## Security & Configuration Tips
- Do not commit machine-specific secrets, tokens, or private hostnames.
- Review setup scripts before running with `sudo` (especially `setup/docker.sh`).
