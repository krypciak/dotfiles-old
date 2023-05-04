#!/bin/bash

set -a

LGREEN='\033[1;32m'
GREEN='\033[0;32m'
LBLUE='\033[1;34m'
RED='\033[0;31m'
NC='\033[0m' 

SCRIPTS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd | xargs realpath )

INSTALL_DOT_DIR="$(dirname $SCRIPTS_DIR)"
PACKAGES_DIR="$INSTALL_DOT_DIR/packages"
CONF_FILES_DIR="$INSTALL_DOT_DIR/config-files"
COMMON_ROOT_DIR="$CONF_FILES_DIR/common-root"
COMMON_CONFIGS_DIR="$CONF_FILES_DIR/common-configs"


DOTFILES_DIR="$(dirname $INSTALL_DOT_DIR)"


info() {
    echo -e "$GREEN ||| $LGREEN$1$NC"
}

err() {
    echo -e "$RED ||| $RED$1$NC"
}


confirm() {
    echo -en "$LBLUE |||$LGREEN $1 $LBLUE(Y/n/shell)? >> $NC"
    if [ "$YOLO" -eq 1 ] && [ "$2" != "ignore" ]; then echo "y"; return 0; fi 
    read choice
    case "$choice" in 
    y|Y|"" ) return 0;;
    n|N ) echo -e "$RED Exiting..."; exit 1;;
    shell ) info "Entering shell..."; bash; info "Exiting shell..."; confirm "$1" "ignore"; return 0;;
    * ) confirm "$1" "ignore"; return 0;;
    esac
}

GIT_DISCOVERY_ACROSS_FILESYSTEM=1
