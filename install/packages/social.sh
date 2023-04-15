#!/bin/bash

artix_social_install() {
    echo 'betterdiscordctl discord noto-fonts-cjk noto-fonts-emoji ttf-symbola'
}

arch_social_install() {
    echo 'betterdiscordctl discord noto-fonts-cjk noto-fonts-emoji ttf-symbola'
}

_configure_discord1() {
    timeout 30s xvfb-run -a discord > /dev/null
    betterdiscordctl install
}

_configure_discord() {
    # Let discord download updates
    export -f configure_discord
    timeout 40s configure_discord &
}

artix_social_configure() {
    _configure_discord
}

arch_social_configure() {
    _configure_discord
}

