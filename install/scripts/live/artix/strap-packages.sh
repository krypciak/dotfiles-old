#!/bin/bash

confirm "Install basic packages to ${INSTALL_DIR}?"
source $PACKAGES_DIR/base.sh
basestrap -C $COMMON_CONFIGS_DIR/pacman.conf.install $INSTALL_DIR $(${VARIANT}_base_install)
