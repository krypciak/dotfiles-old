#!/bin/bash
function install_security() {
    echo 'keepassxc world/gnome-keyring openbsd-netcat nmap cpu-x libu2f-server pcsclite-openrc libfido2 yubikey-manager-qt'
}

function configure_secutiry() {
    rc-update add pcscd default
}
