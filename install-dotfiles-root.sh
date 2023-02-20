#!/bin/sh
DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

mkdir -p /root/.config/nvim
cp -r $DOTFILES_DIR/dotfiles/.config/nvim /root/.config/
chown -R root:root /root/.config/nvim

mkdir -p /root/.config/fish
cp -r $DOTFILES_DIR/dotfiles/.config/fish /root/.config/
chown -R root:root /root/.config/fish

cp -r $DOTFILES_DIR/dotfiles/.bashrc /root/
chown -R root:root /root/.bashrc

# Update nvim plugins
echo Updating neovim plugins...
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' > /dev/null 2>&1 &
