#!/bin/bash

confirm "Install basic packages to ${INSTALL_DIR}?"
basestrap -C $COMMON_CONFIGS_DIR/pacman.conf.install $INSTALL_DIR base openrc elogind-openrc artix-keyring artix-mirrorlist pacman autoconf automake bison fakeroot flex gcc groff libtool m4 make patch pkgconf texinfo which iptables-nft $KERNEL $KERNEL-headers util-linux openntpd-openrc
