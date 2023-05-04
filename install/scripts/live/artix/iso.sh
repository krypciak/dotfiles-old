#!/bin/sh

if [ "$NET" = 'offline' ]; then
    info "Reinstalling kernel"
    PACKAGES="$KERNEL"
    PP="$PACKAGES_DIR/offline/$VARIANT/packages"
    for pack in $PACKAGES; do
        pacman --noconfirm -U $PP/$pack-*.pkg.tar.zst > $OUTPUT 2>&1
    done
    # artix-grub-live artix-grub-theme
fi
#pacman --noconfirm -S mkinitcpio-nfs-utils squashfs-tools artix-live-openrc iso-initcpio 

if [ ! -f /boot/amd-ucode.img ] || [ ! -f /boot/intel-ucode.img ]; then
    info "Reinstalling ucode's"
    pacman --noconfirm -S amd-ucode intel-ucode > $OUTPUT 2>&1
fi

cp "$CONF_FILES_DIR"/iso/configs/artix-iso-net /etc/init.d/
chmod +x /etc/init.d/artix-iso-net
rc-update add artix-iso-net default > $OUTPUT 2>&1
