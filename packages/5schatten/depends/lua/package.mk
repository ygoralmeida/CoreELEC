# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018 0riginally created by shantigilbert (https://github.com/shantigilbert)
# Copyright (C) 2018 Escalade (https://github.com/escalade)
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="lua"
PKG_VERSION="5.3.3"
PKG_SHA256="5113c06884f7de453ce57702abaac1d618307f33f6789fa870e87a59d772aca2"
PKG_LICENSE="MIT"
PKG_SITE="http://www.lua.org/"
PKG_URL="http://www.lua.org/ftp/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain readline"
PKG_LONGDESC="lua: A lightweight, extensible programming language"
PKG_TOOLCHAIN="manual"

_MAJORVER=${PKG_VERSION%.*}

make_target() {
  CFLAGS=`echo $CFLAGS | sed -e "s|-mcpu=cortex-a53||"`
  make CC="$CC" CFLAGS="$CFLAGS -fPIC -DLUA_COMPAT_5_2 -DLUA_COMPAT_5_1" linux
}

makeinstall_target() {
  make \
  TO_LIB="liblua.a liblua.so liblua.so.$_MAJORVER liblua.so.$PKG_VERSION" \
  INSTALL_DATA='cp -d' \
  INSTALL_TOP=$SYSROOT_PREFIX/usr \
  INSTALL_MAN=$SYSROOT_PREFIX/usr/share/man/man1 \
  install

  ln -sf $SYSROOT_PREFIX/usr/bin/lua $SYSROOT_PREFIX/usr/bin/lua$_MAJORVER
  ln -sf $SYSROOT_PREFIX/usr/bin/luac $SYSROOT_PREFIX/usr/bin/luac$_MAJORVER

  mkdir -p $SYSROOT_PREFIX/usr/lib/pkgconfig
    cp -P $PKG_DIR/config/lua.pc $SYSROOT_PREFIX/usr/lib/pkgconfig/lua53.pc
  ln -sf $SYSROOT_PREFIX/usr/lib/pkgconfig/lua53.pc $SYSROOT_PREFIX/usr/lib/pkgconfig/lua.pc

  make \
  TO_LIB="liblua.a liblua.so liblua.so.$_MAJORVER liblua.so.$PKG_VERSION" \
  INSTALL_DATA='cp -d' \
  INSTALL_TOP=$INSTALL/usr \
  INSTALL_MAN=$INSTALL/usr/share/man/man1 \
  install

  ln -sf $INSTALL/usr/bin/lua $INSTALL/usr/bin/lua$_MAJORVER
  ln -sf $INSTALL/usr/bin/luac $INSTALL/usr/bin/luac$_MAJORVER
}

