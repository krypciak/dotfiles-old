#!/bin/bash

info 'Copying common configs'
printf "$LBLUE"
cp -r $COMMON_ROOT_DIR/* / > $OUTPUT
printf "$NC"

info "Copying $VARIANT configs"
printf "$LBLUE"
cp -r $VARIANT_ROOT_DIR/* / > $OUTPUT
printf "$NC"

