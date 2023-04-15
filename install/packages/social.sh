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
    export -f _configure_discord1
    timeout 40s _configure_discord1 &
}

artix_social_configure() {
    _configure_discord
}

arch_social_configure() {
    _configure_discord
}

