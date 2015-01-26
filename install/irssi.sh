#!/bin/sh

if [ `which apt-get` ]; then
  sudo apt-get install irssi
fi

ln -s `pwd`/irssi/irssi.png ~/.local/share/icons/irssi.png
ln -s `pwd`/irssi/irssi.desktop ~/.local/share/applications/irssi.desktop
ln -s `pwd`/irssi ~/.irssi

# you might choose to replace this symlink with a script like `~/.irssi/remote Aiur.local`
ln -s `pwd`/irssi/screen ./irssi/run-desktop

