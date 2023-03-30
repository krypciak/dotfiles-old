# My personal linux configuration files

## Dotfiles installation  
To do anything, you first want to clone the repo.
```bash
mkdir -p ~/home/.config
cd ~/home/.confg
git clone https://github.com/krypciak/dotfiles
```

### WARNING: Installing will result in your home directory getting wiped! Only install on clean users!  
If you want to override all your files without warning, set `YOLO` variable to `1`  
To install for currently logged in user:  
```bash
export USER1="$USER"
export YOLO=0
sh install-dotfiles.sh
```

### Root dotfiles
Root dotfiles contain configuration for `fish` and `neovim`
```bash
export YOLO=0
sh install-dotfiles-root.sh
```
