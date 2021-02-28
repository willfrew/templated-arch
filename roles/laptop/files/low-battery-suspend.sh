#!/bin/env bash

DEPS=('WF_AC_CHARGING_FILE' 'WF_BATTERY_NAME' 'WF_AUTO_SUSPEND_BATTERY_PERCENTAGE')
for dep in "${DEPS[@]}"; do
  if [[ -z "${!dep}" ]]; then
    echo Variable $dep not set, exiting...;
    exit 1;
  fi
done


## Auto-suspend when battery is low and not currently charging.
if
  [[ $(cat /sys/class/power_supply/$WF_AC_CHARGING_FILE) -ne "1" ]] &&
  [[ $(cat /sys/class/power_supply/$WF_BATTERY_NAME/capacity) -lt $WF_AUTO_SUSPEND_BATTERY_PERCENTAGE ]]; then
    systemctl suspend;
fi
