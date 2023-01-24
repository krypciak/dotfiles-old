#!/bin/bash
function install_social() {
    echo 'noto-fonts-cjk ttf-symbola noto-fonts-emoji discord betterdiscordctl'
}

function configure_social() {
    # Let discord download updates
    timeout 60s xvfb-run -a discord &
}
