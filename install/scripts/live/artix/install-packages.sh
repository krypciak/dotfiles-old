#!/bin/sh

source $VARIANT_SCRIPTS_DIR/init-keyring.sh
source $VARIANT_SCRIPTS_DIR/install-paru.sh

confirm "Install packages?"
PACKAGE_LIST=''
for group in "${PACKAGE_GROUPS[@]}"; do
    source $PACKAGES_DIR/${group}.sh
    info "Installing $group"
    PACKAGE_LIST="$PACKAGE_LIST $(${VARIANT}_${group}_install) "
done

n=0
until [ "$n" -ge 5 ]; do
    doas -u $USER1 paru $PARU_ARGUMENTS $PACMAN_ARGUMENTS -S $PACKAGE_LIST && break
    n=$((n+1))
    err "Package installation failed. Attempt $n/5"
done
if [ "$n" -eq 5 ]; then err "Package installation failed."; exit; fi

