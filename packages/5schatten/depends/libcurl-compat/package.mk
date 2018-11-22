# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) Originally created by Escalade (https://github.com/escalade)
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="libcurl-compat"
PKG_VERSION="7.61.1"
PKG_SHA256="a308377dbc9a16b2e994abd55455e5f9edca4e31666f8f8fcfe7a1a4aea419b9"
PKG_LICENSE="MIT"
PKG_SITE="http://curl.haxx.se"
PKG_URL="http://curl.haxx.se/download/curl-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain zlib openssl rtmpdump"
PKG_LONGDESC="libcurl without versioned symbols"

PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_lib_rtmp_RTMP_Init=yes \
                           ac_cv_header_librtmp_rtmp_h=yes \
                           --disable-debug \
                           --enable-optimize \
                           --enable-warnings \
                           --disable-curldebug \
                           --disable-ares \
                           --enable-largefile \
                           --enable-http \
                           --enable-ftp \
                           --enable-file \
                           --disable-ldap \
                           --disable-ldaps \
                           --enable-rtsp \
                           --enable-proxy \
                           --disable-dict \
                           --disable-telnet \
                           --disable-tftp \
                           --disable-pop3 \
                           --disable-imap \
                           --disable-smb \
                           --disable-smtp \
                           --disable-gopher \
                           --disable-manual \
                           --enable-libgcc \
                           --enable-ipv6 \
                           --disable-versioned-symbols \
                           --enable-nonblocking \
                           --enable-threaded-resolver \
                           --enable-verbose \
                           --disable-sspi \
                           --enable-crypto-auth \
                           --enable-cookies \
                           --disable-soname-bump \
                           --with-gnu-ld \
                           --without-krb4 \
                           --without-spnego \
                           --without-gssapi \
                           --with-zlib \
                           --without-egd-socket \
                           --enable-thread \
                           --with-random=/dev/urandom \
                           --with-gnutls=$SYSROOT_PREFIX/usr \
                           --with-ssl \
                           --without-polarssl \
                           --without-nss \
                           --with-ca-bundle=/etc/ssl/cert.pem \
                           --without-ca-path \
                           --without-libpsl \
                           --without-libmetalink \
                           --without-libssh2 \
                           --with-librtmp=$SYSROOT_PREFIX/usr \
                           --without-libidn"

unpack() {
  mkdir -p $BUILD/$PKG_NAME-$PKG_VERSION ; cd $BUILD/$PKG_NAME-$PKG_VERSION
  tar -jxf $SOURCES/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.bz2
  mv curl-$PKG_VERSION/* .
  rm -rf curl-$PKG_VERSION
  cd -
}

pre_configure_target() {
# link against librt because of undefined reference to 'clock_gettime'
  export LIBS="-lrt -lm"
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin/curl-config
  rm -rf $INSTALL/usr/bin/curl
  
  mv $INSTALL/usr/lib/libcurl{,-gnutls}.so.4.5.0
  rm $INSTALL/usr/lib/libcurl.*
  for version in 3 4 4.0.0 4.1.0 4.2.0 4.3.0 4.4.0; do
    ln -s libcurl-gnutls.so.4.5.0 $INSTALL/usr/lib/libcurl-gnutls.so.${version}
  done
}
