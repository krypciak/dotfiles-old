#!/bin/bash

artix_bluetooth_install() {
    echo 'blueman bluetooth-autoconnect bluez-openrc bluez-utils mkinitcpio-bluetooth'
}

arch_bluetooth_install() {
    echo 'blueman bluetooth-autoconnect bluez bluez-utils mkinitcpio-bluetooth'
}

artix_bluetooth_configure() {
    cp -v "$VARIANT_CONFIGS_DIR/bluetooth-autoconnect" /etc/init.d/bluetooth-autoconnect
    chmod +x /etc/init.d/bluetooth-autoconnect
    # Disable adding some files, otherwise mkinitcpio fails
    sed -e '/add_file\t\/usr\/share\/dbus-1\/system-services\/org\.bluez\.service/ s/^#*/#/' -i /usr/lib/initcpio/install/bluetooth
    sed -e '/add_file\t\/usr\/lib\/tmpfiles\.d\/dbus.conf/ s/^#*/#/' -i /usr/lib/initcpio/install/bluetooth

    rc-update add bluetoothd default
    rc-update add bluetooth-autoconnect default
}

arch_bluetooth_configure() {
    systemctl enable bluetoothd
    systemctl enable blutooth-autoconnect
}
