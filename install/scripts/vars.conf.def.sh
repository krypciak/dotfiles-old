#!/bin/sh
set -a

PORTABLE=0
KERNEL='linux-zen'


# User configuration
USER1='krypek'
USER_GROUP='krypek'
USER_HOME="/home/$USER1"
FAKE_USER_HOME="$USER_HOME/home"

USER_PASSWORD=123
ROOT_PASSWORD=123

INSTALL_DOTFILES=1
INSTALL_PRIVATE_DOTFILES=1
PRIVATE_DOTFILES_PASSWORD='123'


REGION='Europe'
CITY='Warsaw'
HOSTNAME="$USER1$VARIANT_NAME"
LANG='en_US.UTF-8'


# Packages
LIB32=1
PACMAN_ARGUMENTS='--color=always --noconfirm --needed'
PARU_ARGUMENTS='--noremovemake --skipreview --noupgrademenu'

# If ALL_DRIVERS is set to 1, GPU and CPU options are ignored
ALL_DRIVERS=1
if [ "$ALL_DRIVERS" == "0" ]; then
    # Options: amd ati intel nvidia    NOTE: the only one tested is the amd one
    # The nvidia driver is the open source one
    GPU='amd'
    # Options: amd intel
    CPU='amd'
fi


PACKAGE_GROUPS=(
    'base'      # packages installing pre-chroot
    'bare'      # bare minimum to get into bash shell
    'drivers'   # cpu ucode and gpu drivers
    'basic'     # make the shell usable and preety
    'gui'       # platform independent gui apps
    'audio'     # required for audio to work
    'media'     # ffmpeg, vlc, youtube-dl, yt-dlp
    'browsers'  # dialect, firefox, librewolf, ungoogled-chromium
    'office'    # libreoffice-fresh
    'X11'       # X11 server and utilities like screen locker
    'awesome'   # awesomewm
    'wayland'   # wayland base and utilities like screen locker
    'dwl'       # dwl (wayland wm)
    'coding'    # java, rust, eclipse-java (IDE), git-filter-repo
    'fstools'   # Filesystems, ventoy, testdisk
    'gaming'    # steam. lib32 libraries, lutris, wine, some drivers, java
    'security'  # cpu-x, keepassxc, libfido2, libu2f-server, nmap, openbsd-netcat, yubikey-manager-qt
    'social'    # emojis, discord
    'misc'      # printing (cups)
    'bluetooth' # blueman, bluez, bluetooth support at initcpio
    'virt'      # QEMU
    'android'   # adb
    #'baltie'    # https://sgpsys.com/en/whatisbaltie.asp
)

# Disk 
DISK='/dev/vda'


# Bootloader
BOOTLOADER_ID="$VARIANT_NAME"
BOOT_PART="${DISK}1"
BOOT_SIZE='500M'
INSTALL_DIR='/mnt/install'


# Encryption
# 0 -> disable  1 -> enable
ENCRYPT=1
if [ "$ENCRYPT" == '1' ]; then
    CRYPT_PART="${DISK}2"
    # None means all remaining space
    CRYPT_SIZE=''
    LUKS_PASSWORD=123

    CRYPT_NAME="$VARIANT"
    CRYPT_FILE="/dev/mapper/$CRYPT_NAME"
    KEY_SIZE=256
    ITER_TIME=3000
    HASH='sha256'
    LUKSFORMAT_ARUGMNETS="--key-size $KEY_SIZE --hash $HASH --iter-time $ITER_TIME"
else
    LVM_PART="${DISK}2"
    # None means all remaining space
    LVM_SIZE=''
fi

# LVM
ENABLE_SWAP=1
SWAP_SIZE='16G'
ROOT_SIZE='50G'
# user home takes the rest
LVM_NAME="${VARIANT}_lvm"
LVM_GROUP_NAME="$VARIANT"
LVM_DIR="/dev/$LVM_GROUP_NAME"


# File systems
BOOT_DIR_ALONE='/boot'
BOOT_DIR=${INSTALL_DIR}${BOOT_DIR_ALONE}

BOOT_FORMAT_COMMAND="mkfs.fat -n Boot $BOOT_PART"
BOOT_FSTAB_ARGS="$BOOT_DIR_ALONE    vfat       rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro	0 2"

ROOT_FORMAT_COMMAND="mkfs.btrfs -f -L root $LVM_DIR/root"
ROOT_FSTAB_ARGS="/  btrfs     	rw,noatime,ssd,space_cache=v2,subvolid=5,subvol=/	0 0"

HOME_FORMAT_COMMAND="mkfs.btrfs -f -L home $LVM_DIR/home"
HOME_FSTAB_ARGS="$USER_HOME     btrfs      rw,noatime,ssd,space_cache=v2,subvolid=5,subvol=/"


# Installer
# Don't ask for confirmation
YOLO=1
AUTO_REBOOT=0
PAUSE_AFTER_DONE=1
