#!/bin/sh

set -e

info "Installing paru (AUR manager)"

if [ -d /tmp/paru ]; then rm -rf /tmp/paru; fi
# If paru is already installed, skip this step
if ! command -v "paru" > /dev/null 2>&1; then
    PARU_FILE="$(ls $PACKAGES_DIR/offline/$VARIANT/packages/paru-bin*.pkg.tar.zst)"
    if [ -f $PARU_FILE ]; then
        pacman $PACMAN_ARGUMENTS -U "$PARU_FILE" > $OUTPUT 2>&1
    else
        pacman $PACMAN_ARGUMENTS -S git doas > $OUTPUT 2>&1
        git clone https://aur.archlinux.org/paru-bin.git /tmp/paru > $OUTPUT 2>&1
        chown -R $USER1:$USER_GROUP /tmp/paru
        chmod -R +wrx /tmp/paru
        cd /tmp/paru || exit
        doas -u $USER1 makepkg -si --noconfirm --needed > $OUTPUT 2>&1
    fi
fi
cp "$VARIANT_ROOT_DIR/etc/paru.conf" /etc/paru.conf
 
if [ -f /usr/share/libalpm/hooks/90-mkinitcpio-install.hook ]; then
    info "Disabling mkinitcpio"
    mv /usr/share/libalpm/hooks/90-mkinitcpio-install.hook /90-mkinitcpio-install.hook 
fi

