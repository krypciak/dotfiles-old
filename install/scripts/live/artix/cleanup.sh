#!/bin/bash

if [ -f /90-mkinitcpio-install.hook ]; then
    info "Enabling mkinitpckio"
    mv /90-mkinitcpio-install.hook /usr/share/libalpm/hooks/90-mkinitcpio-install.hook
fi

# If there is internet access
if command -v ntpd > /dev/null && ping -c 1 gnu.org > /dev/null 2>&1; then
    set +e
    info "Removing pacman orphans"
    paru -Sy > $OUTPUT 2>&1
    paru --noconfirm -Rs $(paru -Qqtd) > $OUTPUT 2>&1
    info "Cleaning pacman cache"
    paru --noconfirm -Sc > /dev/null 2>&1
    set -e
fi


