#!/bin/sh

. $VARIANT_SCRIPTS_DIR/init-keyring.sh
. $VARIANT_SCRIPTS_DIR/install-paru.sh

confirm "Install packages?"
PACKAGE_LIST=''
GROUP_LIST=''
for group in "${PACKAGE_GROUPS[@]}"; do
    . $PACKAGES_DIR/${group}.sh
    INSTALL_FUNC="${VARIANT}_${group}_install"
    if command -v "$INSTALL_FUNC" > /dev/null 2>&1; then
        GROUP_LIST="$GROUP_LIST $group"
        PACKAGE_LIST="$PACKAGE_LIST $($INSTALL_FUNC) "
    fi
done

# hack to get doas-sudo-shim installed
rm -f /usr/bin/sudo

info "Installing groups:${LBLUE}$GROUP_LIST"

if [ "$NET" = 'offline' ]; then
    cd "$USER_HOME/home/.config/dotfiles/install/packages/offline/$VARIANT/packages" || exit
    pacman --noconfirm --needed -U $(ls *.pkg.tar.zst -1 | grep -E -e $(echo $PACKAGE_LIST | tr ' ' '\n' | awk '{print "-e ^" $1 "-"}' | xargs)) 2> /dev/stdout | grep -v 'skipping' > $OUTPUT 2>&1
else
    n=0
    until [ "$n" -ge 5 ]; do
        doas -u $USER1 paru $PARU_ARGUMENTS $PACMAN_ARGUMENTS -S $PACKAGE_LIST 2> /dev/stdout | grep -v 'skipping' > $OUTPUT 2>&1 && break
        n=$((n+1))
        err "Package installation failed. Attempt $n/5"
        sleep 3
    done
    if [ "$n" -eq 5 ]; then err "Package installation failed."; sh; exit; fi
fi
