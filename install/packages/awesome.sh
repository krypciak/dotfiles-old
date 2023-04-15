#!/bin/bash
_configure_awesome() {
    if [ "$PORTABLE" == 1 ]; then
        cd $USER_HOME/.config/awesome

        sed -i 's/run_if_not_running_pgrep({"redshift/--run_if_not_running_pgrep({"redshift/g' autostart.lua
        sed -i 's/run_if_not_running_pgrep("keepassxc/--run_if_not_running_pgrep("keepassxc/g' autostart.lua
        sed -i 's/run_if_not_running_pgrep({"tutanota/--run_if_not_running_pgrep({"tutanota/g' autostart.lua
        sed -i 's/run_if_not_running_pgrep("blueman-applet/--run_if_not_running_pgrep("blueman-applet/g' autostart.lua
    fi
}

artix_install_awesome() {
    echo 'awesome'
}

arch_install_awesome() {
    echo 'awesome'
}

artix_configure_awesome() {
    _configure_awesome
}

arch_configure_awesome() {
    _configure_awesome
}

