#!/bin/zsh

cd /tmp
git clone https://github.com/powerline/powerline.git
cd powerline
python3 setup.py install
cd ..
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
cd ..
rm -rf fonts
cd ~
