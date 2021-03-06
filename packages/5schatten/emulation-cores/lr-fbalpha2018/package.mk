# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="lr-fbalpha2018"
PKG_VERSION="20daa807957d7fce64371620271b502811318163"
PKG_SHA256="15d6bfa492bb248d6b634cab8e07ec7e4b8a71f460473ecd8ac141b7978438b6"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/fbalpha2018"
PKG_URL="https://github.com/libretro/fbalpha2018/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain retroarch"
PKG_LONGDESC="Port of Final Burn Alpha to Libretro (v0.2.97.43)."
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
