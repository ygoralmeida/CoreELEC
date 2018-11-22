#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 0riginally created by Escalade (https://github.com/escalade)
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

# Script to suspend/resume audio and freeze/unfreeze the Kodi process

. /etc/profile

kodi_freeze() {
  if [ "$1" = "muteonly" ]; then
    kodi-send --action="RunScript(/usr/bin/audio-suspend.py)"
  else
    systemctl stop kodi &
    usleep 500000
    start_FluidSynth_PA
  fi
}

kodi_freeze_noPA() {
  if [ "$1" = "muteonly" ]; then
    kodi-send --action="RunScript(/usr/bin/audio-suspend.py)"
  else
    systemctl stop kodi &
    usleep 500000
  fi
}


kodi_unfreeze() {
  if [ "$1" = "muteonly" ]; then
    kodi-send --action="RunScript(/usr/bin/audio-resume.py)"
  else
    stop_FluidSynth_PA
    usleep 500000
    systemctl start kodi
  fi
}

kodi_unfreeze_noPA() {
  if [ "$1" = "muteonly" ]; then
    kodi-send --action="RunScript(/usr/bin/audio-resume.py)"
  else
    usleep 500000
    systemctl start kodi
  fi
}

case $1 in
  freeze)
    if [ ! -f /tmp/.kodifreeze ]; then
      pidof kodi.bin > /dev/null && KODI=1
      if [ "$KODI" = "1" ]; then
        kodi_freeze $2
        touch /tmp/.kodifreeze
      else
        echo "Kodi isn't running, nothing to do."
      fi
    else
      echo "Kodi already frozen, nothing to do."
    fi
    ;;
  freeze_noPA)
    if [ ! -f /tmp/.kodifreeze ]; then
      pidof kodi.bin > /dev/null && KODI=1
      if [ "$KODI" = "1" ]; then
        kodi_freeze_noPA $2
        touch /tmp/.kodifreeze
      else
        echo "Kodi isn't running, nothing to do."
      fi
    else
      echo "Kodi already frozen, nothing to do."
    fi
    ;;
  unfreeze)
    if [ -f /tmp/.kodifreeze ]; then
      kodi_unfreeze $2
      rm /tmp/.kodifreeze
    else
      echo "Kodi isn't frozen, nothing to do."
    fi
    ;;
  unfreeze_noPA)
    if [ -f /tmp/.kodifreeze ]; then
      kodi_unfreeze_noPA $2
      rm /tmp/.kodifreeze
    else
      echo "Kodi isn't frozen, nothing to do."
    fi
    ;;
  *)
    echo "Usage: $0 [freeze|unfreeze|freeze_noPA|unfreeze_noPA] [muteonly]"
    ;;
esac
