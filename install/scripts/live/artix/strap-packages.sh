#!/bin/sh

confirm "Install basic packages to ${INSTALL_DIR}?"
source "$PACKAGES_DIR/base.sh"

mkdir -p "$INSTALL_DIR/etc"
mkdir -p "$INSTALL_DIR/tmp"

if [ "$NET" = 'offline' ]; then
    cp "$COMMON_CONFIGS_DIR/pacman.conf.offlinestrap" "/tmp/pacman.conf"
    REPOS="\n[offline]\nSigLevel = PackageRequired\nServer = file://$PACKAGES_DIR/offline/$VARIANT/packages\n"

    sed -i -e "s|LocalFileSigLevel = TrustAll|LocalFileSigLevel = TrustAll\n$REPOS|g" "/tmp/pacman.conf"
    sed -i -e "s|#CacheDir    = /var/cache/pacman/pkg/|CacheDir    = /packages/|g" "/tmp/pacman.conf"

    cp -r "$VARIANT_ROOT_DIR/etc/pacman.d" "$INSTALL_DIR/etc/"
    mkdir -p "$INSTALL_DIR/var/lib/pacman/"

    pacman --color=always --needed --noconfirm --root "$INSTALL_DIR" --config /tmp/pacman.conf -Sy $(${VARIANT}_base_install) 2> /dev/stdout | grep -v 'skipping' > $OUTPUT 2>&1 
else
    basestrap -c -C "$COMMON_CONFIGS_DIR/pacman.conf.install" "$INSTALL_DIR" $(${VARIANT}_base_install) 2> /dev/stdout | grep -v 'skipping' > $OUTPUT 2>&1
fi
