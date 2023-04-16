#!/bin/bash

info "Setting time"
ln -sf /usr/share/zoneinfo/$REGION/$CITY /etc/localtime
echo "$REGION/$CITY" > /etc/timezone
if command -v ntpd > /dev/null && ping -c 1 gnu.org > /dev/null 2>&1; then
    ntpd > $OUTPUT
    hwclock --systohc
else
    hwclock --hctosys
fi

info "Generating locale"
cp "$COMMON_ROOT_DIR/etc/locale.gen" /etc/locale.gen
locale-gen > $OUTPUT
echo "LANG=\"$LANG\"" > /etc/locale.conf
export LC_COLLATE="C"

info "Setting the hostname"
echo "$HOSTNAME" > /etc/hostname
echo "hostname='$HOSTNAME'" > /etc/conf.d/hostname

