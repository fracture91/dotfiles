#!/bin/sh

set -e

# this installs janus: https://github.com/carlhuda/janus

if [ `which apt-get` ]; then
  sudo apt-get install vim vim-gnome
  # required for janus
  sudo apt-get install ack-grep ctags git ruby rake
  # debian is stupid and calls ack "ack-grep"
  sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep
fi

curl -Lo- https://bit.ly/janus-bootstrap | bash

ln -s `pwd`/janus ~/.janus
ln -s ~/.janus/vimrc.after ~/.vimrc.after
ln -s ~/.janus/gvimrc.after ~/.gvimrc.after
