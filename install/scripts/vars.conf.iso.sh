#!/bin/sh
set -a

PORTABLE=1
KERNEL='linux-zen'


# User configuration
USER1='krypek'
USER_GROUP='krypek'
USER_HOME="/home/$USER1"
FAKE_USER_HOME="$USER_HOME/home"

USER_PASSWORD=123
ROOT_PASSWORD=123

INSTALL_DOTFILES=1
INSTALL_PRIVATE_DOTFILES=0
PRIVATE_DOTFILES_PASSWORD=''


REGION='Europe'
CITY='Warsaw'
HOSTNAME="$USER1$VARIANT_NAME"
LANG='en_US.UTF-8'


# Packages
LIB32=1
PACMAN_ARGUMENTS='--ignore ttf-nerd-fonts-symbols --color=always --noconfirm --needed'
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

COPY_OFFLINE_PACKAGES=0

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
    'baltie'    # https://sgpsys.com/en/whatisbaltie.asp
)


# Installer
# Don't ask for confirmation
YOLO=1
PAUSE_AFTER_DONE=0
