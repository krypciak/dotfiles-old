#!/bin/bash

artix_social_install() {
    echo 'betterdiscordctl discord noto-fonts-cjk noto-fonts-emoji ttf-symbola'
}

arch_social_install() {
    echo 'betterdiscordctl discord noto-fonts-cjk noto-fonts-emoji ttf-symbola'
}

_configure_discord1() {
    if  ping -c 1 gnu.org > /dev/null 2>&1 && [ "$TYPE" = 'iso' ]; then
        set +e
        timeout 15s xvfb-run -a discord > /dev/null 2>&1
        betterdiscordctl install > /dev/null 2>&1
        set -e
    fi
}

_configure_discord() {
    # Let discord download updates
    export -f _configure_discord1
    doas -u $USER1 timeout 40s sh -c _configure_discord1 &
}

artix_social_configure() {
    _configure_discord
}

arch_social_configure() {
    _configure_discord
}

