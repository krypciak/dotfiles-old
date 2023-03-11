#!/bin/sh
[ "$(pgrep gammastep)" == '' ] && echo '0' || gammastep -p 2> >(grep 'temperature') | awk '{printf $4}'
