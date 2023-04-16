#!/bin/bash

chown -R $USER1:$USER_GROUP $USER_HOME

if [ $INSTALL_DOTFILES -eq 1 ]; then
    info "Installing dotfiles for user $USER1"
    rm -rf $USER_HOME/.config
    doas -u $USER1 sh $DOTFILES_DIR/install-dotfiles.sh

    info "Installing dotfiles for root"
    source $DOTFILES_DIR/install-dotfiles-root.sh

    if [ $INSTALL_PRIVATE_DOTFILES -eq 1 ]; then
        confirm "Install private dotfiles?"
        export GPG_AGENT_INFO=""
        source $DOTFILES_DIR/decrypt-private-data.sh
    fi
fi

info 'Generating fish completions'
fish --command "fish_update_completions" 
doas -u $USER1 fish --command "fish_update_completions" 

wait $(jobs -p)
