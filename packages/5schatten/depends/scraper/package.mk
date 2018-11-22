# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 0riginally created by Escalade (https://github.com/escalade)
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="scraper"
PKG_VERSION="1.4.6"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/sselph/scraper"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="An auto-scraper for EmulationStation written in Go using hashes. This currently works with NES, SNES, N64, GB, GBC, GBA, MD, SMS, 32X, GG, PCE, A2600, LNX, MAME/FBA(see below), Dreamcast(bin/gdi), PSX(bin/cue), ScummVM, SegaCD, WonderSwan, WonderSwan Color ROMs."

PKG_TOOLCHAIN="manual"

pre_build_target() {
  cd $PKG_BUILD
  if [ "$PROJECT" = "RPi" ]; then
     if [ "$DEVICE" = "RPi" ]; then
        wget $PKG_SITE/releases/download/v$PKG_VERSION/scraper_rpi.zip
     elif [ "$DEVICE" = "RPi2" ]; then
        wget $PKG_SITE/releases/download/v$PKG_VERSION/scraper_rpi2.zip
    fi
  fi

  if [ "$PROJECT" = "Generic" ]; then
    wget $PKG_SITE/releases/download/v$PKG_VERSION/scraper_linux_amd64.zip
  fi
  unzip -o *.zip
  cd -
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp scraper $INSTALL/usr/bin
}
