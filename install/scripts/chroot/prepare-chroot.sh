#!/bin/bash
set -e


EXCLUDE_FLAG=''

if [ "$COPY_OFFLINE_PACKAGES" = '0' ]; then
    OFFLINE_DIR="$INSTALL_DIR/home/$USER1/home/.config/dotfiles/install/packages/offline"
    EXCLUDE_FLAG='--exclude=install/packages/offline/'
    mkdir -p "$OFFLINE_DIR"
fi

MOUNT_ACTION='true'
UMOUNT_ACTION='true'

if [ "$COPY_OFFLINE_PACKAGES" = '0' ]; then
    MOUNT_ACTION="mount --bind $PACKAGES_DIR/offline $OFFLINE_DIR"
    UMOUNT_ACTION="umount -R $OFFLINE_DIR"
fi

_USER_CONFIG_DIR=\"$INSTALL_DIR$FAKE_USER_HOME/.config\"

PRE_CHROOT_ACTION="
. $SCRIPTS_DIR/live/$VARIANT/strap-packages.sh
confirm \"Chroot into ${INSTALL_DIR}?\"
mkdir -p $_USER_CONFIG_DIR
info \"Copying the repo to $_USER_CONFIG_DIR/dotfiles\"
rsync -a --exclude='install/artix/' $EXCLUDE_FLAG $DOTFILES_DIR $_USER_CONFIG_DIR/
"


if [ "$TYPE" = 'normal' ]; then
    _SCRIPT="$USER_HOME/home/.config/dotfiles/install/scripts/live/live.sh"
elif [ "$TYPE" = 'iso' ]; then
    _SCRIPT="$USER_HOME/home/.config/dotfiles/install/scripts/iso/iso.sh"
fi

SCRIPTS_DIR="$USER_HOME/home/.config/dotfiles/install/scripts"

source "$SCRIPTS_DIR"/chroot/chroot.sh "$INSTALL_DIR" "$MOUNT_ACTION" "$UMOUNT_ACTION" "$PRE_CHROOT_ACTION" /bin/sh -c "export $(env | grep -E '^(CONF_FILES_DIR|SCRIPTS_DIR|MODE|VARIANT|VARIANT_NAME|TYPE|NET)' | xargs); sh $_SCRIPT"

