#!/bin/bash

info "Setting time"
ln -sf /usr/share/zoneinfo/$REGION/$CITY /etc/localtime
echo "$REGION/$CITY" > /etc/timezone
ntpd
hwclock --systohc

info "Generating locale"
cp "$COMMON_ROOT/etc/locale.gen" /etc/locale.gen
locale-gen
echo "LANG=\"$LANG\"" > /etc/locale.conf
export LANG
export LC_COLLATE="C"

info "Setting the hostname"
echo "$HOSTNAME" > /etc/hostname
echo "hostname='$HOSTNAME'" > /etc/conf.d/hostname

