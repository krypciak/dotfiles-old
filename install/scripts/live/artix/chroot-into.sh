#!/bin/bash

confirm "Chroot into ${INSTALL_DIR}?"
artix-chroot $INSTALL_DIR sh -c "export $(env | grep -E '^(CONF_FILES_DIR|SCRIPTS_DIR|MODE|VARIANT|VARIANT_NAME|TYPE)' | xargs); $USER_HOME/home/.config/dotfiles/install/scripts/live/live.sh"
