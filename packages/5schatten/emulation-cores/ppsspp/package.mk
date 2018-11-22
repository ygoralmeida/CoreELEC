# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="ppsspp"
PKG_VERSION="fdb07323e0878e4773011a7a51a43a8900ad9d4a" #v1.7.1
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/hrydgard/ppsspp"
PKG_URL="https://github.com/hrydgard/ppsspp.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A PSP emulator for Android, Windows, Mac, Linux and Blackberry 10, written in C++."
GET_HANDLER_SUPPORT="git"
PKG_TOOLCHAIN="cmake-make"

if [ $ARCH = "arm" ] && [ ! $TARGET_CPU = "arm1176jzf-s" ]; then
  PPSSPP_ARCH_ARM="-DARMV7=ON"
elif [ $TARGET_CPU = "arm1176jzf-s" ]; then
  PPSSPP_ARCH_ARM="-DARM=ON"
fi

if [ $OPENGLES_SUPPORT = "yes" ]; then
  PPSSPP_OPENGLES_SUPPORT="-DUSING_FBDEV=ON \
                           -DUSING_EGL=ON \
                           -DUSING_GLES2=ON"
fi

if [ $DISPLAYSERVER = "x11" ] && [ $VULKAN_SUPPORT = "yes" ]; then
  PPSSPP_VULKAN_SUPPORT="-DUSING_X11_VULKAN=ON"
else
  PPSSPP_VULKAN_SUPPORT="-DUSING_X11_VULKAN=OFF"
fi

PKG_CMAKE_OPTS_TARGET="-DUSE_SYSTEM_FFMPEG=ON \
                       -DUSE_DISCORD=OFF \
                       $PPSSPP_ARCH_ARM \
                       $PPSSPP_OPENGLES_SUPPORT \
                       $PPSSPP_VULKAN_SUPPORT"

pre_make_target() {
  find . -name flags.make -exec sed -i "s:isystem :I:g" \{} \;
}

makeinstall_target() {
  # Create directories
  mkdir -p $INSTALL/usr/bin
  mkdir -p $INSTALL/usr/share/PPSSPP
  mkdir -p $INSTALL/usr/config/ppsspp/PSP/SYSTEM

  # Install assets & binary
  cp -r assets $INSTALL/usr/share/PPSSPP
  cp PPSSPPSDL $INSTALL/usr/share/PPSSPP

  # Install scripts
  cp $PKG_DIR/scripts/* $INSTALL/usr/bin

  # Install config
  cp $PKG_DIR/config/* $INSTALL/usr/config/ppsspp/PSP/SYSTEM
}
