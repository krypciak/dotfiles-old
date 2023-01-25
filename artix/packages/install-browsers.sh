#!/bin/bash
function install_browsers() {
    echo 'dialect firefox librewolf ungoogled-chromium libreoffice-fresh'
}

function configure_browsers() {
    # Let firefox extensions init
    doas -u $USER1 timeout 10s librewolf --headless &
    doas -u $USER1 timeout 10s firefox --class invidious --profile $USER_HOME/.local/share/ice/firefox/invidious --headless &
    read
}
