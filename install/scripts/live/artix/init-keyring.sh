
#!/bin/bash

info 'Updating keyring'
# Disable package signature verification
sed -i 's/SigLevel    = Required DatabaseOptional/SigLevel = Never/g' /etc/pacman.conf
sed -i 's/LocalFileSigLevel = Optional/#LocalFileSigLevel = Optional/g' /etc/pacman.conf
# Add lib32 repo
printf '[lib32]\nInclude = /etc/pacman.d/mirrorlist\n' >> /etc/pacman.conf
# Add universe repo
printf '[universe]\nServer = https://universe.artixlinux.org/$arch\nServer = https://mirror1.artixlinux.org/universe/$arch\nServer = https://mirror.pascalpuffke.de/artix-universe/$arch\nServer = https://artixlinux.qontinuum.space/artixlinux/universe/os/$arch\nServer = https://mirror1.cl.netactuate.com/artix/universe/$arch\nServer = https://ftp.crifo.org/artix-universe/\n' >> /etc/pacman.conf

PACKAGES_LIST='artix-archlinux-support '
if [ $LIB32 -eq 1 ]; then
    PACKAGES_LIST="$PACKAGES_LIST lib32-artix-archlinux-support"
fi
pacman $PACMAN_ARGUMENTS -Syu $PACKAGES_LIST > $OUTPUT 2>&1
pacman-key --init > $OUTPUT 2>&1
pacman-key --populate > $OUTPUT 2>&1

info 'Copying pacman configuration'
cp $VARIANT_ROOT_DIR/etc/pacman.conf /etc/pacman.conf
cp -r $VARIANT_ROOT_DIR/etc/pacman.d /etc/
pacman -Sy > $OUTPUT 2>&1

if [ "$TYPE" == 'iso' ]; then
    sed -i 's/CheckSpace/#CheckSpace/g' /etc/pacman.conf
fi

sed -i 's/#PACMAN_AUTH=()/PACMAN_AUTH=(doas)/' /etc/makepkg.conf
sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/' /etc/makepkg.conf


