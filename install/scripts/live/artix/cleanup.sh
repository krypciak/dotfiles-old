#!/bin/bash

if [ -f /90-mkinitcpio-install.hook ]; then
    mv /90-mkinitcpio-install.hook /usr/share/libalpm/hooks/90-mkinitcpio-install.hook
fi

# If there is internet access
if command -v ntpd > /dev/null && ping -c 1 gnu.org > /dev/null 2>&1; then
    set +e
    info "Removing pacman orphans"
    paru -Sy > /dev/null 2>&1
    ORPHANS="$(paru -Qqtd)"
    [ "$ORPHANS" != '' ] && paru --noconfirm -Rs  > /dev/null 2>&1
    info "Cleaning pacman cache"
    paru --noconfirm -Scc > /dev/null 2>&1
    set -e
fi

if [ "$MODE" != 'live' ]; then
    cleanup /tmp 
fi

set +e
find / -name '*.pacnew' -name '*.pacsave' -name '*.pacorig' -delete > /dev/null 2>&1
set -e
