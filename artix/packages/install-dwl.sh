#!/bin/bash
function install_dwl() {
    echo 'meson ninja xdg-desktop-portal-wlr'
}

function configure_dwl() {
    cd $USER_HOME/.config/dwl/dwl-dotfiles/
    git switch main1

    if [ "$PORTABLE" == 1 ]; then
        # Disable keepassxc, tutanota, blueman applet, wlr-output and gammastep startup
        sed -i 's/"\[ \\\\"$(pgrep keepassxc/\/\/"\[ \\\\"$(pgrep keepassxc/g' config.h
        sed -i 's/"\[ \\\\"$(pgrep tutanota/\/\/"\[ \\\\"$(pgrep tutanota/g' config.h
        sed -i 's/"gammastep -r"/\/\/"gammastep -r"/g' config.h
        sed -i 's/"blueman-applet"/\/\/"blueman-applet"/g' config.h
        sed -i 's/"wlr-randr --output/\/\/"wlr-randr --output/g' config.h
    fi

    doas -u $USER1 make &
    
    cd $USER_HOME/.config/dwl/somebar/
    git switch master
    doas -u $USER1 meson build
    cd build
    doas -u $USER1 ninja &

    cd $USER_HOME/.config/dwl/someblocks
    git switch master
    doas -u $USER1 make &

    cd $USER_HOME/.config/dwl/dpms-off
    git switch master
    doas -u $USER1 cargo build --release
    rm -rf $USER_HOME/.config/dotfiles/dotfiles/dwl/dpms-off/target/release/{deps,build}

    chown $USER1:$USER_GROUP -R $USER_HOME/.config/dwl

}
