#!/bin/sh

echo $VARIANT
echo $MODE
echo $TYPE
echo $SCRIPTS_DIR

VARIANT_ROOT_DIR="$CONF_FILES_DIR/$VARIANT/root"
VARIANT_CONFIGS_DIR="$CONF_FILES_DIR/$VARIANT/configs"
VARIANT_SCRIPTS_DIR="$SCRIPTS_DIR/live/$VARIANT"

source $SCRIPTS_DIR/live/time-lang.sh
source $SCRIPTS_DIR/live/add-user.sh
source $SCRIPTS_DIR/live/temp-doas.sh
source $VARIANT_SCRIPTS_DIR/install-packages.sh
source $SCRIPTS_DIR/live/install-dotfiles.sh
source $SCRIPTS_DIR/live/copy-configs.sh
source $SCRIPTS_DIR/live/set-passwords.sh
source $SCRIPTS_DIR/live/configure-packages.sh
source $SCRIPTS_DIR/live/cleanup.sh
source $VARIANT_SCRIPTS_DIR/cleanup.sh
source $SCRIPTS_DIR/live/configure-fstab.sh
source $SCRIPTS_DIR/live/install-grub.sh

command -v 'neofetch' && neofetch

if [ $PAUSE_AFTER_DONE -eq 1 ]; then
    confirm "" "ignore"
fi
