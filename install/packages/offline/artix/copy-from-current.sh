#!/bin/bash

#set -e
set -a


_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd | xargs realpath )
OFFLINE_DIR=$(dirname $_DIR)
PACKAGES_DIR=$(dirname $OFFLINE_DIR)

export -f _clean_cache
doas sh -c "\
    echo 'Updaing system'; \
    pacman --noconfirm -Syu; \
    echo 'Removing cache'; \
    paccache -rk 1; \
    paru --noconfirm -Sc; \
    echo -e 'Done.\n\n'; \
"

PACKAGE_GROUPS=(
    'bare'      
    'drivers'   
    'basic'     
    'gui'       
    'audio'     
    'media'     
    'browsers'  
    'office'    
    'X11'       
    'awesome'   
    'wayland'   
    'dwl'       
    'coding'    
    'fstools'   
    'gaming'    
    'security'  
    'social'    
    'misc'      
    'bluetooth' 
    'virt'      
    'android'   
    'baltie'    
)

PACKAGES="$(sh $PACKAGES_DIR/get-package-names.sh)"
PACKAGES_GREP_ARGS="$(echo $PACKAGES | tr ' ' '\n' | awk '{print "-e \"" $1 "\""}' | xargs)"

echo "$(pacman -Sl | awk '{print $2}')" > /tmp/allpacman
PACMAN="$(grep -x -e  $PACKAGES_GREP_ARGS /tmp/allpacman)"
rm /tmp/allpacman

echo "$(paru -Pc | awk '{print $1}')" > /tmp/allaur
AUR="$(grep -x -e $PACKAGES_GREP_ARGS /tmp/allaur | grep -v -x -e $(pacman -Sl | awk '{print "-e \"" $2 "\""}' | xargs))"
rm /tmp/allaur


echo 'Copying official packages...'
mkdir -p $_DIR/official
GREP_OFFICIAL_COPY="$(echo $PACMAN | tr ' ' '\n' | awk '{print "-e ^" $1 "-"}' | xargs)"
cd /var/cache/pacman/pkg
ls *.pkg.tar.zst -1 | grep -E -e $GREP_OFFICIAL_COPY | awk '{print "/var/cache/pacman/pkg/" $1}' | xargs -I _ cp _ $_DIR/official/
echo -e 'Done.\n'

echo 'Copying AUR packages...'
mkdir -p $_DIR/aur
GREP_AUR_COPY="$(echo $AUR | tr ' ' '\n' | awk '{print "-e " $1 }' | xargs)"
ls /home/$USER1/.cache/paru/clone/ -1 | grep -E -e $GREP_AUR_COPY | awk "{printf(\"/home/$USER1/.cache/paru/clone/%s/\", \$1); system(\"pacman -Qi \$AUR | grep -E 'Version|Name|Architecture' | awk '{print \$3}' | grep -A 2 \" \$1 \" | xargs | tr ' ' '-' | head -c -1\"); printf(\".pkg.tar.zst\n\")}" | xargs -I _ cp _ $_DIR/aur/
