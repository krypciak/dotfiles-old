#!/bin/sh
DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

USER_HOME="/home/$USER1"

DIRS=(
    #".mozilla/icecat/rgvol6f2.default/prefs.js"
    #".mozilla/icecat/rgvol6f2.default/search.json.mozlz4"
    #".mozilla/icecat/rgvol6f2.default/storage.sqlite"
    #".mozilla/icecat/rgvol6f2.default/cookies.sqlite"
    #".mozilla/icecat/rgvol6f2.default/extension-settings.json"
    #".mozilla/icecat/rgvol6f2.default/extensions.json"
    #".mozilla/icecat/rgvol6f2.default/sessionCheckpoints.json"

    ".librewolf/profile0/prefs.js"
    ".librewolf/profile0/search.json.mozlz4"
    ".librewolf/profile0/storage.sqlite"
    ".librewolf/profile0/cookies.sqlite"
    ".librewolf/profile0/extension-settings.json"
    ".librewolf/profile0/extensions.json"
    ".librewolf/profile0/sessionCheckpoints.json"

    #".local/share/ice/firefox/invidious/prefs.js"
    #".local/share/ice/firefox/invidious/search.json.mozlz4"
    #".local/share/ice/firefox/invidious/storage"
    #".local/share/ice/firefox/invidious/storage.sqlite"
    #".local/share/ice/firefox/invidious/cookies.sqlite"
    #".local/share/ice/firefox/invidious/extension-settings.json"
    #".local/share/ice/firefox/invidious/extensions.json"
    #".local/share/ice/firefox/invidious/sessionCheckpoints.json"
    #".local/share/ice/firefox/invidious/user.js"
    #".local/share/ice/firefox/invidious/chrome"
)

echo "Syncing..."

for ((i = 0; i < ${#DIRS[@]}; i++)); do
    path="${DIRS[$i]}"
	override=1
	if [[ "$path" = %* ]]; then override=0; path="${path:1}"; fi
	from="$USER_HOME/$path"
	dest="$DOTFILES_DIR/dotfiles/$path"

	if [ $override -eq 1 ] || [ ! -e "$dest" ]; then
        	#if [ -h "$dest" ]; then unlink "$dest"; fi
        	#if [ -e "$dest" ]; then confirm "$dest"; fi

	        mkdir -p "$(dirname $dest| head --lines 1)"
	        cp -rf "$from" "$dest"
		    chown -R $USER1:$USER1 "$dest"
    	fi
done

for (( i=0; i<${#DIRS[@]}; i+=2 )); do
    T1=${DIRS[i]}
    T2=${DIRS[$(expr $i + 1)]}
    
    FROM="$USER_HOME/$T2/$T1"
    DEST="$DOTFILES_DIR/dotfiles/$T1"

    mkdir -p "$(dirname $DEST | head --lines 1)"
	cp -rf "$FROM" "$DEST"
	chown -R $USER1:$USER1 "$DEST"
done


