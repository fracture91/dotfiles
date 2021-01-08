#!/usr/bin/env bash

sudo ln -s `pwd`/ethers /etc/ethers
sudo apt install etherwake

# use thusly: `sudo etherwake tarsonis`
# this will send a wake-on-lan magic packet to tarsonis as specified in /etc/ethers
# note that the hosts themselves need to be configured to accept WoL packets
#   https://help.ubuntu.com/community/WakeOnLan

