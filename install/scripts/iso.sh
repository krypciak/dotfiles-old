#!/bin/sh

ISO_OUT_FILE="$(echo "$ISO_OUT_DIR/$VARIANT-iso-$(date -u +%Y-%m-%d).iso" | xargs realpath)"

ISO_WORK_DIR="/mnt/$VARIANT-iso"

ISO_ROOT="$ISO_WORK_DIR/iso"
ISO_LIVEOS="$ISO_ROOT/LiveOS"
#ISO_LIVEFS="$ISO_WORK_DIR/livefs"
ISO_ROOTFS="$ISO_WORK_DIR/rootfs"
INSTALL_DIR="$ISO_ROOTFS"

. $SCRIPTS_DIR/chroot/prepare-chroot.sh

mkdir -p "$ISO_ROOT"/boot
cp "$ISO_ROOTFS"/boot/initramfs-x86_64.img "$ISO_ROOTFS"/boot/*-ucode.img "$ISO_ROOT"/boot/

. "$SCRIPTS_DIR"/iso/grub.sh

info "Generating a SquashFS image"
. "$SCRIPTS_DIR"/iso/squash.sh

info "Building the ISO"
. "$SCRIPTS_DIR"/iso/mkiso.sh

chown $USER1:$USER1 "$ISO_OUT_FILE"
info "Building ISO done."
echo $ISO_OUT_FILE

