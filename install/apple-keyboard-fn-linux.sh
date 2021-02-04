#!/usr/bin/env bash

# https://askubuntu.com/a/7553
# Make F1-F12 behave normally, hold "fn" key for brightness, etc.

# to temporarily test this until next boot, run this:
# sudo bash -c "echo 2 > /sys/module/hid_apple/parameters/fnmode"

echo options hid_apple fnmode=2 | sudo tee -a /etc/modprobe.d/hid_apple.conf
sudo update-initramfs -u -k all
