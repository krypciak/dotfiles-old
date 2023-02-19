#~/bin/sh

USER_HOME="/home/$USER1"
FAKE_USER_HOME="$USER_HOME/home"

DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SYMLINK_FROM_TO=( 
    ".config/at_login.sh"
    ".config/awesome"
    ".config/nvim"
    ".config/alacritty"
    ".config/ttyper"
    ".config/redshift"
    ".config/copyq"
    ".config/fish"
    ".config/xsessions"
    ".config/cmus/autosave"
    ".config/cmus/red_theme.theme"
    ".config/cmus/notify.sh"
    ".config/topgrade.toml"
    ".config/neofetch"
    ".config/tealdeer"
    ".config/chromium/Default/Extensions"
    ".config/chromium/Default/Sync Extension Settings"
    ".config/chromium/Default/Managed Extension Settings"
    ".config/chromium/Default/Local Extension Settings"
    ".config/BetterDiscord/plugins"
    ".config/dwl"
    ".config/gammastep"
    ".config/fuzzel"
    ".config/swaylock"
    ".config/Ferdium/config"
    ".config/wallpapers"
    ".config/rofi"

    ".bashrc"
    ".xinitrc"

    ".mozilla/icecat/profiles.ini"
    ".mozilla/icecat/rgvol6f2.default/extension-preferences.json"
    ".mozilla/icecat/rgvol6f2.default/extensions"

    ".librewolf/native-messaging-hosts"
    ".librewolf/profiles.ini"
    ".librewolf/profile0/extension-preferences.json"
    ".librewolf/profile0/extensions"

    ".local/share/ice/icons"
    "%.local/share/ice/firefox/invidious/extension-preferences.json"
    "%.local/share/ice/firefox/invidious/extensions"

    ".config/tridactyl"

    ".config/omf"
    ".local/share/omf"
)


# If path starts with %, will not override
COPY_FROM_TO=(
    ".config/chromium/Default/Preferences"
    "%.config/chromium/Default/Cookies"
    ".config/chromium/Local State"
    ".config/chromium-flags.conf"
    ".config/tutanota-desktop/conf.json"
    ".config/discord/settings.json"
    ".config/FreeTube/settings.db"
    ".local/share/PrismLauncher/multimc.cfg"
    ".config/gtk-2.0"
    ".config/gtk-3.0"
    ".config/gtk-4.0"
    ".config/qt5ct"
    ".config/kdeglobals"
    ".config/keepassxc"
    ".local/share/applications/tutanota-desktop.desktop"
    ".local/share/applications/arch-update.desktop"
    ".local/share/applications/invidious.desktop"


    "%.mozilla/icecat/rgvol6f2.default/prefs.js"
    "%.mozilla/icecat/rgvol6f2.default/search.json.mozlz4"
    "%.mozilla/icecat/rgvol6f2.default/storage"
    "%.mozilla/icecat/rgvol6f2.default/storage.sqlite"
    "%.mozilla/icecat/rgvol6f2.default/cookies.sqlite"
    "%.mozilla/icecat/rgvol6f2.default/extension-settings.json"
    "%.mozilla/icecat/rgvol6f2.default/extensions.json"
    "%.mozilla/icecat/rgvol6f2.default/sessionCheckpoints.json"

    "%.librewolf/profile0/prefs.js"
    "%.librewolf/profile0/search.json.mozlz4"
    "%.librewolf/profile0/storage"
    "%.librewolf/profile0/storage.sqlite"
    "%.librewolf/profile0/cookies.sqlite"
    "%.librewolf/profile0/extension-settings.json"
    "%.librewolf/profile0/extensions.json"
    "%.librewolf/profile0/sessionCheckpoints.json"

    "%.local/share/ice/firefox/invidious/prefs.js"
    "%.local/share/ice/firefox/invidious/search.json.mozlz4"
    "%.local/share/ice/firefox/invidious/storage"
    "%.local/share/ice/firefox/invidious/storage.sqlite"
    "%.local/share/ice/firefox/invidious/cookies.sqlite"
    "%.local/share/ice/firefox/invidious/extension-settings.json"
    "%.local/share/ice/firefox/invidious/extensions.json"
    "%.local/share/ice/firefox/invidious/sessionCheckpoints.json"
    "%.local/share/ice/firefox/invidious/user.js"
    "%.local/share/ice/firefox/invidious/chrome"
)

LINK_HOME_DIRS=(
    ".config"
    ".local"
    "Documents"
    "Downloads"
    "Pictures"
    "Videos"
    "Programming"
    "VM"
    "Games"
    "Temp"
    "Music"
    ".mozilla"
)

LGREEN='\033[1;32m'
GREEN='\033[0;32m'
LBLUE='\033[1;34m'
NC='\033[0m' 

function confirm() {
	echo -en "$LBLUE |||$GREEN Do you want to override ${LGREEN}$1 $2 $3 $LBLUE(Y/n)? >> $NC"
	if [ ! -z $YOLO ] && [ $YOLO -eq 1 ]; then
		echo "y"
		rm -rf "$1"
		return
	fi
	read choice
	case "$choice" in 
	y|Y|"" ) rm -rf "$1";;
	n|N ) return;;
	* ) confirm $1 $2 $3; return;;
	esac
}

mkdir -p $USER_HOME
mkdir -p $FAKE_USER_HOME

for dir in "${LINK_HOME_DIRS[@]}"; do
	DEST="$USER_HOME/$dir"
	if [ -h "$DEST" ]; then unlink "$DEST"; fi
	if [ -e "$DEST" ]; then confirm $DEST; fi
	mkdir -p $FAKE_USER_HOME/$dir
	ln -sfT $FAKE_USER_HOME/$dir $DEST
done

for ((i = 0; i < ${#SYMLINK_FROM_TO[@]}; i++)); do
    path="${SYMLINK_FROM_TO[$i]}"
	override=1
	if [[ "$path" = %* ]]; then override=0; path="${path:1}"; fi
	from="$DOTFILES_DIR/dotfiles/$path"
	dest="$USER_HOME/$path"

	if [ $override -eq 1 ] || [ ! -e "$dest" ]; then
        	if [ -h "$dest" ]; then unlink "$dest"; fi
        	if [ -e "$dest" ]; then confirm "$dest"; fi

	        mkdir -p "$(dirname $dest| head --lines 1)"
	        ln -sfT "$from" "$dest"
		    chown -R $USER1:$USER1 "$dest"
    	fi
done

for ((i = 0; i < ${#COPY_FROM_TO[@]}; i++)); do
    path="${COPY_FROM_TO[$i]}"
	override=1
	if [[ "$path" = %* ]]; then override=0; path="${path:1}"; fi
	from="$DOTFILES_DIR/dotfiles/$path"
	dest="$USER_HOME/$path"

	if [ $override -eq 1 ] || [ ! -e "$dest" ]; then
        	if [ -h "$dest" ]; then unlink "$dest"; fi
        	if [ -e "$dest" ]; then confirm "$dest"; fi

	        mkdir -p "$(dirname $dest| head --lines 1)"
	        cp -rf "$from" "$dest"
		chown -R $USER1:$USER1 "$dest"
    	fi
done



ESCAPED_USER_HOME=$(printf '%s\n' "$USER_HOME" | sed -e 's/[\/&]/\\&/g')
sed -i "s/USER_HOME/$ESCAPED_USER_HOME/g" $USER_HOME/.local/share/PrismLauncher/multimc.cfg
ESCAPED_HOSTNAME=$(printf '%s\n' "$(hostname)" | sed -e 's/[\/&]/\\&/g')
sed -i "s/HOSTNAME/$ESCAPED_HOSTNAME/g" $USER_HOME/.local/share/PrismLauncher/multimc.cfg

sed -i "s/USER_HOME/$ESCAPED_USER_HOME/g" $USER_HOME/.local/share/applications/invidious.desktop
sed -i "s/USER_HOME/$ESCAPED_USER_HOME/g" $USER_HOME/.local/share/applications/arch-update.desktop

cp $USER_HOME/.config/dotfiles/scripts/update-arch.sh-tofill $USER_HOME/.config/dotfiles/scripts/update-arch.sh
sed -i "s/USER_HOME/$ESCAPED_USER_HOME/g" $USER_HOME/.config/dotfiles/scripts/update-arch.sh




chmod +x $USER_HOME/.config/awesome/run/run.sh
chmod +x $USER_HOME/.config/at_login.sh
chmod +x $USER_HOME/.config/dotfiles/scripts/*.sh



# Update nvim plugins
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' > /dev/null 2>&1 &
# Update omf
omf update > /dev/null 2>&1 &

