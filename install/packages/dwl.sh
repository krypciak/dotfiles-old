#!/bin/bash

_make_dwl() {
    info 'Compiling dwl'
    cd $USER_HOME/.config/dwl/dwl-dotfiles/
    doas -u $USER1 git switch main
    doas -u $USER1 git remote add upstream https://github.com/djpohly/dwl
    doas -u $USER1 git reset --hard HEAD

    if [ "$PORTABLE" == 1 ]; then
        # Disable keepassxc, tutanota, blueman applet, wlr-output and gammastep startup
        sed -i 's/"\[ \\"$(pgrep keepassxc/\/\/"\[ \\"$(pgrep keepassxc/g' config.h
        sed -i 's/"\[ \\"$(pgrep tutanota/\/\/"\[ \\"$(pgrep tutanota/g' config.h
        sed -i 's/"gammastep -r"/\/\/"gammastep -r"/g' config.h
        sed -i 's/"blueman-applet"/\/\/"blueman-applet"/g' config.h
        sed -i 's/{ "HDMI-A-1"/\/\/{ "HDMI-A-1"/g' config.h
        sed -i 's/{ "DP-2"/\/\/{ "DP-2"/g' config.h
        sed -i 's/\"alacritty --class cmus/\/\/\"alacritty --class cmus/g' config.h
        sed -i 's/\"wlr-randr --output DP-1 --off/\/\/\"wlr-randr --output DP-1 --off/g' config.h
    fi

    if [ "$ISO" == "yes" ]; then
        # Run private archive decryption prompt at startup
        sed -i 's/"amixer set Capture nocap",/"amixer set Capture nocap",\n\t"env USER_GROUP=\\\"1001\\\" sh $HOME\/.config\/dotfiles\/decrypt-private-data\.sh",/g' config.h
    fi

    doas -u $USER1 make
}

_make_somebar() {
    info 'Compiling somebar'

    cd $USER_HOME/.config/dwl/somebar/
    doas -u $USER1 git switch master
    doas -u $USER1 git remote add upstream https://git.sr.ht/~raphi/somebar
    doas -u $USER1 git reset --hard HEAD
    doas -u $USER1 meson build
    cd build
    doas -u $USER1 ninja
}

_make_someblocks() {
    info 'Compiling someblocks'

    cd $USER_HOME/.config/dwl/someblocks
    doas -u $USER1 git switch master
    doas -u $USER1 git remote add upstream https://git.sr.ht/~raphi/someblocks
    doas -u $USER1 git reset --hard HEAD
    doas -u $USER1 make
}

_make_dpms() {
    info 'Compiling dpms'

    cd $USER_HOME/.config/dwl/dpms-off
    doas -u $USER1 git switch master
    doas -u $USER1 cargo build --release
    doas -u $USER1 git reset --hard HEAD
    rm -rf $USER_HOME/.config/dotfiles/dotfiles/dwl/dpms-off/target/release/{deps,build}
}

_configure_dwl() {
    set +e
    _make_dwl
    _make_somebar
    _make_someblocks
    #_make_dpms
    set -e
    chown $USER1:$USER_GROUP -R $USER_HOME/.config/dwl
}


artix_dwl_install() {
    echo 'meson ninja xdg-desktop-portal-wlr'
}

arch_dwl_install() {
    echo 'meson ninja xdg-desktop-portal-wlr'
}

artix_dwl_configure() {
    _configure_dwl
}

arch_dwl_configure() {
    _configure_dwl
}

