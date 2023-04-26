#!/bin/bash

info 'Cleaning up'
mkdir -p /mnt/pen /mnt/hdd /mnt/ssd /mnt/share /mnt/redpen /mnt/blackpen

rm -rf /dotfiles &

mkdir -p $USER_HOME/.cache
echo 0 > $USER_HOME/.cache/update
chown -R $USER1:$USER_GROUP $USER_HOME &

cp $COMMON_ROOT_DIR/etc/doas.conf /etc/doas.conf
chmod 0040 /etc/doas.conf


wait $(jobs -p)

