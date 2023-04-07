#!/bin/sh
function install_basic() {
    echo 'dbus dbus-openrc dbus-python dbus-glib fzf perl python rmtrash trash-cli ttf-dejavu ttf-hack python-pip htop autojump git neofetch neovim-symlinks ranger syntax-highlighting tealdeer util-linux wget lsd dos2unix p7zip unrar unzip zip mandoc greetd-artix-openrc greetd-tuigreet-bin nvim-packer-git net-tools fish opendoas efibootmgr grub dosfstools mtools tmux galaxy/ttf-nerd-fonts-symbols-2048-em util-linux atuin bat bottom dog dust fd hyperfine lfs procs tokei imagemagick openntpd-openrc lua-language-server pyright rust-analyzer moreutils bc xorg-server-xvfb clang chatgpt-cli-bin'
}

function configure_basic() {
    pri "Configuring greetd"
    sed -i "s/USER_HOME/$ESCAPED_USER_HOME/g" /etc/greetd/config.toml
    sed -i "s/USER1/$USER1/g" /etc/greetd/config.toml
    chown greeter:greeter /etc/greetd/config.toml
    rc-update add greetd default
    rc-update del agetty.tty1 default

    rc-update add ntpd default

    python3 -m pip install --user --upgrade pynvim
    pip install black-macchiato

    # Symlink doas to sudo
    ln -s $(which doas) /usr/bin/sudo

    # Generate tealdeer pages
    tldr --update
}
