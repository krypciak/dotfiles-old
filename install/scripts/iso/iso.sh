#!/bin/sh
set -a
set -e

. "$SCRIPTS_DIR/common.sh"

if [ "$MODE" = 'iso' ]; then
    . "$SCRIPTS_DIR/vars.conf.iso.sh"
else
    . "$SCRIPTS_DIR/vars.conf.sh"
fi

VARIANT_ROOT_DIR="$CONF_FILES_DIR/$VARIANT/root"
VARIANT_CONFIGS_DIR="$CONF_FILES_DIR/$VARIANT/configs"
VARIANT_SCRIPTS_DIR="$SCRIPTS_DIR/live/$VARIANT"

. "$SCRIPTS_DIR"/live/time-lang.sh
. "$SCRIPTS_DIR"/live/add-user.sh
. "$SCRIPTS_DIR"/live/temp-doas.sh
. "$VARIANT_SCRIPTS_DIR"/install-packages.sh
. "$SCRIPTS_DIR"/live/copy-configs.sh
. "$SCRIPTS_DIR"/iso/copy-configs.sh
. "$SCRIPTS_DIR"/live/temp-doas.sh
. "$SCRIPTS_DIR"/live/install-dotfiles.sh
. "$SCRIPTS_DIR"/live/set-passwords.sh
. "$SCRIPTS_DIR"/live/configure-packages.sh

[ -f "$VARIANT_SCRIPTS_DIR"/iso.sh ] && . "$VARIANT_SCRIPTS_DIR"/iso.sh

. "$SCRIPTS_DIR"/live/cleanup.sh

cp $CONF_FILES_DIR/iso/root/etc/doas.conf /etc/doas.conf
chmod 0040 /etc/doas.conf



. "$SCRIPTS_DIR"/iso/mkinitcpio.sh


info "neofetch!"
command -v 'neofetch' > /dev/null 2>&1 && neofetch

if [ $PAUSE_AFTER_DONE -eq 1 ]; then
    confirm "" "ignore"
fi
 
