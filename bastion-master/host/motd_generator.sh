#!/bin/sh

UPTIME_DAYS=$(expr `cat /proc/uptime | cut -d '.' -f1` % 31556926 / 86400)
UPTIME_HOURS=$(expr `cat /proc/uptime | cut -d '.' -f1` % 31556926 % 86400 / 3600)
UPTIME_MINUTES=$(expr `cat /proc/uptime | cut -d '.' -f1` % 31556926 % 86400 % 3600 / 60)

environment="${TRIPIT_ENVIRONMENT:-unknown}"

cat > /etc/motd << EOF
 _________  ________  ___  ________  ___  _________    
|\___   ___\\   __  \|\  \|\   __  \|\  \|\___   ___\  
\|___ \  \_\ \  \|\  \ \  \ \  \|\  \ \  \|___ \  \_|  
     \ \  \ \ \   _  _\ \  \ \   ____\ \  \   \ \  \   
      \ \  \ \ \  \\  \\ \  \ \  \___|\ \  \   \ \  \  
       \ \__\ \ \__\\ _\\ \__\ \__\    \ \__\   \ \__\ 
        \|__|  \|__|\|__|\|__|\|__|     \|__|    \|__|


    UNAUTHORIZED ACCESS TO THIS DEVICE IS PROHIBITED
    You must have explicit, authorized permission to access or configure this device.
    Unauthorized attempts and actions to access or use this system may result in civil and/or
    criminal penalties.
    All activities performed on this device are logged and monitored.

    Name: TripIt bastion host
    Environment: $environment
    Uptime: $UPTIME_DAYS days, $UPTIME_HOURS hours, $UPTIME_MINUTES minutes

EOF
