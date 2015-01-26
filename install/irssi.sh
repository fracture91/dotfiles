#!/bin/sh

if [ `which apt-get` ]; then
  sudo apt-get install irssi
fi

ln -s `pwd`/irssi/irssi.png ~/.local/share/icons/irssi.png
ln -s `pwd`/irssi/irssi.desktop ~/.local/share/applications/irssi.desktop

