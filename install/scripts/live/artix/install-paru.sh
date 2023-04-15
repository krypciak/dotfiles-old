#!/bin/sh

info "Installing paru (AUR manager)"
if [ -d /tmp/paru ]; then rm -rf /tmp/paru; fi

# If paru is already installed, skip this step
if ! command -v "paru"; then
    pacman $PACMAN_ARGUMENTS -S git doas
    git clone https://aur.archlinux.org/paru-bin.git /tmp/paru
    chown -R $USER1:$USER_GROUP /tmp/paru
    chmod -R +wrx /tmp/paru
    cd /tmp/paru
    doas -u $USER1 makepkg -si --noconfirm --needed
fi
cp "$VARIANT_ROOT_DIR/etc/paru.conf" /etc/paru.conf
 
info "Disabling mkinitcpio"
mv /usr/share/libalpm/hooks/90-mkinitcpio-install.hook /90-mkinitcpio-install.hook 

