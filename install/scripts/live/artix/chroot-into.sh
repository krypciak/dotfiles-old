#!/bin/bash

confirm "Chroot into ${INSTALL_DIR}?"
artix-chroot $INSTALL_DIR sh -c "export $(env); $USER_HOME/home/.config/dotfiles/install/scripts/live/live.sh"
