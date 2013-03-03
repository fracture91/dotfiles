#!/bin/sh
# see http://blog.echo-flow.com/2012/08/04/thinkpad-w520-multi-monitor-nvidia-optimus-with-bumblebee-on-ubuntu-12-04/
# https://gist.github.com/jbeard4/3259239

xrandr --output LVDS1 --auto --output VIRTUAL --mode 1920x1080 --left-of LVDS1
optirun screenclone -d :8 -x 1
xrandr --output VIRTUAL --off

