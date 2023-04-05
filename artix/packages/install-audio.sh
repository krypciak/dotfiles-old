#!/bin/bash
function install_audio() {
    echo 'pulseaudio cmus-git playerctl pulseaudio-alsa alsa-utils'
}
function configure_audio() {
    cd /tmp
    yes yes | cpan -T HTML::Entities &
    git clone https://github.com/dcx86r/cmus-notify
    cd cmus-notify
    sh installer.sh install
}
