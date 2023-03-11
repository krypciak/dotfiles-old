#!/bin/bash

export ARTIXD_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/..
export DOTFILES_DIR=$ARTIXD_DIR/..
export CONFIGD_DIR=$DOTFILES_DIR/config-files

# Packages
LIB32=1
PACMAN_ARGUMENTS='--needed'
PARU_ARGUMENTS=''


KERNEL='linux-zen'
PACKAGE_GROUPS=(
    'drivers'
    'basic'
    'gui'
    'audio'
    'media'
    'browsers'
    'X11'
    'awesome'
    'wayland'
    'dwl'
    'coding'
    'fstools'
    'gaming'
    'security'
    'social'
    'misc'
    'bluetooth'
    'virt'
    'android'
    'plasma'
)

INSTALL_CRON=1

# If ALL_DRIVERS is set to 1, GPU and CPU options are ignored
ALL_DRIVERS=0
# Options: [ 'amd', 'ati', 'intel', 'nvidia' ]
# The nvidia driver is the open source one
#GPU='amd'
GPU='amd'
# Options: [ 'amd', 'intel' ]
#CPU='amd'
CPU='amd'

USER1="krypek"
USER_HOME="/home/$USER1"
FAKE_USER_HOME="$USER_HOME/home"
ESCAPED_USER_HOME=$(printf '%s\n' "$USER_HOME" | sed -e 's/[\/&]/\\&/g')

PORTABLE=0
ISO=0


LGREEN='\033[1;32m'
GREEN='\033[0;32m'
LBLUE='\033[1;34m'
RED='\033[0;31m'
NC='\033[0m' 

if [ "$YOLO" == '' ]; then
    export YOLO=0
fi

function pri() {
    echo -e "$GREEN ||| $LGREEN$1$NC"
}


function confirm() {
    echo -en "$LBLUE |||$LGREEN $1 $LBLUE(y/N/shell)? >> $NC"
    if [ "$YOLO" -eq 1 ] && [ "$2" != "ignore" ]; then echo "y"; return 0; fi 
    read choice
    case "$choice" in 
    y|Y ) return 0;;
    n|N|"" ) echo -e "$RED Exiting..."; exit;;
    shell ) pri "Entering shell..."; bash; pri "Exiting shell..."; confirm "$1" "ignore"; return 0;;
    * ) confirm "$1" "ignore"; return 0;;
    esac
}


if ! command -v "doas"; then
    pri "doas is missing. Please configure it or change the script to use sudo."
    exit 1
fi

pri "Installing paru (AUR manager)"
if [ -d /tmp/paru ]; then rm -rf /tmp/paru; fi
# If paru is already installed, skip this step
if ! command -v "paru"; then
    pacman $PACMAN_ARGUMENTS --noconfirm -S git
    git clone https://aur.archlinux.org/paru-bin.git /tmp/paru
    chown -R $USER1:$USER_GROUP /tmp/paru
    chmod +wrx /tmp/paru
    cd /tmp/paru
    doas -u $USER1 makepkg -si --noconfirm --needed
fi


PACKAGE_LIST=''
for group in "${PACKAGE_GROUPS[@]}"; do
    source $ARTIXD_DIR/packages/install-${group}.sh
    pri "Installing $group"
    PACKAGE_LIST="$PACKAGE_LIST $(install_${group}) "
done

doas -u $USER1 paru $PARU_ARGUMENTS $PACMAN_ARGUMENTS -S $PACKAGE_LIST

confirm "Configure? ${RED}(MAY OVERRIDE EXISTING CONFIG FILES)"
for group in "${PACKAGE_GROUPS[@]}"; do
    CONFIG_FUNC="configure_$group"
    if command -v "$CONFIG_FUNC" &> /dev/null; then
        pri "Configuring $group"
        eval "$CONFIG_FUNC"
    fi
done

