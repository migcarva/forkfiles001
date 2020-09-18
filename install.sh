#!/bin/sh

[ "${SHELL##/*/}" != "zsh" ] && echo 'You might need to change default shell to zsh: `chsh -s /bin/zsh`'

dir="$HOME/Code/home"
mkdir -p $dir
cd $dir
git clone --recursive https://github.com/migcarva/forkfiles001.git
cd forkfiles001
sh etc/symlink-dotfiles.sh
