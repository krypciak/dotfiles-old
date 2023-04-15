#!/bin/bash

artix_virt_install() {
    echo 'dnsmasq edk2-ovmf iptables-nft libvirt libvirt-openrc qemu-desktop virt-manager'
}

arch_virt_install() {
    echo 'dnsmasq edk2-ovmf iptables-nft libvirt qemu-desktop virt-manager'
}

_configure_qemu() {
    cp $CONFIGD_DIR/root/etc/libvirt/libvirtd.conf /etc/libvirt/libvirtd.conf
    chown root:root /etc/libvirt/libvirtd.conf

    cp $CONFIGD_DIR/root/etc/libvirt/qemu.conf /etc/libvirt/qemu.conf
    sed -i "s/USER/$USER1/g" /etc/libvirt/qemu.conf
    chown root:root /etc/libvirt/qemu.conf

    usermod -aG libvirt $USER1
}

artix_virt_configure() {
    _configure_qemu
    rc-update add libvirtd default
}

arch_virt_configure() {
    _configure_qemu
    systemctl enable libvirtd
}

