#!/bin/bash

info "Creating temporary doas config"
echo "permit nopass setenv { YOLO USER1 USER_GROUP PACMAN_ARGUMENTS PARU_ARGUMENTS PACKAGE_LIST _configure_discord1 } root" > /etc/doas.conf
echo "permit nopass setenv { YOLO USER1 USER_GROUP PACMAN_ARGUMENTS PARU_ARGUMENTS PACKAGE_LIST _configure_discord1 } $USER1" >> /etc/doas.conf

