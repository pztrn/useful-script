# i3 Monitor detection script

This script is designed to be used with i3, but can be installed and run
on any distribution with XRandR available.

# Configuration

Rename `i3_detect_monitor.config.sh.example` to `i3_detect_monitor.config.sh`
and set values approriately.

# Auto-launch in i3

Use this example:

    exec --no-startup-id i3-msg 'exec /bin/bash /data/sources/useful_scripts/i3_detect_monitor/i3_detect_monitor.sh'

