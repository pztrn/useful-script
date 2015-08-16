#!/bin/bash

# Script Path.
SCRIPT_PATH=$(dirname "`readlink -f "${BASH_SOURCE}"`")
date > /data/TEMP/1.launch
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
        echo "[`date`] XRandR not found! Install it with your package manager!" >> ${LOGFILE}
        exit 1
    fi
}

function check_log()
{
    if [ -f ${LOGFILE} ]; then
        rm ${LOGFILE}
    fi
    
    touch ${LOGFILE}
}

function check_monitor_presence()
{
    xrandr --current | grep "${dspl}" &>/dev/null
    if [ $? -ne 0 ]; then
        echo "Monitor '${dspl}' not connected" >> ${LOGFILE}
        exit 1
    fi
}

function get_monitor_information()
{
    if [ -z ${RESOLUTION_TO_SET} ]; then
        RESOLUTION_TO_SET=`${xrandr} --current | grep ${MONITOR_TO_USE} -A1 | tail -n 1 | awk {' print $1 '}`
    fi
}

function get_X_display()
{
    if [ ! -z ${DISPLAY} ]; then
        dspl=${DISPLAY}
    else
        echo "[`date`] Running X session wasn't found. This script is useful only if X session is running." >> ${LOGFILE}
        exit 2
    fi
}

function set_monitor_state()
{
    echo "[`date`] Will use resolution '${RESOLUTION_TO_SET}' for monitor '${MONITOR_TO_USE}' on X display '${dspl}'. Monitor '${LED}' will be disabled." >> ${LOGFILE}
    echo "[`date`]Setting resolution for '${MONITOR_TO_USE}'..." >> ${LOGFILE}
    ${xrandr} -d ${dspl} --output ${MONITOR_TO_USE} --mode ${RESOLUTION_TO_SET}
    echo "[`date`]Disabling output '${LED}'..." >> ${LOGFILE}
    ${xrandr} -d ${dspl} --output ${LED} --off
    echo "[`date`]Configuration complete" >> ${LOGFILE}
}

check_dependencies
check_log
get_X_display
check_monitor_presence
get_monitor_information
set_monitor_state
