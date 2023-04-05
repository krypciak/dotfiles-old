#!/bin/bash
function install_bluetooth() {
    echo 'bluez bluez-utils blueman bluetooth-autoconnect'
}

function configure_bluetooth() {
    rc-update add bluetoothd default
    cp -v "$CONFIGD_DIR/bluetooth-autoconnect" /etc/init.d/bluetooth-autoconnect
    chmod +x /etc/init.d/bluetooth-autoconnect
    rc-update add bluetooth-autoconnect default
    # Disable adding some files, otherwise mkinitcpio fails
    sed -e '/add_file\t\/usr\/share\/dbus-1\/system-services\/org\.bluez\.service/ s/^#*/#/' -i /usr/lib/initcpio/install/bluetooth
    sed -e '/add_file\t\/usr\/lib\/tmpfiles\.d\/dbus.conf/ s/^#*/#/' -i /usr/lib/initcpio/install/bluetooth
}
