# dotfiles

個人用 dotfiles です。
`tmux` / `vim` / `zsh` / `nvim` などの設定を管理しています。

## セットアップ（推奨）

OSに応じて必要パッケージを入れたうえで、シンボリックリンクを作成します。

```bash
cd "$HOME"
git clone git@github.com:ryo415/dotfiles.git
cd dotfiles
./setup.sh
```

## シンボリックリンクのみ作成する場合

```bash
cd "$HOME/dotfiles"
./dotfile_installer.sh link
```

既存リンクを張り直す場合:

```bash
cd "$HOME/dotfiles"
./dotfile_installer.sh update
```

## 補助スクリプト

`setup/` 配下に以下の補助スクリプトがあります。

- `zsh.sh`: zplug の導入
- `starship.sh`: Starship の導入と設定リンク
- `powerline.sh`: Powerline / fonts の導入
- `nerd-fonts.sh`: Nerd Fonts の導入
- `docker.sh`: Debian系向け Docker 導入

詳細は `setup/README.md`（英語）または `setup/README_ja.md`（日本語）を参照してください。
