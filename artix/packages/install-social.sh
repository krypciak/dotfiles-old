#!/bin/bash
function install_social() {
    echo 'noto-fonts-cjk ttf-symbola noto-fonts-emoji discord betterdiscordctl'
}

function configure_discord() {
    timeout 30s xvfb-run -a discord
    betterdiscordctl install
}

function configure_social() {
    # Let discord download updates
    export -f configure_discord
    timeout 40s configure_discord &
}

