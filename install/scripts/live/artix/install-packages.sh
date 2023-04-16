#!/bin/sh

source $VARIANT_SCRIPTS_DIR/init-keyring.sh
source $VARIANT_SCRIPTS_DIR/install-paru.sh

confirm "Install packages?"
PACKAGE_LIST=''
GROUP_LIST=''
for group in "${PACKAGE_GROUPS[@]}"; do
    source $PACKAGES_DIR/${group}.sh
    INSTALL_FUNC="${VARIANT}_${group}_install"
    if command -v "$INSTALL_FUNC" &> /dev/null; then
        GROUP_LIST="$GROUP_LIST $group"
        PACKAGE_LIST="$PACKAGE_LIST $($INSTALL_FUNC) "
    fi
done

# hack to get doas-sudo-shim installed
rm -f /usr/bin/sudo

info "Installing groups: $GROUP_LIST"

n=0
until [ "$n" -ge 5 ]; do
    doas -u $USER1 paru $PARU_ARGUMENTS $PACMAN_ARGUMENTS -S $PACKAGE_LIST > $OUTPUT 2>&1 && break
    n=$((n+1))
    err "Package installation failed. Attempt $n/5"
    sleep 3
done
if [ "$n" -eq 5 ]; then err "Package installation failed."; exit; fi

