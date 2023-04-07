#!/bin/bash
function install_dwl() {
    echo 'meson ninja xdg-desktop-portal-wlr'
}

function make_dwl() {
    cd $USER_HOME/.config/dwl/dwl-dotfiles/
    doas -u $USER1 git switch main
    doas -u $USER1 git remote add upstream https://github.com/djpohly/dwl


    if [ "$PORTABLE" == 1 ]; then
        # Disable keepassxc, tutanota, blueman applet, wlr-output and gammastep startup
        sed -i 's/"\[ \\"$(pgrep keepassxc/\/\/"\[ \\"$(pgrep keepassxc/g' config.h
        sed -i 's/"\[ \\"$(pgrep tutanota/\/\/"\[ \\"$(pgrep tutanota/g' config.h
        sed -i 's/"gammastep -r"/\/\/"gammastep -r"/g' config.h
        sed -i 's/"blueman-applet"/\/\/"blueman-applet"/g' config.h
        sed -i 's/{ "HDMI-A-1"/\/\/{ "HDMI-A-1"/g' config.h
        sed -i 's/{ "DP-2"/\/\/{ "DP-2"/g' config.h
        sed -i 's/\"alacritty --class cmus/\/\/\"alacritty --class cmus/g' config.h
    fi

    if [ "$ISO" == "yes" ]; then
        # Run private archive decryption prompt at startup
        sed -i 's/"amixer set Capture nocap",/"amixer set Capture nocap",\n\t"env USER_GROUP=\\\"1001\\\" sh $HOME\/.config\/dotfiles\/decrypt-private-data\.sh",/g' config.h
    fi

    doas -u $USER1 make
}

function make_somebar() {
    cd $USER_HOME/.config/dwl/somebar/
    doas -u $USER1 git switch master
    doas -u $USER1 git remote add upstream https://git.sr.ht/~raphi/somebar
    doas -u $USER1 meson build
    cd build
    doas -u $USER1 ninja
}

function make_someblocks() {
    cd $USER_HOME/.config/dwl/someblocks
    doas -u $USER1 git switch master
    doas -u $USER1 git remote add upstream https://git.sr.ht/~raphi/someblocks
    doas -u $USER1 make
}

function make_dpms() {
    cd $USER_HOME/.config/dwl/dpms-off
    doas -u $USER1 git switch master
    doas -u $USER1 cargo build --release
    rm -rf $USER_HOME/.config/dotfiles/dotfiles/dwl/dpms-off/target/release/{deps,build}
}

function configure_dwl() {
    make_dwl
    make_somebar
    make_someblocks
    make_dpms
    chown $USER1:$USER_GROUP -R $USER_HOME/.config/dwl
}

