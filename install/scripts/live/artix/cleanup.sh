#!/bin/bash

pri "Enabling mkinitpckio"
mv /90-mkinitcpio-install.hook /usr/share/libalpm/hooks/90-mkinitcpio-install.hook

paru --noconfirm -Rs $(paru -Qqtd)
paru --noconfirm -Scc > /dev/null 2>&1


