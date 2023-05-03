#!/bin/bash

info 'Copying iso configs'
cp -r $CONF_FILES_DIR/iso/root/* / > $OUTPUT

