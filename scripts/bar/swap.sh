#!/bin/sh
free -h | awk '/^Swap/ {print $3}' | sed 's/i//g'

