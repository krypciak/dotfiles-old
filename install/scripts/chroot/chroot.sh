#!/bin/sh
set -e

INSTALL_DIR="$1"
shift
MOUNT_ACTION="$1"
shift
UMOUNT_ACTION="$1"
shift
PRE_CHROOT_ACTION="$1"
shift

#printf "install dir:\n$INSTALL_DIR\n"
#printf "mount action:\n$MOUNT_ACTION\n"
#printf "umount action:\n$UMOUNT_ACTION\n"
#printf "prechroot action:\n$PRE_CHROOT_ACTION\n"
#printf "to run:\n%s\n" "$@"

_mount() {
    mkdir -p "$INSTALL_DIR"
    cd "$INSTALL_DIR"
    mkdir -p proc sys dev/pts dev/shm run tmp sys/firmware/efi/efivars etc
    if ! mountpoint -q "$INSTALL_DIR"; then
        mount "$INSTALL_DIR" "$INSTALL_DIR" --bind
    fi
    mount proc "$INSTALL_DIR/proc" -t proc -o nosuid,noexec,nodev
    mount sys "$INSTALL_DIR/sys" -t sysfs -o nosuid,noexec,nodev,ro
    mount udev "$INSTALL_DIR/dev" -t devtmpfs -o mode=0755,nosuid
    mount devpts "$INSTALL_DIR/dev/pts" -t devpts -o mode=0620,gid=5,nosuid,noexec
    mount shm "$INSTALL_DIR/dev/shm" -t tmpfs -o mode=1777,nosuid,nodev
    mount /run "$INSTALL_DIR/run" -t tmpfs -o nosuid,nodev,mode=0755
    mount tmp "$INSTALL_DIR/tmp" -t tmpfs -o mode=1777,strictatime,nodev,nosuid
    
    mount --bind /sys/firmware/efi/efivars "$INSTALL_DIR/sys/firmware/efi/efivars/"
    cp /etc/resolv.conf $INSTALL_DIR/etc/resolv.conf
    
    eval "$MOUNT_ACTION"
}

_umount() {
    MOUNT_LIST="proc sys dev run tmp"
    set +e
    for m in $MOUNT_LIST; do
        umount -l -R "$INSTALL_DIR/$m"
        EXIT_CODE=$?
        if [ "$EXIT_CODE" -eq 32 ]; then
            exit 1
        fi
    done
    umount -R "$INSTALL_DIR"
    
    eval "$UMOUNT_ACTION"
    set -e
}

trap '_umount > /dev/null 2>&1' EXIT TERM QUIT
    eval "$MOUNT_ACTION"


_umount > /dev/null 2>&1
_mount

eval "$PRE_CHROOT_ACTION"

unshare --fork --pid chroot "$INSTALL_DIR" "$@"
_umount > /dev/null 2>&1

