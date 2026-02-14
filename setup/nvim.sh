#!/bin/zsh

NVIM_VERSION="0.11.6"

# Require root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  echo "Please run: sudo $0 $@"
  exit 1
fi

cd /tmp

wget https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-x86_64.tar.gz
tar xzvf nvim-linux-x86_64.tar.gz
mv nvim-linux-x86_64 /opt/
ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

if command -v nvim >/dev/null 2>&1; then
  echo "Success: nvim installed"
  exit 0
else
  echo "Error: nvim not installed" >&2
  exit 1
fi
