# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="lr-mrboom"
PKG_VERSION="2865840b64ef97b7288ce4514effa0790ca7acbd" # v4.5
PKG_SHA256="d9ed48bdeb9aa521a8e3e0257fdf6c9e77eec68bcdc00ddbfe418346a3c14d6d"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/mrboom-libretro"
PKG_URL="https://github.com/libretro/mrboom-libretro/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain retroarch"
PKG_LONGDESC="Mr.Boom is an 8 player Bomberman clone for RetroArch/Libretro"

PKG_LIBNAME="mrboom_libretro.so"
PKG_LIBPATH="$PKG_LIBNAME"

make_target() {
  make GIT_VERSION=${PKG_VERSION:0:7}
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
