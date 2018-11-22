# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="qt-everywhere"
PKG_VERSION="5.11.2"
PKG_SHA256="c6104b840b6caee596fa9a35bc5f57f67ed5a99d6a36497b6fe66f990a53ca81"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="http://qt-project.org"
PKG_URL="http://download.qt.io/archive/qt/${PKG_VERSION%.*}/$PKG_VERSION/single/$PKG_NAME-src-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain pcre2 zlib"
PKG_LONGDESC="A cross-platform application and UI framework"

PKG_CONFIGURE_OPTS_TARGET="-prefix /usr
                           -sysroot $SYSROOT_PREFIX
                           -hostprefix $TOOLCHAIN
                           -device linux-libreelec-g++
                           -opensource -confirm-license
                           -release
                           -shared
                           -make libs
                           -qt-xcb
                           -force-pkg-config
                           -no-accessibility
                           -no-sql-sqlite
                           -no-sql-mysql
                           -system-zlib
                           -no-mtdev
                           -no-gif
                           -no-libjpeg
                           -no-harfbuzz
                           -no-libproxy
                           -system-pcre
                           -no-glib
                           -silent
                           -no-cups
                           -no-iconv
                           -no-evdev
                           -no-tslib
                           -no-icu
                           -no-strip
                           -no-dbus
                           -opengl
                           -no-libudev
                           -no-libinput
                           -no-eglfs
                           -skip qt3d
                           -skip qtactiveqt
                           -skip qtandroidextras
                           -skip qtcanvas3d
                           -skip qtcharts
                           -skip qtconnectivity
                           -skip qtdatavis3d
                           -skip qtdeclarative
                           -skip qtdoc
                           -skip qtgamepad
                           -skip qtgraphicaleffects
                           -skip qtimageformats
                           -skip qtlocation
                           -skip qtmacextras
                           -skip qtnetworkauth
                           -skip qtpurchasing
                           -skip qtquickcontrols
                           -skip qtquickcontrols2
                           -skip qtremoteobjects
                           -skip qtscript
                           -skip qtscxml
                           -skip qtsensors
                           -skip qtserialbus
                           -skip qtspeech
                           -skip qtsvg
                           -skip qttranslations
                           -skip qtvirtualkeyboard
                           -skip qtwayland
                           -skip qtwebchannel
                           -skip qtwebengine
                           -skip qtwebsockets
                           -skip qtwebview
                           -skip qtwinextras
                           -skip qtx11extras
                           -skip qtxmlpatterns"

configure_target() {
  QMAKE_CONF_DIR="qtbase/mkspecs/devices/linux-libreelec-g++"
  QMAKE_CONF="${QMAKE_CONF_DIR}/qmake.conf"

  cd ..
  mkdir -p $QMAKE_CONF_DIR
  echo "MAKEFILE_GENERATOR       = UNIX" > $QMAKE_CONF
  echo "CONFIG                  += incremental" >> $QMAKE_CONF
  echo "QMAKE_INCREMENTAL_STYLE  = sublib" >> $QMAKE_CONF
  echo "include(../../common/linux.conf)" >> $QMAKE_CONF
  echo "include(../../common/gcc-base-unix.conf)" >> $QMAKE_CONF
  echo "include(../../common/g++-unix.conf)" >> $QMAKE_CONF
  echo "load(device_config)" >> $QMAKE_CONF
  echo "QMAKE_CC                = $CC" >> $QMAKE_CONF
  echo "QMAKE_CXX               = $CXX" >> $QMAKE_CONF
  echo "QMAKE_LINK              = $CXX" >> $QMAKE_CONF
  echo "QMAKE_LINK_SHLIB        = $CXX" >> $QMAKE_CONF
  echo "QMAKE_AR                = $AR cqs" >> $QMAKE_CONF
  echo "QMAKE_OBJCOPY           = $OBJCOPY" >> $QMAKE_CONF
  echo "QMAKE_NM                = $NM -P" >> $QMAKE_CONF
  echo "QMAKE_STRIP             = $STRIP" >> $QMAKE_CONF
  echo "QMAKE_CFLAGS = $CFLAGS" >> $QMAKE_CONF
  echo "QMAKE_CXXFLAGS = $CXXFLAGS" >> $QMAKE_CONF
  echo "QMAKE_LFLAGS = $LDFLAGS" >> $QMAKE_CONF
  echo "load(qt_config)" >> $QMAKE_CONF
  echo '#include "../../linux-g++/qplatformdefs.h"' >> $QMAKE_CONF_DIR/qplatformdefs.h

  unset CC CXX LD RANLIB AR AS CPPFLAGS CFLAGS LDFLAGS CXXFLAGS
  ./configure $PKG_CONFIGURE_OPTS_TARGET
}

post_makeinstall_target() {
  # install QT5 libs
  mkdir -p $INSTALL/usr/lib
  mkdir -p $INSTALL/usr/plugins
  mkdir -p $INSTALL/usr/plugins/platforms

  # libQt5Concurrent.so.5
   cp -PR $SYSROOT_PREFIX/usr/lib/libQt5Concurrent.so.$PKG_VERSION $INSTALL/usr/lib
     ln -sf libQt5Concurrent.so.$PKG_VERSION $INSTALL/usr/lib/libQt5Concurrent.so.${PKG_VERSION:0:4}
     ln -sf libQt5Concurrent.so.${PKG_VERSION:0:4} $INSTALL/usr/lib/libQt5Concurrent.so.${PKG_VERSION:0:1}

  # libQt5Core.so.5
   cp -PR $SYSROOT_PREFIX/usr/lib/libQt5Core.so.$PKG_VERSION $INSTALL/usr/lib
     ln -sf libQt5Core.so.$PKG_VERSION $INSTALL/usr/lib/libQt5Core.so.${PKG_VERSION:0:4}
     ln -sf libQt5Core.so.${PKG_VERSION:0:4} $INSTALL/usr/lib/libQt5Core.so.${PKG_VERSION:0:1}

  # libQt5Gui.so.5
   cp -PR $SYSROOT_PREFIX/usr/lib/libQt5Gui.so.$PKG_VERSION $INSTALL/usr/lib
     ln -sf libQt5Gui.so.$PKG_VERSION $INSTALL/usr/lib/libQt5Gui.so.${PKG_VERSION:0:4}
     ln -sf libQt5Gui.so.${PKG_VERSION:0:4} $INSTALL/usr/lib/libQt5Gui.so.${PKG_VERSION:0:1}

  # libQt5Multimedia.so.5 
   cp -PR $SYSROOT_PREFIX/usr/lib/libQt5Multimedia.so.$PKG_VERSION $INSTALL/usr/lib
     ln -sf libQt5Multimedia.so.$PKG_VERSION $INSTALL/usr/lib/libQt5Multimedia.so.${PKG_VERSION:0:4}
     ln -sf libQt5Multimedia.so.${PKG_VERSION:0:4} $INSTALL/usr/lib/libQt5Multimedia.so.${PKG_VERSION:0:1}

  # libQt5Network.so.5
   cp -PR $SYSROOT_PREFIX/usr/lib/libQt5Network.so.$PKG_VERSION $INSTALL/usr/lib
     ln -sf libQt5Network.so.$PKG_VERSION $INSTALL/usr/lib/libQt5Network.so.${PKG_VERSION:0:4}
     ln -sf libQt5Network.so.${PKG_VERSION:0:4} $INSTALL/usr/lib/libQt5Network.so.${PKG_VERSION:0:1}

  # libQt5OpenGL.so.5
   cp -PR $SYSROOT_PREFIX/usr/lib/libQt5OpenGL.so.$PKG_VERSION $INSTALL/usr/lib
     ln -sf libQt5OpenGL.so.$PKG_VERSION $INSTALL/usr/lib/libQt5OpenGL.so.${PKG_VERSION:0:4}
     ln -sf libQt5OpenGL.so.${PKG_VERSION:0:4} $INSTALL/usr/lib/libQt5OpenGL.so.${PKG_VERSION:0:1}

  # libQt5Widgets.so.5
   cp -PR $SYSROOT_PREFIX/usr/lib/libQt5Widgets.so.$PKG_VERSION $INSTALL/usr/lib
     ln -sf libQt5Widgets.so.$PKG_VERSION $INSTALL/usr/lib/libQt5Widgets.so.${PKG_VERSION:0:4}
     ln -sf libQt5Widgets.so.${PKG_VERSION:0:4} $INSTALL/usr/lib/libQt5Widgets.so.${PKG_VERSION:0:1}

  # libQt5XcbQpa.so.5
   cp -PR $SYSROOT_PREFIX/usr/lib/libQt5XcbQpa.so.$PKG_VERSION $INSTALL/usr/lib
     ln -sf libQt5XcbQpa.so.$PKG_VERSION $INSTALL/usr/lib/libQt5XcbQpa.so.${PKG_VERSION:0:4}
     ln -sf libQt5XcbQpa.so.${PKG_VERSION:0:4} $INSTALL/usr/lib/libQt5XcbQpa.so.${PKG_VERSION:0:1}

  # plugin libqxcb.so
   cp -PR $SYSROOT_PREFIX/usr/plugins/platforms/libqxcb.so $INSTALL/usr/plugins/platforms/libqxcb.so

  # plugins xcbglintegrations
   cp -PR $SYSROOT_PREFIX/usr/plugins/xcbglintegrations $INSTALL/usr/plugins
}
