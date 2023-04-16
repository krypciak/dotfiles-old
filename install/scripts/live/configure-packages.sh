#!/bin/bash

for group in "${PACKAGE_GROUPS[@]}"; do
    source $PACKAGES_DIR/${group}.sh
    CONFIG_FUNC="${VARIANT}_${group}_configure"
    if command -v "$CONFIG_FUNC" &> /dev/null; then
        info "Configuring $group"
        eval "$CONFIG_FUNC" > $OUTPUT
    fi
done

