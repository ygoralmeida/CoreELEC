# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="fluidsynth-git"
PKG_VERSION="2.0.1"
PKG_SHA256="0d80f0b2fb0d3f93722844e654d5b5f004bf31a07f752c0be939b7242ac33248"
PKG_LICENSE="LGPL"
PKG_SITE="http://fluidsynth.org/"
PKG_URL="https://github.com/FluidSynth/fluidsynth/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain glib soundfont-generaluser"
PKG_LONGDESC="FluidSynth is a software real-time synthesizer based on the Soundfont 2 specifications."
PKG_BUILD_FLAGS="+pic"

PKG_CMAKE_OPTS_TARGET="-Denable-readline=0 \
                       -Denable-oss=0 \
                       -Denable-pulseaudio=1 \
                       -Denable-libsndfile=0"

post_makeinstall_target() {
  mkdir -p $INSTALL/etc/fluidsynth
  cp $PKG_DIR/config/* $INSTALL/etc/fluidsynth/
}
