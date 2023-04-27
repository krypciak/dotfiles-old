#!/bin/sh
DOTFILES_DIR="$(dirname "$0" | xargs realpath)"

mkdir -p /root/.config/nvim
cp -r "$DOTFILES_DIR/dotfiles/.config/nvim" /root/.config/
chown -R root:root /root/.config/nvim

mkdir -p /root/.config/fish
cp -r "$DOTFILES_DIR/dotfiles/.config/fish" /root/.config/
chown -R root:root /root/.config/fish

cp -r "$DOTFILES_DIR/dotfiles/.bashrc" /root/
chown -R root:root /root/.bashrc

cp -r "$DOTFILES_DIR/dotfiles/.config/at_login.sh" /root/.config/
chown -R root:root /root/.config/at_login.sh

# Update nvim plugins if there is internet
if nc -z 8.8.8.8 53 -w 1; then
    printf 'Updating neovim plugins...\n'
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerUpdate' > /dev/null 2>&1
    echo Done
fi
