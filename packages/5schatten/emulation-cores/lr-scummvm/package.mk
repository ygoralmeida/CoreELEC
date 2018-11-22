# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="lr-scummvm"
PKG_VERSION="0daf2f441c73b0ec0b1562c3483390ade790795c"
PKG_SHA256="5420a7ad148cc83f898e597f44bb4924ff019cc40add43851782ab5c8c4524cc"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/scummvm"
PKG_URL="https://github.com/libretro/scummvm/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain retroarch"
PKG_LONGDESC="ScummVM is an interpreter for point-and-click adventure games that can be used as a libretro core."
PKG_TOOLCHAIN="manual"

PKG_LIBNAME="scummvm_libretro.so"
PKG_LIBPATH="backends/platform/libretro/build/$PKG_LIBNAME"

make_target() {
  cd $PKG_BUILD
  CXXFLAGS="$CXXFLAGS -DHAVE_POSIX_MEMALIGN=1"
  export AR="$AR cru"
  make -C backends/platform/libretro/build/ GIT_VERSION=${PKG_VERSION:0:7}
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_LIBPATH $INSTALL/usr/lib/libretro/
}
