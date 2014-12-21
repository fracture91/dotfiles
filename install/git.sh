#!/bin/sh

ln -s `pwd`/gitconfig ~/.gitconfig
ln -s `pwd`/git-completion.sh ~/.git-completion.sh
ln -s `pwd`/git-prompt.sh ~/.git-prompt.sh

if [ `which apt-get` ]; then
  sudo apt-get install git git-gui
fi

# see https://github.com/github/hub/releases for installing hub
# I was on 2.2.0-preview1 as of this writing
# installation process is slightly too sketchy to automate

