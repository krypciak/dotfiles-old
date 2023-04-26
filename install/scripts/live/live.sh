#!/bin/sh
set -a

source "$SCRIPTS_DIR/common.sh"
source "$SCRIPTS_DIR/vars.conf.sh"

VARIANT_ROOT_DIR="$CONF_FILES_DIR/$VARIANT/root"
VARIANT_CONFIGS_DIR="$CONF_FILES_DIR/$VARIANT/configs"
VARIANT_SCRIPTS_DIR="$SCRIPTS_DIR/live/$VARIANT"

source $SCRIPTS_DIR/live/time-lang.sh
source $SCRIPTS_DIR/live/add-user.sh
source $SCRIPTS_DIR/live/temp-doas.sh
source $VARIANT_SCRIPTS_DIR/install-packages.sh
source $SCRIPTS_DIR/live/copy-configs.sh
source $SCRIPTS_DIR/live/temp-doas.sh
source $SCRIPTS_DIR/live/install-dotfiles.sh
source $SCRIPTS_DIR/live/set-passwords.sh
source $SCRIPTS_DIR/live/configure-packages.sh
source $SCRIPTS_DIR/live/cleanup.sh
source $VARIANT_SCRIPTS_DIR/cleanup.sh

if [ "$TYPE" = 'normal' ]; then
    source $SCRIPTS_DIR/live/configure-fstab.sh
    source $SCRIPTS_DIR/live/install-grub.sh
else
    source "$VARIANT_SCRIPTS_DIR/iso.sh"
fi

command -v 'neofetch' > /dev/null 2>&1 && neofetch

if [ $PAUSE_AFTER_DONE -eq 1 ]; then
    confirm "" "ignore"
fi

