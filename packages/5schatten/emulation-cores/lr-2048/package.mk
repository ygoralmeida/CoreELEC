# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="lr-2048"
PKG_VERSION="82843002384e8d9b495f80acdee8bdf0e2bde74c"
PKG_SHA256="1676cdf0479b31b0827ce9eac54630493b7dc76b007716f24b4fb5bde12ec858"
PKG_LICENSE="Public domain"
PKG_SITE="https://github.com/libretro/libretro-2048"
PKG_URL="https://github.com/libretro/libretro-2048/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain retroarch"
PKG_LONGDESC="Port of 2048 puzzle game to the libretro API."

PKG_LIBNAME="2048_libretro.so"
PKG_LIBPATH="$PKG_LIBNAME"

make_target() {
  make -f Makefile.libretro GIT_VERSION=${PKG_VERSION:0:7}
}

makeinstall_target() {
  #create Retroarch Playlist
  mkdir -p $INSTALL/usr/config
  mkdir -p $INSTALL/usr/config/retroarch
  mkdir -p $INSTALL/usr/config/retroarch/playlists
  cp $PKG_DIR/files/* $INSTALL/usr/config/retroarch/playlists

  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_LIBPATH $INSTALL/usr/lib/libretro/
}
