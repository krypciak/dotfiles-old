#!/bin/sh

[ -z "$USER1" ] && export USER1="$USER"
USER_HOME="/home/$USER1"
FAKE_USER_HOME="$USER_HOME/home"
[ -z "$USER_GROUP" ] && export USER_GROUP="$USER1"

DOTFILES_DIR="$(dirname "$0" | xargs realpath)"

SYMLINK_FROM_TO="\
    .config/at_login.sh \
    .config/nvim \
    .local/share/nvim \
    .config/fish \
    .config/tealdeer \
    .bashrc \
    .config/xsessions \
    .config/neofetch \
    .config/topgrade.toml \
    .config/ttyper \
    .config/animdl \
    \
    .config/alacritty \
    .config/wallpapers \
    .config/cmus/autosave \
    .config/cmus/red_theme.theme \
    .config/cmus/notify.cfg \
    \
    .xinitrc \
    .config/awesome \
    .config/redshift \
    .config/copyq \
    .config/rofi \
    \
    .config/dwl \
    .config/gammastep \
    .config/fuzzel \
    .config/swaylock \
    .config/fnott \
    \
    .config/chromium/Default/Extensions \
    .config/chromium/Default/Sync|Extension|Settings \
    .config/chromium/Default/Managed|Extension|Settings \
    .config/chromium/Default/Local|Extension|Settings \
    \
    .config/BetterDiscord/plugins \
    \
    .librewolf/native-messaging-hosts \
    .librewolf/profiles.ini \
    .librewolf/profile0/extension-preferences.json \
    .librewolf/profile0/extensions \
    .config/tridactyl \
    \
    .config/gtkrc \
    .config/gtkrc-2.0 \
    .config/krunnerrc \
    .config/plasmarc \
    .config/plasmashellrc \
"

# If path starts with %, will not override
COPY_FROM_TO="\
    .config/gtk-2.0 \
    .config/gtk-3.0 \
    .config/gtk-4.0 \
    .config/qt5ct \
    .config/kdeglobals \
    \
    .config/tutanota-desktop/conf.json \
    \
    .config/discord/settings.json \
    \
    .config/FreeTube/settings.db \
    \
    .local/share/PrismLauncher/multimc.cfg \
    \
    .config/keepassxc \
    \
    .local/share/applications/tutanota-desktop.desktop \
    .local/share/applications/arch-update.desktop \
    \
    %.librewolf/profile0/prefs.js \
    %.librewolf/profile0/search.json.mozlz4 \
    %.librewolf/profile0/storage.sqlite \
    %.librewolf/profile0/cookies.sqlite \
    %.librewolf/profile0/extension-settings.json \
    %.librewolf/profile0/extensions.json \
    %.librewolf/profile0/sessionCheckpoints.json \
    \
    .config/chromium/Default/Preferences  \
    %.config/chromium/Default/Cookies \
    .config/chromium/Local|State \
    .config/chromium-flags.conf \
"


LINK_HOME_DIRS="\
    .config \
    .local \
    Documents \
    Downloads \
    Pictures \
    Videos \
    Programming \
    VM \
    Games \
    Temp \
    Music \
    .mozilla \
"

LGREEN='\033[1;32m'
GREEN='\033[0;32m'
LBLUE='\033[1;34m'
NC='\033[0m' 

confirm() {
	printf "$LBLUE |||$GREEN Do you want to override ${LGREEN}$1 $2 $3 $LBLUE(Y/n)? >> $NC"
	if [ -n "$YOLO" ] && [ "$YOLO" -eq 1 ]; then
		printf "y\n"
		rm -rf "$1"
		return
	fi
	read -r choice
	case "$choice" in 
	y|Y|"" ) rm -rf "$1";;
	n|N ) return;;
	* ) confirm "$1" "$2" "$3"; return;;
	esac
}

mkdir -p "$USER_HOME"
mkdir -p "$FAKE_USER_HOME"

for dir in $LINK_HOME_DIRS; do
	DEST="$USER_HOME/$dir"
	if [ -h "$DEST" ]; then unlink  "$DEST"; fi
	if [ -e "$DEST" ]; then confirm "$DEST"; fi
	mkdir -p "$FAKE_USER_HOME/$dir"
	ln -sfT "$FAKE_USER_HOME/$dir" "$DEST"
done

git submodule update --init --recursive

for path in $SYMLINK_FROM_TO; do
    path="$(echo "$path" | tr '|' ' ')"
	override=1
    if [ "$(echo "$path" | head -c +1)" = '%' ]; then override=0; path="$(echo "$path" | tail -c +2)"; fi
	from="$DOTFILES_DIR/dotfiles/$path"
	dest="$USER_HOME/$path"

	if [ $override -eq 1 ] || [ ! -e "$dest" ]; then
        	if [ -h "$dest" ]; then unlink "$dest"; fi
        	if [ -e "$dest" ]; then confirm "$dest"; fi

	        mkdir -p "$(dirname "$dest" | head --lines 1)"
	        ln -sfT "$from" "$dest"
		    chown -R "$USER1:$USER_GROUP" "$dest"
    	fi
done

for path in $COPY_FROM_TO; do
    path="$(echo "$path" | tr '|' ' ')"
	override=1
    if [ "$(echo "$path" | head -c +1)" = '%' ]; then override=0; path="$(echo "$path" | tail -c +2)"; fi

	from="$DOTFILES_DIR/dotfiles/$path"
	dest="$USER_HOME/$path"

	if [ $override -eq 1 ] || [ ! -e "$dest" ]; then
        	if [ -h "$dest" ]; then unlink "$dest"; fi
        	if [ -e "$dest" ]; then confirm "$dest"; fi

	        mkdir -p "$(dirname "$dest" | head --lines 1)"
	        cp -rf "$from" "$dest"
		chown -R "$USER1:$USER_GROUP" "$dest"
    	fi
done

sed -i "s|USER_HOME|$USER_HOME|g" "$USER_HOME/.local/share/PrismLauncher/multimc.cfg"
sed -i "s|HOSTNAME|$(hostname)|g" "$USER_HOME/.local/share/PrismLauncher/multimc.cfg"

#sed -i "s|USER_HOME|$USER_HOME|g" $USER_HOME/.local/share/applications/invidious.desktop
sed -i "s|USER_HOME|$USER_HOME|g" "$USER_HOME/.local/share/applications/arch-update.desktop"

cp "$USER_HOME/.config/dotfiles/scripts/update-arch.sh-tofill" "$USER_HOME/.config/dotfiles/scripts/update-arch.sh"
sed -i "s|USER_HOME|$USER_HOME|g" "$USER_HOME/.config/dotfiles/scripts/update-arch.sh"


chmod +x "$USER_HOME/.config/awesome/run/run.sh"
chmod +x "$USER_HOME/.config/at_login.sh"
chmod +x "$USER_HOME"/.config/dotfiles/scripts/*.sh

# Update nvim plugins
printf 'Updating neovim plugins...\n'
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerUpdate' > /dev/null 2>&1
echo Done
