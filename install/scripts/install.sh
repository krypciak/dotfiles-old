#!/bin/bash
set -a

SCRIPTS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd | xargs realpath )
source "$SCRIPTS_DIR/common.sh"


_help() {
    echo '  Usage:'
    echo '  --disk or --live or --dir DIRECTORY'
    echo '  --variant   artix, arch'
    echo '  --iso       for iso installs'
    echo '  --offline   for offline installs'
    echo '  --quiet     silence a lot of output'
    exit 2
}

if [ ! -f $SCRIPTS_DIR/vars.conf.sh ]; then
    err "Config file vars.conf.sh doesn't exist."
    exit 3
fi

if [ "$(whoami)" != 'root' ]; then
    err "This script needs to be run as root."
    exit 1
fi

SHORT=""
LONG="live,disk,dir:,variant:,iso,offline,quiet"
OPTS=$(getopt --alternative --name install --options "$SHORT" --longoptions "$LONG" -- "$@") 
if [ $? != '0' ]; then
    exit
fi

MODE='null'
VARIANT='null'
TYPE='normal'
NET='online'
QUIET=0

OUTPUT='/dev/stdout'

eval set -- "$OPTS"

while [ : ]; do
  case "$1" in
    --live)
        MODE='live'
        shift 1
        ;;
    --disk)
        MODE='disk'
        shift 1
        ;;
    --dir)
        MODE='dir'
        INSTALL_DIR="$2"
        shift 2
        ;;
    --variant)
        VARIANT="$2"
        shift 2
        ;;
    --iso)
        TYPE='iso'
        shift 1
        ;;
    --offline)
        NET='offline'
        shift 1
        ;;
    --quiet)
        QUIET=1
        OUTPUT='/dev/null'
        shift 1
        ;;
    --)
      shift;
      break
      ;;
    *)
      echo "Unexpected option: $1"
      exit
      ;;
  esac
done


if [ "$MODE" != 'live' ] && [ "$MODE" != 'disk' ] && [ "$MODE" != 'dir' ]; then
    echo '--mode argument is required.'; _help
fi

if [ "$VARIANT" == 'artix' ]; then
    if [ "$TYPE" == 'normal' ]; then
        VARIANT_NAME="Artix"
    elif [ "$TYPE" == 'iso' ]; then
        VARIANT_NAME="Artix ISO"
    fi

elif [ "$VARIANT" == 'arch' ]; then
    if [ "$TYPE" == 'normal' ]; then
        VARIANT_NAME="Arch"
    elif [ "$TYPE" == 'iso' ]; then
        VARIANT_NAME="Arch ISO"
    fi
elif [ "$VARIANT" == 'null' ]; then
    echo '--variant is required.'; _help
else
    echo 'Invalid variant.'; _help
fi

info "${GREEN}Mode: ${LBLUE}$MODE  ${GREEN}Variant: ${LBLUE}$VARIANT  ${GREEN}Type: ${LBLUE}$TYPE  ${GREEN}Net: ${LBLUE}$NET"

source "$SCRIPTS_DIR/vars.conf.sh"


if [ "$MODE" == 'live' ]; then
    source $SCRIPTS_DIR/live/live.sh

elif [ "$MODE" == 'disk' ]; then
    source $SCRIPTS_DIR/disk.sh

elif [ "$MODE" == 'dir' ]; then
    source $SCRIPTS_DIR/chroot.sh
fi


