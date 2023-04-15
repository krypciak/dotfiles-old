#!/bin/bash

info 'Copying common configs'
printf "$LBLUE"
cp -rv $COMMON_ROOT_DIR/* /
printf "$NC"

info "Copying $VARIANT configs"
printf "$LBLUE"
cp -rv $VARIANT_ROOT_DIR/* /
printf "$NC"

