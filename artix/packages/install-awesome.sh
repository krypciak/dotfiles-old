#!/bin/bash
function install_awesome() {
    echo 'awesome'
}

function configure_awesome() {
    if [ "$PORTABLE" == 1 ]; then
        cd $USER_HOME/.config/awesome

        sed -i 's/run_if_not_running_pgrep({"redshift/--run_if_not_running_pgrep({"redshift/g' autostart.lua
        sed -i 's/run_if_not_running_pgrep("keepassxc/--run_if_not_running_pgrep("keepassxc/g' autostart.lua
        sed -i 's/run_if_not_running_pgrep({"tutanota/--run_if_not_running_pgrep({"tutanota/g' autostart.lua
        sed -i 's/run_if_not_running_pgrep("blueman-applet/--run_if_not_running_pgrep("blueman-applet/g' autostart.lua
    fi
}
