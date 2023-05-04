#!/bin/bash

# github-desktop-bin
artix_install_coding() {
    echo 'eclipse-java git-filter-repo jdk17-openjdk jdk8-openjdk jdk-openjdk jre-openjdk jre-openjdk-headless rust shellcheck'
}

arch_install_coding() {
    echo 'eclipse-java git-filter-repo jdk17-openjdk jdk8-openjdk jdk-openjdk jre-openjdk jre-openjdk-headless rust shellcheck'
}

artix_configure_coding() {
    archlinux-java set java-17-openjdk
}

arch_configure_coding() {
    archlinux-java set java-17-openjdk
}

