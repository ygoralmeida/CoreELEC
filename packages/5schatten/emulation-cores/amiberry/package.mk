# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="amiberry"
PKG_VERSION="85f7e149358acbf6bf19b472a67720105172f564" # v2.24b5
PKG_ARCH="arm"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/midwan/amiberry"
PKG_URL="https://github.com/midwan/amiberry.git"
PKG_DEPENDS_TARGET="toolchain zlib SDL2-git SDL2_image SDL2_ttf capsimg libxml2 flac mpg123-compat libpng libmpeg2 retroarch-joypad-autoconfig"
PKG_LONGDESC="Amiberry is an optimized Amiga emulator, for ARM-based boards (like the Raspberry Pi, ASUS Tinkerboard, Odroid XU4, etc). The core emulation comes from WinUAE, but stripped down to remove excess stuff in order to achieve good performance in underpowered boards. It includes ARM JIT support, to get high-performance results on CPU-intensive emulated environments."
GET_HANDLER_SUPPORT="git"
PKG_TOOLCHAIN="manual"

make_target() {

  # build amiberry
  export SYSROOT_PREFIX=$SYSROOT_PREFIX

  if [ "$PROJECT" = "Amlogic" ]; then
    make all PLATFORM=aml
  fi

  if [ "$PROJECT" = "RPi" ]; then
    case $DEVICE in
      RPi)
        make all PLATFORM=rpi1-sdl2
        ;;
      RPi2)
        make all PLATFORM=rpi2-sdl2
        ;;
    esac
  fi
}

makeinstall_target() {

  # create directories
  mkdir -p $INSTALL/usr/bin
  mkdir -p $INSTALL/usr/lib
  mkdir -p $INSTALL/usr/config/amiberry
  mkdir -p $INSTALL/usr/config/amiberry/controller

  # copy ressources
  cp -R $PKG_DIR/config/* $INSTALL/usr/config/amiberry
  cp -R data $INSTALL/usr/config/amiberry/
  ln -s /storage/roms/bios/Kickstarts $INSTALL/usr/config/amiberry/kickstarts
  cp -R savestates $INSTALL/usr/config/amiberry/
  cp -R screenshots $INSTALL/usr/config/amiberry/
  cp -R whdboot $INSTALL/usr/config/amiberry/

  # create links to Retroarch controller files
  ln -s /usr/share/retroarch/autoconfig/udev/8Bitdo_Pro_SF30_BT_B.cfg "$INSTALL/usr/config/amiberry/controller/8Bitdo SF30 Pro.cfg"
  ln -s "/usr/share/retroarch/autoconfig/udev/Pro Controller.cfg" "$INSTALL/usr/config/amiberry/controller/Pro Controller.cfg"

  # copy binary, scripts & capsimg lib
  cp amiberry-*-sdl2 $INSTALL/usr/bin/amiberry
  cp $PKG_DIR/scripts/* $INSTALL/usr/bin

  ln -sf /usr/lib/libcapsimage.so.5.1 $INSTALL/usr/config/amiberry/capsimg.so
}
