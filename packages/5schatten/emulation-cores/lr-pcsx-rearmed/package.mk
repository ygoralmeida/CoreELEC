# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="lr-pcsx-rearmed"
PKG_VERSION="28ea3e2d87c4e239d8853b10c4496f82feb9d982"
PKG_SHA256="521c4e22bf3b43dfaa0511046adde08daeb1565092f0f93794bd55cf2caac5e0"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/pcsx_rearmed"
PKG_URL="https://github.com/libretro/pcsx_rearmed/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain retroarch"
PKG_LONGDESC="PCSX ReARMed is yet another PCSX fork based on the PCSX-Reloaded project, which itself contains code from PCSX, PCSX-df and PCSX-Revolution. "
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="-gold"

PKG_LIBNAME="pcsx_rearmed_libretro.so"
PKG_LIBPATH="$PKG_LIBNAME"

make_target() {
  cd $PKG_BUILD
  
  if [[ "$TARGET_FPU" =~ "neon" ]]; then
    make -f Makefile.libretro HAVE_NEON=1 USE_DYNAREC=1 BUILTIN_GPU=neon GIT_VERSION=${PKG_VERSION:0:7}
  elif [ "$ARCH" = "arm" ]; then
    make -f Makefile.libretro HAVE_NEON=0 USE_DYNAREC=1 GIT_VERSION=${PKG_VERSION:0:7}
  else
    make -f Makefile.libretro GIT_VERSION=${PKG_VERSION:0:7}
  fi
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_LIBPATH $INSTALL/usr/lib/libretro/
}
