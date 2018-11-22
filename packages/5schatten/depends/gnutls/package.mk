# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) Originally created by Escalade (https://github.com/escalade)
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="gnutls"
PKG_VERSION="3.6.3"
PKG_SHA256="ed642b66a4ecf4851ab2d809cd1475c297b6201d8e8bd14b4d1c08b53ffca993"
PKG_LICENSE="GPLv3"
PKG_SITE="https://www.gnutls.org"
PKG_URL="https://www.gnupg.org/ftp/gcrypt/gnutls/v${PKG_VERSION%.*}/gnutls-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain nettle"
PKG_LONGDESC="GnuTLS is a secure communications library implementing the SSL, TLS and DTLS protocols and technologies around them."

PKG_CONFIGURE_OPTS_TARGET="--with-included-libtasn1 \
                           --with-included-unistring \
                           --enable-local-libopts \
                           --without-p11-kit \
                           --with-libgcrypt \
                           --disable-tools \
                           --disable-doc"
