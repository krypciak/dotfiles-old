#!/bin/sh

info "Generating initramfs"
mkinitcpio -P > $OUTPUT 2>&1
