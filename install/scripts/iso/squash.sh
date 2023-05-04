#!/bin/sh
set -e

#if ${persist};then
#    make_ext_img "${sfs_in}"
#    mksfs_args+=("${work_dir}/embed")
#else

mkdir -p "$ISO_LIVEOS"

info "Generating squashfs image"
mksquashfs "$ISO_ROOTFS" "$ISO_LIVEOS"/rootfs.img -comp zstd -Xcompression-level 15 -noappend

cd "$ISO_LIVEOS"/
md5sum rootfs.img > rootfs.img.md5



