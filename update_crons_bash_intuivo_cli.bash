echo # root
sudo crontab -l
sudo crontab -e
# We need to place the $HOME value not the $HOME variable since roots $HOME is /root, but cron has not $HOME env var
# Mac
on Mac you need to turn on the cron service manually since it comes disabled by default

# Mac
# at every hour *h:10m:30s on Mon to Fri https://corntab.com/?c=10,30_*_*_*_1-5
10,30 * * * 1-5  $(/Users/username/_/clis/bash_intuivo_cli/update_bash_intuivo_cli.bash) > /dev/null 2>&1 || true
10,30 * * * 1-5  $(sleep 30 ; /Users/username/_/clis/bash_intuivo_cli/update_bash_intuivo_cli.bash) > /dev/null 2>&1 || true

# at 10h:10m:30s on Mon to Fri  https://corntab.com/?c=10,30_10_*_*_1-5
10,30 10 * * 1-5 /Users/username/_/clis/bash_intuivo_cli/update_restart_bash_intuivo_cli.bash
# everyday every minute
* * * * * /Users/username/_/clis/bash_intuivo_cli/update_restart_bash_intuivo_cli.bash
# Avoid emails to mail localhost
* * * * * $() > /dev/null 2>&1 || true
* * * * * $(/Users/username/_/clis/bash_intuivo_cli/update_restart_bash_intuivo_cli.bash) > /dev/null 2>&1 || true
# Linux
# Avoid emails to mail localhost
* * * * * $() > /dev/null 2>&1 || true
* * * * * /home/username/_/clis/bash_intuivo_cli/update_restart_bash_intuivo_cli.bash

echo # user $USER who can do pull
crontab -l
crontab -e
# Mac
# cron has not $HOME env var
* * * * * "${HOME}/_/clis/bash_intuivo_cli/update_bash_intuivo_cli.bash"
# Avoid emails to mail localhost
* * * * * $() > /dev/null 2>&1 || true
* * * * * $("${HOME}/_/clis/bash_intuivo_cli/update_bash_intuivo_cli.bash") > /dev/null 2>&1 || true
# trick to get 3 seconds offset
* * * * * ( sleep 30 ; "${HOME}/_/clis/bash_intuivo_cli/update_bash_intuivo_cli.bash" )
# Avoid emails to mail localhost
* * * * * $() > /dev/null 2>&1 || true
* * * * * $(sleep 30 ; "${HOME}/_/clis/bash_intuivo_cli/update_bash_intuivo_cli.bash") > /dev/null 2>&1 || true

# Linux
# cron has not $HOME env var
* * * * * "${HOME}/_/clis/bash_intuivo_cli/update_bash_intuivo_cli.bash"
# Avoid emails to mail localhost
* * * * * $() > /dev/null 2>&1 || true
* * * * * $("${HOME}/_/clis/bash_intuivo_cli/update_bash_intuivo_cli.bash") > /dev/null 2>&1 || true
# trick to get 3 seconds offset
* * * * * ( sleep 30 ; "${HOME}/_/clis/bash_intuivo_cli/update_bash_intuivo_cli.bash" )
# Avoid emails to mail localhost
* * * * * $() > /dev/null 2>&1 || true
* * * * * $( sleep 30 ; "${HOME}/_/clis/bash_intuivo_cli/update_bash_intuivo_cli.bash") > /dev/null 2>&1 || true