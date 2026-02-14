# セットアップスクリプト

このディレクトリには、シェル環境・フォント・Docker 関連のセットアップを行う補助スクリプトが含まれています。

## スクリプト一覧

### `zsh.sh`
- 目的: Zsh 用の `zplug` をインストールする
- 実行内容:
  - 公式インストーラスクリプトをダウンロードして `zsh` で実行
- 必要なコマンド:
  - `curl`
  - `zsh`
- 実行例:
```bash
./zsh.sh
```

### `starship.sh`
- 目的: Starship プロンプトをインストールし、設定ファイルをリンクする
- 実行内容:
  - Starship のインストールスクリプトを実行
  - `~/.config` がなければ作成
  - `$HOME/dotfiles/.config/starship.toml` を `~/.config/starship.toml` にシンボリックリンク
- 必要なコマンド:
  - `curl`
  - `bash`
- 実行例:
```bash
./starship.sh
```
- 注意:
  - `~/.config/starship.toml` が既に存在する場合、`ln -s` が失敗する可能性があります。

### `powerline.sh`
- 目的: Powerline 本体と Powerline fonts をインストールする
- 実行内容:
  - `powerline` を clone して `python3 setup.py install` を実行後、リポジトリを削除
  - `powerline/fonts` を clone して `./install.sh` を実行後、リポジトリを削除
- 必要なコマンド:
  - `git`
  - `python3`
- 実行例:
```bash
./powerline.sh
```

### `nerd-fonts.sh`
- 目的: Nerd Fonts をインストールする（全件または単体）
- 使い方:
```bash
./nerd-fonts.sh all
./nerd-fonts.sh <FontName>
```
- 実行内容:
  - `all` の場合:
    - `ryanoasis/nerd-fonts` を `$HOME/dotfiles/opt/nerd-fonts` に clone（未 clone の場合のみ）
    - clone 済みリポジトリで `./install.sh` を実行
  - `<FontName>` の場合:
    - `https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/<FontName>.zip` のみをダウンロード
    - 以下に展開:
      - macOS: `~/Library/Fonts`
      - Linux: `~/.local/share/fonts`
    - `fc-cache` がある場合は `fc-cache -fv` を実行
- 必要なコマンド:
  - `git`
  - `curl`
  - `unzip`
- 注意:
  - `<FontName>` は Nerd Fonts のリリースアセット名（`.zip` を除いた名前）と一致させる必要があります。

### `docker.sh`
- 目的: Docker 公式の Debian リポジトリから Docker Engine 関連パッケージをインストールする
- 実行内容:
  - Docker の apt キーとリポジトリを追加
  - `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, `docker-compose-plugin` をインストール
- 必要な環境:
  - `apt` が使える Debian 系 Linux
  - root ユーザー
- 実行例:
```bash
sudo ./docker.sh
```
- 注意:
  - スクリプト内部で `whoami` を確認しており、`root` 以外では終了します。
  - Debian 系 Linux 向けのスクリプトです。
