#!/bin/bash

set -e
set -a


_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd | xargs realpath )
OFFLINE_DIR=$(dirname $_DIR)
PACKAGES_DIR=$(dirname $OFFLINE_DIR)

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

if [ ! -f $_DIR/deplist.txt ]; then 
    doas rm -f /tmp/aurpackages
    doas rm -rf /tmp/blankdb
    doas mkdir -p /tmp/blankdb
    doas pacman --dbpath /tmp/blankdb -Sy

    echo 'Builidng dependency list...'
    PACMAN="$(echo $PACKAGES | xargs -n 1 pactree --dbpath /tmp/blankdb -s -u -l 2>> $_DIR/aurpackages.txt | sort --unique | xargs)"
    echo $PACMAN > $_DIR/deplist.txt
else
    PACMAN=$(cat $_DIR/deplist.txt)
fi
echo $PACMAN


echo -e '\nBuild aur package list...'
if [ ! -f $_DIR/aurpackages.txt ]; then
    echo "$(paru -Pc | awk '{print $1}')" > /tmp/allaur
    PACKAGES_GREP_ARGS="$(echo $PACKAGES | tr ' ' '\n' | awk '{print "-e " $1 }' | xargs)"
    AUR="$(grep -x -e $PACKAGES_GREP_ARGS /tmp/allaur | grep -v -x -e $(pacman -Sl | awk '{print "-e \"" $2 "\""}' | xargs))"
    rm /tmp/allaur
else
    AUR="$(cat aurpackages.txt | awk '{print substr($0, 17, length($0)-27)}' | xargs)"
fi
echo $AUR


echo -e '\nCopying official packages...'
mkdir -p $_DIR/packages
GREP_OFFICIAL_COPY="$(echo $PACMAN | tr ' ' '\n' | awk '{print "-e ^" $1 "-"}' | xargs)"
cd /var/cache/pacman/pkg
ls *.pkg.tar.zst -1 | grep -E -e $GREP_OFFICIAL_COPY | awk '{print "/var/cache/pacman/pkg/" $1}' | xargs -I _ cp _ $_DIR/packages/
echo -e 'Done.\n'


echo 'Downloading missing packages...'
#doas rm -rf /tmp/blankdb
mkdir -p /tmp/blankdb
cd $_DIR/packages
doas pacman --config /etc/pacman.conf --noconfirm -Syw --dbpath /tmp/blankdb --cachedir . $PACMAN
doas chown -R $USER1:$USER1 $_DIR/packages
doas rm -rf /tmp/blankdb

echo 'Copying AUR packages...'
GREP_AUR_COPY="$(echo $AUR | tr ' ' '\n' | awk '{print "-e " $1 }' | xargs)"
ls /home/$USER1/.cache/paru/clone/ -1 | grep -E -e $GREP_AUR_COPY | awk "{printf(\"/home/$USER1/.cache/paru/clone/%s/\", \$1); system(\"pacman -Qi \$AUR | grep -E 'Version|Name|Architecture' | awk '{print \$3}' | grep -A 2 \" \$1 \" | xargs | tr ' ' '-' | head -c -1\"); printf(\".pkg.tar.zst\n\")}" | xargs -I _ cp _ $_DIR/packages/

echo 'Creating a repo...'
rm -f $_DIR/packages/offline.db.tar.gz
repo-add --quiet $_DIR/packages/offline.db.tar.gz $_DIR/packages/*.pkg.tar.zst

