#!/bin/sh

function unmount() {
    sync
    swapoff -a > /dev/null 2>&1
    umount -q $BOOT_PART > /dev/null 2>&1
    umount -Rq $INSTALL_DIR > /dev/null 2>&1
    swapoff $LVM_DIR/swap > /dev/null 2>&1
    lvchange -an $LVM_GROUP_NAME > /dev/null 2>&1
    cryptsetup close $CRYPT_FILE> /dev/null 2>&1
    umount -q $CRYPT_FILE> /dev/null 2>&1
    sync
}

fdisk -l $DISK > $OUTPUT
confirm "Start partitioning the disk (${DISK})? $RED(DATA WARNING)"
info "Unmouting"

unmount 
vgremove -f $LVM_GROUP_NAME > /dev/null 2>&1
unmount

(
echo g # set partitioning scheme to GPT
echo n # Create BOOT partition
echo 1 # partition number 1
echo   # default - start at beginning of disk 
echo +${BOOT_SIZE}
echo t # set partition type
echo 1 # to EFI partition
echo n # Create LVM partition
echo 2 # partion number 2
echo " "  # default, start immediately after preceding partition
if [ "$ENCRYPT" == '1' ]; then
    if [ "$CRYPT_SIZE" == '' ]; then 
        echo 
    else 
        echo +${CRYPT_SIZE}
    fi
else
    if [ "$LVM_SIZE" == '' ]; then 
        echo 
    else 
        echo +${LVM_SIZE}
    fi
fi
echo t # set partition type
echo 2
echo 43 # to LV
echo p # print the in-memory partition table
echo w # write changes
echo q # quit
) | fdisk $DISK > $OUTPUT


mkdir -p $INSTALL_DIR

if [ "$ENCRYPT" == '1' ]; then
    confirm "Setup luks on ${CRYPT_PART}? $RED(DATA WARNING)"
    if [ "$LUKS_PASSWORD" != '' ]; then
        info "${NC}Automaticly filling password..."

        echo $LUKS_PASSWORD | cryptsetup luksFormat $LUKSFORMAT_ARGUMENTS $CRYPT_PART > $OUTPUT
        if [ $? -ne 0 ]; then err "LUKS error."; exit 1; fi

        info "Opening $CRYPT_PART as $CRYPT_NAME"
        info "${NC}Automaticly filling password..."
        echo $LUKS_PASSWORD | cryptsetup open $CRYPT_PART $CRYPT_NAME > $OUTPUT
        if [ $? -ne 0 ]; then err "LUKS error."; exit 1; fi
    else
        while true; do
            info "Setting up luks on $CRYPT_PART $RED(DATA WARNING)"
            
            cryptsetup luksFormat $LUKSFORMAT_ARGUMENTS $CRYPT_PART
            if [ $? -eq 0 ]; then
                break
            fi
            confirm 'Do you wanna retry?' 'ignore'
        done    
        
        while true; do
            info "Opening $CRYPT_PART as $CRYPT_NAME"
            cryptsetup open $CRYPT_PART $CRYPT_NAME 
            if [ $? -eq 0 ]; then
                break
            fi
            confirm 'Do you wanna retry?' 'ignore'
        done
    fi
    LVM_TARGET_FILE="$CRYPT_FILE"
else
    LVM_TARGET_FILE="$LVM_PART"
fi

confirm "Set up LVM on ${LVM_PART}?"

info "Creating LVM group $LVM_GROUP_NAME"
pvcreate --force $LVM_TARGET_FILE > $OUTPUT
if [ $? -ne 0 ]; then err "LVM error."; exit 1; fi
vgcreate $LVM_GROUP_NAME $LVM_TARGET_FILE > $OUTPUT
if [ $? -ne 0 ]; then err "LVM error."; exit 1; fi

info "Creating volumes"
if [ "$ENABLE_SWAP" == '1' ]; then
    info "Creating SWAP"
    lvcreate -C y -L $SWAP_SIZE $LVM_GROUP_NAME -n swap > $OUTPUT
    if [ $? -ne 0 ]; then err "LVM error."; exit 1; fi
fi
info "Creating ROOT of size $ROOT_SIZE"
lvcreate -C y -L $ROOT_SIZE $LVM_GROUP_NAME -n root > $OUTPUT
if [ $? -ne 0 ]; then err "LVM error."; exit 1; fi

info "Creating HOME of size 100%FREE"
lvcreate -C y -l 100%FREE $LVM_GROUP_NAME -n home > $OUTPUT
if [ $? -ne 0 ]; then err "LVM error."; exit 1; fi

info "Formatting volumes"
if [ "$ENABLE_SWAP" == '1' ]; then
    info "SWAP"
    mkswap -L swap $LVM_DIR/swap > $OUTPUT
    if [ $? -ne 0 ]; then err "mkswap error."; exit 1; fi
fi

info "ROOT"
$ROOT_FORMAT_COMMAND > /dev/null 2>&1
if [ $? -ne 0 ]; then err "format error."; exit 1; fi

info "HOME"
$HOME_FORMAT_COMMAND > /dev/null 2>&1
if [ $? -ne 0 ]; then err "format error."; exit 1; fi

info "BOOT"
$BOOT_FORMAT_COMMAND 
if [ $? -ne 0 ]; then err "format error."; exit 1; fi


info "Mounting ${LBLUE}$LVM_DIR/root ${LGREEN}to ${LBLUE}$INSTALL_DIR/"
mount $LVM_DIR/root $INSTALL_DIR/ > $OUTPUT
if [ $? -ne 0 ]; then err "mount error."; exit 1; fi

info "Mounting ${LBLUE}$LVM_DIR/home${LGREEN} to ${LBLUE}$INSTALL_DIR/home/$USER1/"
mkdir -p $INSTALL_DIR/home/$USER1
mount $LVM_DIR/home $INSTALL_DIR/home/$USER1/ > $OUTPUT
if [ $? -ne 0 ]; then err "mount error."; exit 1; fi

info "Mounting ${LBLUE}${BOOT_PART}${LGREEN} to ${LBLUE}$BOOT_DIR"
mkdir -p $BOOT_DIR
mount $BOOT_PART $BOOT_DIR > $OUTPUT
if [ $? -ne 0 ]; then err "mount error."; exit 1; fi

if [ "$ENABLE_SWAP" == '1' ]; then
    info "Turning swap on"
    swapon $LVM_DIR/swap > $OUTPUT
    if [ $? -ne 0 ]; then err "swap error."; exit 1; fi
fi

source $SCRIPTS_DIR/chroot.sh

if [ $AUTO_REBOOT -eq 0 ]; then
    confirm "Reboot?" "ignore"
fi
unmount
reboot

