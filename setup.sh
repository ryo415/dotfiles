#!/bin/bash

package='tmux vim zsh'

if [ "$(uname)" == 'Darwin' ]; then
  brew install $package
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  if [ -e /etc/debian_version ] || [ -e /etc/debian_release ]; then
    apt update;
    apt install -y $package;
  elif [ -e /etc/redhat-release ]; then
    yum install -y $package;
  fi
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

echo "package install complete"
