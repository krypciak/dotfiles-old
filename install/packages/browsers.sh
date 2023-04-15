#!/bin/bash

_init_browsers() {
    # Let firefox extensions init
    doas -u $USER1 timeout 10s librewolf --headless &
    doas -u $USER1 timeout 10s firefox --class invidious --profile $USER_HOME/.local/share/ice/firefox/invidious --headless &
}

artix_browsers_install() {
    echo 'dialect firefox libreoffice-fresh librewolf ungoogled-chromium'
}

arch_browsers_install() {
    echo 'dialect firefox libreoffice-fresh librewolf ungoogled-chromium'
}


artix_browsers_configure() {
    _init_browsers
}

arch_browsers_configure() {
    _init_browsers
}

