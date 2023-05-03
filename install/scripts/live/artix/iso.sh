#!/bin/sh

if [ "$NET" = 'offline' ]; then
    PACKAGES="$KERNEL"
    PP="$PACKAGES_DIR/offline/$VARIANT/packages"
    for pack in $PACKAGES; do
        pacman --noconfirm -U $PP/$pack-*.pkg.tar.zst > /dev/null 2>&1
    done
    # artix-grub-live artix-grub-theme
fi
#pacman --noconfirm -S mkinitcpio-nfs-utils squashfs-tools artix-live-openrc iso-initcpio 

if [ ! -f /boot/amd-ucode.img ] || [ ! -f /boot/intel-ucode.img ]; then
    pacman --noconfirm -S amd-ucode intel-ucode > $OUTPUT 2>&1
fi


