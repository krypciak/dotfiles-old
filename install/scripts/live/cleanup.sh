#!/bin/bash

info 'Cleaning up'
mkdir -p /mnt/pen /mnt/hdd /mnt/ssd /mnt/share /mnt/redpen /mnt/blackpen

rm -rf /dotfiles &

echo 0 > $USER_HOME/.cache/update
chown -R $USER1:$USER_GROUP $USER_HOME &

chmod 0040 /etc/doas.conf

wait $(jobs -p)
