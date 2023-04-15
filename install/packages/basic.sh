#!/bin/sh

_configure_tldr() {
    # Generate tealdeer pages
    tldr --update
    doas -u $USER1 tldr --update
}

_configure_cronie() {
    cp $COMMON_CONFIGS_DIR/cron_user /var/spool/cron/$USER1
    chown $USER1:$USER_GROUP /var/spool/cron/$USER1
    
    cp $COMMON_CONFIGS_DIR/cron_root /var/spool/cron/root
    sed -i "s|USER_HOME|$USER_HOME|g" /var/spool/cron/root
    chown root:root /var/spool/cron/root
}

artix_basic_install() {
    # ranger
    echo 'atuin autojump bat bc bottom chatgpt-cli-bin chatgpt-cli-bin clang cronie-openrc dog dust fd fish fzf htop hyperfine imagemagick innoextract lfs lsd lua-language-server man-db man-pages moreutils neofetch net-tools nvim-packer-git p7zip procs pyright rmtrash rust-analyzer syntax-highlighting tealdeer tmux tokei trash-cli ttf-nerd-fonts-symbols-2048-em ttyper-git xorg-server-xvfb xorg-server-xvfb'
}

arch_basic_install() {
    echo 'atuin autojump bat bc bottom chatgpt-cli-bin chatgpt-cli-bin clang cronie dog dust fd fish fzf htop hyperfine imagemagick innoextract lfs lsd lua-language-server man-db man-pages moreutils neofetch net-tools nvim-packer-git p7zip procs pyright rmtrash rust-analyzer syntax-highlighting tealdeer tmux tokei trash-cli ttf-nerd-fonts-symbols-2048-em ttyper-git xorg-server-xvfb xorg-server-xvfb'

}

#python3 -m pip install --user --upgrade pynvim
#pip install black-macchiato

artix_bare_configure() {
    _configure_tldr
    rc-update add cronie default
}


arch_bare_configure() {
    _configure_tldr
    systemctl enable cronie

}

