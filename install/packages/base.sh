#!/bin/bash
artix_base_install() {
    echo "$KERNEL $KERNEL-headers artix-keyring artix-mirrorlist autoconf automake base bison elogind-openrc fakeroot flex gcc groff iptables-nft libtool m4 make openntpd-openrc openrc pacman patch pkgconf texinfo util-linux which linux-firmware opendoas"
}

arch_base_install() {
    echo "$KERNEL $KERNEL-headers autoconf automake base bison fakeroot flex gcc groff iptables-nft libtool m4 make openntpd pacman patch pkgconf texinfo util-linux which archlinux-keyring bash bzip2 coreutils file filesystem findutils gawk gcc-libs gettext glibc grep gzip iproute2 iputils licenses pciutils procps-ng psmisc sed shadow systemd systemd-sysvcompat tar xz linux-firmware opendoas"
}
