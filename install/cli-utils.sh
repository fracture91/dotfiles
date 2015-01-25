#!/bin/sh

if [ `which apt-get` ]; then
  sudo apt-get install curl sshfs htop tmux locate
fi
