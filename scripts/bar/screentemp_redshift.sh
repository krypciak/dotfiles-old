#!/bin/sh
[ "$(pgrep redshift)" == '' ] && echo '0' || redshift -p | grep 'temp' | awk '{print $3}'
