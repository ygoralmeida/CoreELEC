# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="lr-nestopia"
PKG_VERSION="28aa27ccd6a44cf8e1e406b58356a8d0bb646834"
PKG_SHA256="ea0d16236355f67c9b16aca47415ca19f713adfa87371d82e7e96e09ce83ecbe"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/nestopia"
PKG_URL="https://github.com/libretro/nestopia/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain retroarch"
PKG_LONGDESC="This project is a fork of the original Nestopia source code, plus the Linux port. The purpose of the project is to enhance the original, and ensure it continues to work on modern operating systems."
PKG_TOOLCHAIN="manual"

PKG_LIBNAME="nestopia_libretro.so"
PKG_LIBPATH="libretro/$PKG_LIBNAME"

post_unpack() {
  rm $PKG_BUILD/configure.ac
}

make_target() {
  if [ "$PROJECT" = "RPi" ]; then
    make -C libretro platform=rpi2 GIT_VERSION=${PKG_VERSION:0:7}
  else
    make -C libretro GIT_VERSION=${PKG_VERSION:0:7}
  fi
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_LIBPATH $INSTALL/usr/lib/libretro/
}
