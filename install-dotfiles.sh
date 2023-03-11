#~/bin/sh

USER_HOME="/home/$USER1"
FAKE_USER_HOME="$USER_HOME/home"

DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SYMLINK_FROM_TO=(
    # Simple symlink ln -sf
    # basic terminal stuff
    ".config/at_login.sh"
    ".config/nvim"
    ".config/fish"
    ".config/tealdeer"
    ".bashrc"
    ".config/xsessions"
    # specific terminal apps
    ".config/neofetch"
    ".config/topgrade.toml"
    ".config/ttyper"
    ".config/animdl"
    # gui apps
    ".config/alacritty"
    ".config/wallpapers"
    ".config/cmus/autosave"
    ".config/cmus/red_theme.theme"
    ".config/cmus/notify.sh"
    # X11 apps
    ".xinitrc"
    ".config/awesome"
    ".config/redshift"
    ".config/copyq"
    ".config/rofi"
    # wayland
    ".config/dwl"
    ".config/gammastep"
    ".config/fuzzel"
    ".config/swaylock"
    # Ungoogled chromium
    ".config/chromium/Default/Extensions"
    ".config/chromium/Default/Sync Extension Settings"
    ".config/chromium/Default/Managed Extension Settings"
    ".config/chromium/Default/Local Extension Settings"
    # Discord
    ".config/BetterDiscord/plugins"
    # Librewolf
    ".librewolf/native-messaging-hosts"
    ".librewolf/profiles.ini"
    ".librewolf/profile0/extension-preferences.json"
    ".librewolf/profile0/extensions"
    ".config/tridactyl"
    # Plasma
    ".config/gtkrc"
    ".config/gtkrc-2.0"
    ".config/krunnerrc"
    ".config/plasmarc"
    ".config/plasmashellrc"
)

COPY_FROM_TO=( 
    # If path starts with %, will not override
    # Theming
    ".config/gtk-2.0"
    ".config/gtk-3.0"
    ".config/gtk-4.0"
    ".config/qt5ct"
    ".config/kdeglobals"
    # Tutanota desktop (mail client)
    ".config/tutanota-desktop/conf.json"
    # Discord
    ".config/discord/settings.json"
    # FreeTube (youtube client)
    ".config/FreeTube/settings.db"
    # PrismLauncher (minecraft launcher)
    ".local/share/PrismLauncher/multimc.cfg"
    # Keepassxc (password manager)
    ".config/keepassxc"
    # .desktop files
    ".local/share/applications/tutanota-desktop.desktop"
    ".local/share/applications/arch-update.desktop"
    # Librewolf
    "%.librewolf/profile0/prefs.js"
    "%.librewolf/profile0/search.json.mozlz4"
    "%.librewolf/profile0/storage"
    "%.librewolf/profile0/storage.sqlite"
    "%.librewolf/profile0/cookies.sqlite"
    "%.librewolf/profile0/extension-settings.json"
    "%.librewolf/profile0/extensions.json"
    "%.librewolf/profile0/sessionCheckpoints.json"
    # Ungoogled chromium
    ".config/chromium/Default/Preferences"
    "%.config/chromium/Default/Cookies"
    ".config/chromium/Local State"
    ".config/chromium-flags.conf"
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

