#!/bin/sh

set -a

info 'Cleaning up'
mkdir -p /mnt/pen /mnt/hdd /mnt/ssd /mnt/share /mnt/redpen /mnt/blackpen

rm -rf /dotfiles &

mkdir -p $USER_HOME/.cache
echo 0 > $USER_HOME/.cache/update
chown -R $USER1:$USER_GROUP $USER_HOME &

cp $COMMON_ROOT_DIR/etc/doas.conf /etc/doas.conf
chmod 0040 /etc/doas.conf

cleanup() {
    [ -d "$1" ] && find "$1" -type f -delete > /dev/null 2>&1
}

cleanup /var/log
cleanup /var/tmp
[ "$MODE" != 'live' ] && cleanup /tmp

rm -f /etc/machine-id

. $VARIANT_SCRIPTS_DIR/cleanup.sh

wait $(jobs -p)

