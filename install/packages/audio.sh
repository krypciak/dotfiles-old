#!/bin/bash
_setup_cmus_notifications() {
    cd /tmp
    yes yes | cpan -T HTML::Entities
    git clone https://github.com/dcx86r/cmus-notify
    cd cmus-notify
    sh installer.sh install
}

artix_audio_install() {
    echo 'alsa-utils cmus-git perl playerctl pulseaudio pulseaudio-alsa'
}

arch_audio_install() {
    echo 'alsa-utils cmus-git perl playerctl pulseaudio pulseaudio-alsa'
}


artix_audio_configure() {
    _setup_cmus_notifications
}

arch_audio_configure() {
    _setup_cmus_notifications
}




