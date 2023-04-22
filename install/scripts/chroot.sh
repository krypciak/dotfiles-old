#!/bin/sh

mkdir -p $INSTALL_DIR
source $SCRIPTS_DIR/live/$VARIANT/strap-packages.sh

_USER_CONFIG_DIR="$INSTALL_DIR$FAKE_USER_HOME/.config"
mkdir -p $_USER_CONFIG_DIR
info "Copying the repo to $_USER_CONFIG_DIR/dotfiles"
cp -rf $DOTFILES_DIR/ $_USER_CONFIG_DIR/

source $SCRIPTS_DIR/live/$VARIANT/chroot-into.sh

