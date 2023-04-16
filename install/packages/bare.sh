#!/bin/bash

_configure_greetd() {
    pri "Configuring greetd"
    sed -i "s|USER_HOME|$USER_HOME|g" /etc/greetd/config.toml
    sed -i "s/USER1/$USER1/g" /etc/greetd/config.toml
    chown greeter:greeter /etc/greetd/config.toml
}

artix_bare_install() {
    echo 'btrfs-progs clang dbus dbus-glib dbus-openrc dbus-python doas-sudo-shim dosfstools efibootmgr git greetd-artix-openrc greetd-tuigreet-bin grub mtools networkmanager-openrc opendoas openntpd-openrc pacman-contrib perl python python-pip ttf-dejavu ttf-hack unrar unzip util-linux wget zip'
}

arch_bare_install() {
    echo 'btrfs-progs clang dbus dbus dbus-glib dbus-python doas-sudo-shim dosfstools efibootmgr git greetd greetd-tuigreet-bin grub mtools networkmanager opendoas openntpd perl python python-pip ttf-dejavu ttf-hack unrar unzip util-linux wget zip'

}

artix_bare_configure() {
    _configure_greetd

    rc-update add greetd default
    rc-update del agetty.tty1 default > /dev/null 2>&1
    rc-update add ntpd default
    rc-update add NetworkManager default
}

arch_bare_configure() {
    _configure_greetd

    systemctl enable greetd
    systemctl enable ntpd
    systemctl enable NetworkManager
}
