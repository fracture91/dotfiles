#!/usr/bin/env bash

# Use `crontab -e` and add a line like the following:
#   MAILTO=somewhere@example.com
#   @reboot $HOME/bin/reboot-mail.sh
#
# This will send an email on boot, assuming you have a working MTA set up.
# If you don't, `sudo apt install postfix` is probably the easiest solution.
# You'll want the "Internet Site" configuration.
#
# Why not simply `echo` and rely on standard crontab mailing?  Because that
# will only provide the output in the email body, not the subject.
#
# Why not inline this in the crontab?  Because it doesn't like pipes and this
# is more foolproof than using `bash -c`.

if [[ -z "$MAILTO" ]]; then
  echo "MAILTO env var is empty, set it in crontab"
  exit 1
fi

echo -e "Subject:$(hostname) rebooted at $(date)\n\n" | /usr/sbin/sendmail $MAILTO

