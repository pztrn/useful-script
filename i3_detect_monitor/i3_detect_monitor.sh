#!/bin/bash

# Script Path.
SCRIPT_PATH=$(dirname "`readlink -f "${BASH_SOURCE}"`")

# Configuration.
source "${SCRIPT_PATH}/i3_detect_monitor.config.sh"

# Check for dependencies.
function check_dependencies()
{
    xrandr=`whereis xrandr | awk {' print $2 '}`
    # I'm taking arbitrary number of ten for length checking.
    # Actually, in "not found" case it will be 8. I just love
    # number 10.
    if [ ${#xrandr} -lt 10 ]; then
        echo "XRandR not found! Install it with your package manager!"
        exit 1
    fi
}

function get_monitor_information()
{
    resolution=`${xrandr} --current | grep ${MONITOR_TO_USE} -A1 | tail -n 1 | awk {' print $1 '}`
}

function get_X_display()
{
    if [ ! -z ${DISPLAY} ]; then
        dspl=${DISPLAY}
    else
        echo "Running X session wasn't found. This script is useful only if X session is running."
        exit 2
    fi
}

function set_monitor_state()
{
    echo "Will use resolution '${resolution}' for monitor '${MONITOR_TO_USE}' on X display '${dspl}'. Monitor '${LED}' will be disabled."
    echo "Setting resolution for '${MONITOR_TO_USE}'..."
    ${xrandr} -d ${dspl} --output ${MONITOR_TO_USE} --mode ${resolution}
    echo "Disabling output '${LED}'..."
    ${xrandr} -d ${dspl} --output ${LED} --off
    echo "Configuration complete"
}

check_dependencies
get_monitor_information
get_X_display
set_monitor_state
