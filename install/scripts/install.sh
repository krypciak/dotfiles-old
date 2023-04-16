#!/bin/bash
set -a

SCRIPTS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$SCRIPTS_DIR/common.sh"


_help() {
    echo 'Usage:'
    echo 'sh install.sh MODE VARIANT TYPE NET'
    echo 'MODE - disk, live'
    echo 'VARIANT - artix, arch'
    echo 'TYPE - normal, iso'
    echo 'NET - online, offline'
    exit 2
}

if [ ! -f $SCRIPTS_DIR/vars.conf.sh ]; then
    err "Config file vars.conf.sh doesn't exist."
    exit 3
fi

if [ "$(whoami)" != 'root' ]; then
    err "This script needs to be run as root."
    exit 1
fi

MODE=$1
if [ "$MODE" != 'live' ] && [ "$MODE" != 'disk' ]; then
    err 'Invalid first argument.'; _help;
fi

VARIANT=$2
TYPE=$3
if [ "$VARIANT" == 'artix' ]; then
    if [ "$TYPE" == 'normal' ]; then
        VARIANT_NAME="Artix"
    elif [ "$TYPE" == 'iso' ]; then
        VARIANT_NAME="Artix ISO"
    else err 'Invalid third argument.'; _help; fi

elif [ "$VARIANT" == 'arch' ]; then
    if [ "$TYPE" == 'normal' ]; then
        VARIANT_NAME="Arch"
    elif [ "$TYPE" == 'iso' ]; then
        VARIANT_NAME="Arch ISO"
    else err 'Invalid third argument.'; fi
else
    err 'Invalid second argument'; _help
fi

NET=$4
if [ "$NET" != 'offline' ] && [ "$NET" != 'online' ]; then
    err 'Invalid forth argument.'; _help
fi

source "$SCRIPTS_DIR/vars.conf.sh"

if [ "$MODE" == 'live' ]; then
    source "$SCRIPTS_DIR/live/live.sh"

elif [ "$MODE" == 'disk' ]; then
    source "$SCRIPTS_DIR/disk.sh"
fi

#sed -i 's/#Color/Color/g' /etc/pacman.conf
#sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf

#chmod 0040 /etc/doas.conf
#
#pri "Enabling mkinitpckio"
#mv /90-mkinitcpio-install.hook /usr/share/libalpm/hooks/90-mkinitcpio-install.hook


