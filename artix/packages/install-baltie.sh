#!/bin/sh
function install_baltie() {
    echo ''
}

function configure_baltie() {
    export PACkAGES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

    [ ! -f '/tmp/baltie.zip' ] && wget https://sgpsys.com/download/b3/b3_u_plk.zip -O /tmp/baltie.zip
    [ ! -f '/tmp/setup.exe' ] && unzip /tmp/baltie.zip -d /tmp/
    
    innoextract --info --language ENG --extract --output-dir "/tmp/baltie-extracted" /tmp/setup.exe
    
    BASE_DIR="$USER_HOME/.local/share/wine/drive_c/Program Files (x86)/SGP Systems"
    INSTALL_DIR="$BASE_DIR/SGP Baltie 3"
    
    mkdir -p "$BASE_DIR"
    mv /tmp/baltie-extracted/app "$INSTALL_DIR"
    
    cp "$CONFIGD_DIR/Baltie3.desktop" "$USER_HOME/.local/share/applications"
    chmod +x "$CONFIGD_DIR/Baltie3.desktop"
}
