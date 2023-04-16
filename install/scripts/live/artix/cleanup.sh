#!/bin/bash

info "Enabling mkinitpckio"
mv /90-mkinitcpio-install.hook /usr/share/libalpm/hooks/90-mkinitcpio-install.hook

info "Removing pacman orphans"
paru --noconfirm -Rs $(paru -Qqtd) > $OUTPUT
info "Cleaning pacman cache"
paru --noconfirm -Sc > /dev/null > $OUTPUT


