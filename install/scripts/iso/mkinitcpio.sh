#!/bin/sh

set +e
mkinitcpio -P -R > /dev/null 2>&1
set -e

info "Generating initramfs"
mkinitcpio -g /boot/initramfs-x86_64.img > $OUTPUT 2>&1

[ -f /boot/vmlinuz-$KERNEL ] && mv /boot/vmlinuz-$KERNEL /boot/vmlinuz-x86_64

printf ''
