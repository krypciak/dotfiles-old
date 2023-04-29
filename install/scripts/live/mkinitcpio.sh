#!/bin/sh

info "Generating initcpio"
mkinitcpio -P > $OUTPUT 2>&1
