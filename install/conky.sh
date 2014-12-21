#!/bin/sh

ln -s `pwd`/conkyrc ~/.conkyrc


if [ `which apt-get` ]; then
  sudo apt-get install conky lm-sensors hddtemp
fi

# TODO: install autostart stuff into ~/.config/autostart

