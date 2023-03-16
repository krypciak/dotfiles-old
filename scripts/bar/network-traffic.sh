#!/bin/sh
MODULE='eth0'
TIME='4'
MULTI='1'

function format_KiB() {
    KiB=$((($rx2 - $rx1) / 1024 * $MULTI))
    if [ $KiB -gt 100 ]; then
        echo "scale = 1; $KiB / 1024" | bc | tr -d '\n'; printf 'MiB'
    else
        printf "${KiB}KiB"
    fi
}

if nc -z 8.8.8.8 53 -w 1; then
    printf ''
    rx1=$(cat /sys/class/net/$MODULE/statistics/rx_bytes)
    sleep $TIME
    rx2=$(cat /sys/class/net/$MODULE/statistics/rx_bytes)
    format_KiB
    
    printf ' '
    rx1=$(cat /sys/class/net/$MODULE/statistics/tx_bytes)
    sleep $TIME
    rx2=$(cat /sys/class/net/$MODULE/statistics/tx_bytes)
    format_KiB
else 
    printf '󰈂'
fi
