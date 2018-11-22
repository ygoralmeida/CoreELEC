# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="lr-fbalpha"
PKG_VERSION="da8864302899161b66ca059b743087a035eb33fa"
PKG_SHA256="e2e31b82604bba64e74cc5e5c94edd0cf2e387a83b35ca1e77ce80c18c9c349c"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/fbalpha"
PKG_URL="https://github.com/libretro/fbalpha/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain retroarch"
PKG_LONGDESC="Port of Final Burn Alpha to Libretro (pre-v0.2.97.44)."
PKG_TOOLCHAIN="manual"

PKG_LIBNAME="fbalpha_libretro.so"
PKG_LIBPATH="$PKG_LIBNAME"

make_target() {
  if [ "$PROJECT" = "Amlogic" ]; then
    make -f makefile.libretro platform=rpi3 CC=$CC CXX=$CXX GIT_VERSION=${PKG_VERSION:0:7}

  elif [ "$PROJECT" = "RPi" ]; then
    case $DEVICE in
      RPi)
        make -f makefile.libretro platform=armv CC=$CC CXX=$CXX GIT_VERSION=${PKG_VERSION:0:7}
        ;;
      RPi2)
        make -f makefile.libretro platform=rpi2 CC=$CC CXX=$CXX GIT_VERSION=${PKG_VERSION:0:7}
        ;;
    esac

  else
    make -f makefile.libretro CC=$CC CXX=$CXX GIT_VERSION=${PKG_VERSION:0:7}
  fi
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_LIBPATH $INSTALL/usr/lib/libretro/
}
