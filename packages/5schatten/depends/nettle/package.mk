# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 0riginally created by Escalade (https://github.com/escalade)
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="nettle"
PKG_VERSION="3.4"
PKG_SHA256="ae7a42df026550b85daca8389b6a60ba6313b0567f374392e54918588a411e94"
PKG_LICENSE="GPLv2"
PKG_SITE="https://www.lysator.liu.se/~nisse/nettle/"
PKG_URL="https://ftp.gnu.org/gnu/nettle/nettle-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain gmp openssl"
PKG_LONGDESC="Nettle is a cryptographic library that is designed to fit easily in more or less any context: In crypto toolkits for object-oriented languages (C++, Python, Pike, ...), in applications like LSH or GNUPG, or even in kernel space."

PKG_CONFIGURE_OPTS_TARGET="--disable-documentation"

if [ "$PROJECT" = "$RPi2" ]; then
  PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_TARGET --enable-arm-neon"
fi

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}

