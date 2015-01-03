#!/bin/sh

# https://justgetflux.com/linux.html

if [ `which apt-get` ]; then
  sudo add-apt-repository ppa:kilian/f.lux
  sudo apt-get update
  sudo apt-get install fluxgui
fi

