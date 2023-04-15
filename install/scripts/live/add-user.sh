#!/bin/bash

info "Adding user $USER1"
if ! id "$USER1" &>/dev/null; then
    useradd -s /bin/bash -G tty,ftp,games,network,scanner,users,video,audio,wheel $USER1
    mkdir -p $USER_HOME
fi

chown -R $USER1:$USER_GROUP $USER_HOME/
chown -R $USER1:$USER_GROUP $DOTFILES_DIR
