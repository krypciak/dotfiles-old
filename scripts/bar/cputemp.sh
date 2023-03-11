#!/bin/sh
echo "scale = 1; $(cat /sys/class/hwmon/hwmon0/temp1_input) / 1000" | bc | tr -d '\n'; printf '°C'
