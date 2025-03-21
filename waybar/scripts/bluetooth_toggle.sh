#!/bin/bash

STATUS=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

if [ "$STATUS" = "yes" ]; then
    rfkill block bluetooth
    # notify-send "Bluetooth выключен"
else
    rfkill unblock bluetooth
    # notify-send "Bluetooth включен"
fi
