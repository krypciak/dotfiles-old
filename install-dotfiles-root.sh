#!/bin/sh

if [ "$(whoami)" != 'root' ]; then
    echo 'This script needs to be run as root.'
    exit
fi

if [ -z $DOTFILES_DIR ]; then
    DOTFILES_DIR="$(dirname "$0" | xargs realpath)"
fi

mkdir -p /root/.config/nvim
cp -r "$DOTFILES_DIR/dotfiles/.config/nvim" /root/.config/

mkdir -p /root/.local/share/nvim
cp -r "$DOTFILES_DIR/dotfiles/.local/share/nvim" /root/.local/share/


mkdir -p /root/.config/fish
cp -r "$DOTFILES_DIR/dotfiles/.config/fish" /root/.config/

cp -r "$DOTFILES_DIR/dotfiles/.bashrc" /root/

cp -r "$DOTFILES_DIR/dotfiles/.config/at-login.sh" /root/.config/
cp -r "$DOTFILES_DIR/dotfiles/.config/aliases.sh" /root/.config/
cp -r "$DOTFILES_DIR/dotfiles/.config/.bash-preexec.sh" /root/.config/


# Update nvim plugins if there is internet
if nc -z 8.8.8.8 53 -w 1; then
    printf 'Updating neovim plugins...\n'
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerUpdate' > /dev/null 2>&1
    echo Done
fi
