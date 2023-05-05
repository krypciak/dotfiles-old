#!/bin/bash
set -a

SCRIPTS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd | xargs realpath )
source "$SCRIPTS_DIR/common.sh"


_help() {
    printf ' Usage:\n'
    printf '  --disk or \n    --live or \n    --dir DIRECTORY or\n    --iso=ISO_OUT_DIR\n'
    printf '  --variant      artix, arch\n'
    printf '  --offline      install packages from disk\n'
    printf '  --quiet        silence a lot of output\n'
    printf ' Iso options:\n'
    printf '  --iso-copy-to  copy the iso to that dir and delete all previous iso'
    printf '  --wait-for-dir dont start iso build until that dir is mounted'
    exit 2
}

if [ "$(whoami)" != 'root' ]; then
    err "This script needs to be run as root."
    exit 1
fi

SHORT=""
LONG="live,disk,dir:,variant:,iso:,offline,quiet,iso-copy-to:,wait-for-dir:"
OPTS=$(getopt --alternative --name install --options "$SHORT" --longoptions "$LONG" -- "$@") 

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
        MODE='iso'
        ISO_OUT_DIR="$2"
        shift 2
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
    --iso-copy-to)
        ISO_COPY_TO_DIR="$2"
        shift 2
        ;;
    --wait-for-dir)
        ISO_WAIT_FOR_DIR="$2"
        shift 2
        ;;
    --)
      shift;
      break
      ;;
    *)
      echo "Unexpected option: $1"
      exit 1
      ;;
  esac
done


if [ "$MODE" != 'live' ] && [ "$MODE" != 'disk' ] && [ "$MODE" != 'dir' ] && [ "$MODE" != 'iso' ]; then
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

if [ "$MODE" = 'iso' ]; then
    if [ ! -f "$SCRIPTS_DIR/vars.conf.iso.sh" ]; then
        err "Config file vars.conf.iso.sh doesn't exist."
        exit 3
    fi
    . "$SCRIPTS_DIR/vars.conf.iso.sh"
else
    if [ ! -f "$SCRIPTS_DIR/vars.conf.sh" ]; then
        err "Config file vars.conf.sh doesn't exist."
        exit 3
    fi
    . "$SCRIPTS_DIR/vars.conf.sh"
fi


if [ "$MODE" == 'live' ]; then
    source $SCRIPTS_DIR/live/live.sh

elif [ "$MODE" == 'iso' ]; then
    source $SCRIPTS_DIR/iso.sh

elif [ "$MODE" == 'disk' ]; then
    source $SCRIPTS_DIR/disk.sh

elif [ "$MODE" == 'dir' ]; then
    source $SCRIPTS_DIR/chroot.sh
fi


