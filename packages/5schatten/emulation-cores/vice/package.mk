# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 0riginally created by Escalade (https://github.com/escalade)
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="vice"
PKG_VERSION="3.2"
PKG_SHA256="17c9ece18dc100a5be26ad02ad74e7583e06458a87aabab720db30e176716aee"
PKG_ARCH="x86_64"
PKG_LICENSE="GPLv3"
PKG_SITE="http://vice-emu.sourceforge.net/"
PKG_URL="https://github.com/SupervisedThinking/vice/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain alsa-lib SDL2-git libpng giflib zlib libvorbis libogg lame"
PKG_LONGDESC="VICE C64 emulator"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_prog_sdl2_config=$SYSROOT_PREFIX/usr/bin/sdl2-config \
                           toolchain_check=no \
                         --prefix=/usr \
                         --disable-option-checking \
                         --disable-catweasel \
                         --enable-native-tools=$HOST_CC \
                         --enable-sdlui2 \
                         --disable-parsid \
                         --disable-hardsid \
                         --without-oss \
                         --without-pulse"

pre_configure_target() {
  export LIBS="-ludev"
  $PKG_BUILD/autogen.sh
}

post_makeinstall_target() {
  # copy over scripts
  cp $PKG_DIR/scripts/* $INSTALL/usr/bin
  # rename the lib directory as LE has a lib64 symlink to lib
  if [ -d $INSTALL/usr/lib64 ]; then
    mv $INSTALL/usr/lib64 $INSTALL/usr/lib
  fi
  # copy over default config
  mkdir -p $INSTALL/etc
  cp $PKG_DIR/config/sdl-vicerc $INSTALL/etc/
  # remove binaries
  for bin in \
    c1541 \
    cartconv \
    petcat \
    vsid \
    x128 \
    x64dtv \
    x64sc \
    xcbm2 \
    xcbm5x0 \
    xpet \
    xplus4 \
    xscpu64 \
    xvic
  do
    rm $INSTALL/usr/bin/$bin
  done
  # remove data files
  for dir in \
    C128 \
    C64DTV \
    CBM-II \
    PET \
    PLUS4 \
    PRINTER \
    SCPU64 \
    VIC20
  do
    rm -rf $INSTALL/usr/lib/vice/$dir
  done
 }
