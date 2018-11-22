# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 0riginally created by Escalade (https://github.com/escalade)
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="PCSX2"
PKG_VERSION="1.5.0-dev"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/PCSX2/pcsx2"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="PCSX2 is an open-source PlayStation 2 (AKA PS2) emulator. Its purpose is to emulate the PS2 hardware, using a combination of MIPS CPU Interpreters, Recompilers and a Virtual Machine which manages hardware states and PS2 system memory. This allows you to play PS2 games on your PC, with many additional features and benefits."
PKG_TOOLCHAIN="manual"

makeinstall_target() {
 mkdir -p $INSTALL/usr/bin
 mkdir -p $INSTALL/usr/config

 cp -r $PKG_DIR/scripts/* $INSTALL/usr/bin/
 cp -r $PKG_DIR/config/* $INSTALL/usr/config/
}
