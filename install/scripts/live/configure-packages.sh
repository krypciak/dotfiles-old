#!/bin/bash

for group in "${PACKAGE_GROUPS[@]}"; do
    CONFIG_FUNC="${VARIANT}_${group}_configure"
    if command -v "$CONFIG_FUNC" &> /dev/null; then
        info "Configuring $group"
        eval "$CONFIG_FUNC"
    fi
done
