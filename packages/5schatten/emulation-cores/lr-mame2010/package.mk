# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="lr-mame2010"
PKG_VERSION="70732f9137f6bb2bde4014746ea8bc613173dd1e"
PKG_SHA256="36ab11541233c9a4240baf6f0a529d8d335dce23f25b66b950e18373fd8e65fb"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/mame2010-libretro"
PKG_URL="https://github.com/libretro/mame2010-libretro/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain retroarch"
PKG_LONGDESC="Late 2010 version of MAME (0.139) for libretro. Compatible with MAME 0.139 romsets."

PKG_LIBNAME="mame2010_libretro.so"
PKG_LIBPATH="$PKG_LIBNAME"

pre_make_target() {
  export CFLAGS="$CFLAGS -fpermissive"
  export CXXFLAGS="$CXXFLAGS -fpermissive"
  export LD="$CXX"
}

make_target() {
  case $TARGET_CPU in
    arm1176jzf-s)
      make platform=armv6-hardfloat-$TARGET_CPU GIT_VERSION=${PKG_VERSION:0:7}
      ;;
    cortex-a7|cortex-a9)
      make platform=armv7-neon-hardfloat-$TARGET_CPU GIT_VERSION=${PKG_VERSION:0:7}
      ;;
    *cortex-a53|cortex-a17)
      if [ "$TARGET_ARCH" = "aarch64" ]; then
        make platform=aarch64 GIT_VERSION=${PKG_VERSION:0:7}
      else
        make platform=armv7-neon-hardfloat-cortex-a9 GIT_VERSION=${PKG_VERSION:0:7}
      fi
      ;;
    x86-64)
      make GIT_VERSION=${PKG_VERSION:0:7}
      ;;
  esac
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_LIBPATH $INSTALL/usr/lib/libretro/
}
