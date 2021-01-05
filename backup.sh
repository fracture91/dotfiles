#!/bin/sh
(rsync -rltnDu --modify-window=1 --progress --delete ~/.dotfiles/ /media/ahurle/Xil/backups/.dotfiles 2>&1) | tee backup-output.txt

