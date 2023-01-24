#~/bin/sh
if [ "$1" != "yes!" ]; then
    echo "This script damages your host system. Exiting..."
    exit 1
fi

cd /
git clone --depth 1 --recurse-submodules https://github.com/krypciak/dotfiles
git submodule update --init --recursive
sh /dotfiles/artix/iso-chroot.sh
