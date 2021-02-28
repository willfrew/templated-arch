#!/bin/env bash

DEPS=(
  'WF_AC_CHARGING_FILE'
  'WF_BATTERY_NAME'
  'WF_AUTO_SUSPEND_BATTERY_PERCENTAGE'
  'WF_LOW_BATTERY_NOTIFICATION_PERCENTAGE'
)
for dep in "${DEPS[@]}"; do
  if [[ -z "${!dep}" ]]; then
    echo Variable $dep not set, exiting...;
    exit 1;
  fi
done

if [[ $(cat /sys/class/power_supply/$WF_AC_CHARGING_FILE) -ne "1" ]]; then
  ## If battery is really low, just go ahead and suspend straight await.
  if [[ $(cat /sys/class/power_supply/$WF_BATTERY_NAME/capacity) -lt $WF_AUTO_SUSPEND_BATTERY_PERCENTAGE ]]; then
    systemctl suspend;
  fi

  ## Send a notification when battery percentage hits a low-ish level.
  if [[ $(cat /sys/class/power_supply/$WF_BATTERY_NAME/capacity) -eq $WF_LOW_BATTERY_NOTIFICATION_PERCENTAGE ]]; then
    notify-send --urgency 'critical' "Low Battery $WF_LOW_BATTERY_NOTIFICATION_PERCENTAGE%"
  fi
else
  ## Send a notification when battery hits 99% as a friendly reminder to unplug the charger.
  if [[ $(cat /sys/class/power_supply/$WF_BATTERY_NAME/capacity) -gt 99 ]]; then
    notify-send --urgency 'critical' --hint 'string:frcolor:#859900' "Battery Fully Charged" "Unplug from power"
  fi
fi
