#!/bin/bash
function install_gaming() {
    echo 'lutris steam jdk17-openjdk jdk8-openjdk prismlauncher-bin jdk-openjdk world/jre-openjdk world/jre-openjdk-headless wine-staging gamemode lib32-giflib lib32-mpg123 lib32-openal lib32-v4l-utils lib32-libpulse lib32-libxcomposite lib32-libxinerama lib32-opencl-icd-loader lib32-gamemode wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses ocl-icd lib32-ocl-icd libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader'
}

function configure_gaming() {
    sed -i "s/USER1/${USER1}/g" /etc/security/limits.conf
}
