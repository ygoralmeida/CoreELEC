# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="mupen64plus"
PKG_VERSION="9dd12b5a7284d0925b4ab30dd6d4abd3df2412e8"
PKG_ARCH="x86_64"
PKG_LICENSE="GPLv3"
PKG_SITE="https://m64p.github.io/"
PKG_URL="https://github.com/m64p/mupen64plus-GLideN64.git"
PKG_DEPENDS_TARGET="toolchain libpng freetype zlib SDL2-git qt-everywhere libsamplerate p7zip-system"
PKG_LONGDESC="mupen64plus + GLideN64"
GET_HANDLER_SUPPORT="git"
PKG_TOOLCHAIN="manual"

configure_target() {
  export SYSROOT_PREFIX=$SYSROOT_PREFIX
}

make_target() {

  # Build mupen64plus-core
  cd $PKG_BUILD/mupen64plus-core/projects/unix
  make -j$CONCURRENCY_MAKE_LEVEL all SHAREDIR=/usr/config/mupen64plus

  # Build mupen64plus-rsp-hle
  cd $PKG_BUILD/mupen64plus-rsp-hle/projects/unix
  make -j$CONCURRENCY_MAKE_LEVEL all

  # Build mupen64plus-rsp-cxd4
  cd $PKG_BUILD/mupen64plus-rsp-cxd4/projects/unix
  make HLEVIDEO=1 -j$CONCURRENCY_MAKE_LEVEL all

  # Build mupen64plus-input-sdl
  cd $PKG_BUILD/mupen64plus-input-sdl/projects/unix
  make -j$CONCURRENCY_MAKE_LEVEL all

  # Build mupen64plus-audio-sdl2
  cd $PKG_BUILD/mupen64plus-audio-sdl2/projects/unix
  make -j$CONCURRENCY_MAKE_LEVEL all

  # Build mupen64plus-gui
  mkdir -p cd $PKG_BUILD/mupen64plus-gui/build
  cd $PKG_BUILD/mupen64plus-gui/build
  qmake ../mupen64plus-gui.pro
  make -j$CONCURRENCY_MAKE_LEVEL

  # Build GLideN64
  cd $PKG_BUILD/GLideN64/src
  ./getRevision.sh

  cd $PKG_BUILD/GLideN64/projects/cmake
  rm -rf ../../src/GLideNHQ/inc
  cmake -DOPENGL_gl_LIBRARY=$SYSROOT_PREFIX/usr/lib \
        -DUSE_SYSTEM_LIBS=On \
        -DVEC4_OPT=On \
        -DCRC_OPT=On \
        -DMUPENPLUSAPI=On \
        ../../src/
  make -j$CONCURRENCY_MAKE_LEVEL

  # Build angrylion-rdp-plus
  mkdir -p $PKG_BUILD/angrylion-rdp-plus/build
  cd $PKG_BUILD/angrylion-rdp-plus/build
  cmake -DOPENGL_gl_LIBRARY=$SYSROOT_PREFIX/usr/lib \
        ../
  make -j$CONCURRENCY_MAKE_LEVEL
}

makeinstall_target() {
  # Create directories
  mkdir -p $INSTALL/usr/bin
  mkdir -p $INSTALL/usr/config/mupen64plus
  mkdir -p $INSTALL/usr/lib

  # Install binary & scripts
  cp $PKG_DIR/scripts/* $INSTALL/usr/bin
  cp $PKG_BUILD/mupen64plus-gui/build/mupen64plus-gui $INSTALL/usr/bin

  # Install config files
  cp $PKG_DIR/config/*                       $INSTALL/usr/config/mupen64plus
  cp $PKG_BUILD/GLideN64/ini/*.ini           $INSTALL/usr/config/mupen64plus
  cp $PKG_BUILD/mupen64plus-core/data/*      $INSTALL/usr/config/mupen64plus
  cp $PKG_BUILD/mupen64plus-input-sdl/data/* $INSTALL/usr/config/mupen64plus

  # Install libs
  cp $PKG_BUILD/angrylion-rdp-plus/build/*.so               $INSTALL/usr/lib
  cp $PKG_BUILD/GLideN64/projects/cmake/plugin/Release/*.so $INSTALL/usr/lib
  cp $PKG_BUILD/mupen64plus-audio-sdl2/projects/unix/*.so   $INSTALL/usr/lib
  cp -P $PKG_BUILD/mupen64plus-core/projects/unix/*.so*     $INSTALL/usr/lib
  cp $PKG_BUILD/mupen64plus-input-sdl/projects/unix/*.so    $INSTALL/usr/lib
  cp $PKG_BUILD/mupen64plus-rsp-cxd4/projects/unix/*.so     $INSTALL/usr/lib
  cp $PKG_BUILD/mupen64plus-rsp-hle/projects/unix/*.so      $INSTALL/usr/lib
}
