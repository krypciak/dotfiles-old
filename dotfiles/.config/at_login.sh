export AT_LOGIN_SOURCED=1

export QT_QPA_PLATFORMTHEME=qt5ct

export EDITOR='nvim'
export CM_LAUNCHER=rofi

export GIT_DISCOVERY_ACROSS_FILESYSTEM=1

if [ "$USER1" == '' ]; then
    export USER1=$USER
fi

export PATH="/home/$USER1/.local/bin:/home/$USER1/.cargo/bin$PATH"

export XDG_DATA_HOME="/home/$USER1/.local/share"
export XDG_STATE_HOME="/home/$USER1/.local/state"
export XDG_CONFIG_HOME="/home/$USER1/.config"
export XDG_CACHE_HOME="/home/$USER1/.cache"

# ~/.gtkrc-2.0
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# ~/.icons
export XCURSOR_PATH=/usr/share/icons:${XDG_DATA_HOME}/icons

# ~/.wine
export WINEPREFIX="$XDG_DATA_HOME/wine"

unset XDG_RUNTIME_DIR
export XDG_RUNTIME_DIR=$(mktemp -d /tmp/$(id -u)-runtime-dir.XXX)

[ -f "/tmp/keyboard_layout" ] || echo 'qwerty' > /tmp/keyboard_layout


