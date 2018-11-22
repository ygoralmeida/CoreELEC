# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 0riginally created by Escalade (https://github.com/escalade)
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="retroarch"
PKG_VERSION="e99e1c47cb0f11dda23427e2a5fb206fc2a4bb9a" #1.7.6-dev 
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/RetroArch"
PKG_URL="https://github.com/libretro/RetroArch.git"
PKG_DEPENDS_TARGET="toolchain alsa-lib tinyalsa fluidsynth-git freetype zlib ffmpeg retroarch-assets retroarch-common-overlays retroarch-overlay-borders retroarch-joypad-autoconfig lr-common-shaders lr-slang-shaders lr-glsl-shaders lr-core-info lr-database"
PKG_LONGDESC="Reference frontend for the libretro API."
GET_HANDLER_SUPPORT="git"

if [ "$OPENGL_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $OPENGL"
fi

if [ "$OPENGLES_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $OPENGLES"
fi

if [ "$SAMBA_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET samba"
fi

if [ "$AVAHI_DAEMON" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET avahi nss-mdns"
fi

# OpenGL Features Support
if [ "$OPENGL_SUPPORT" = yes ]; then
  RETROARCH_SUPPORT_GL="--enable-kms"

# RPi OpenGLES Features Support
elif [ "$OPENGLES" = "bcm2835-driver" ]; then
  RETROARCH_SUPPORT_GLES="--enable-opengles \
                          --disable-kms \
                          --enable-dispmanx"

  CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/interface/vcos/pthreads \
                  -I$SYSROOT_PREFIX/usr/include/interface/vmcs_host/linux"

# Amlogic OpenGLES Features Support
elif [ "$OPENGLES" = "opengl-meson" ] || [ "$OPENGLES" = "opengl-meson-t82x" ]; then
  RETROARCH_SUPPORT_GLES="--enable-opengles \
                          --disable-kms \
                          --enable-mali_fbdev"

# Vulkan Support
elif [ "$VULKAN_SUPPORT" = yes ]; then
  RETROARCH_SUPPORT_VULKAN="--enable-vulkan"

# QT Support
elif [ "$PROJECT" = "Generic" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET qt-everywhere"
  RETROARCH_SUPPORT_QT="--enable-qt"
fi

# NEON Support
if target_has_feature neon; then
  RETROARCH_SUPPORT_NEON="--enable-neon"
fi

TARGET_CONFIGURE_OPTS=""
PKG_CONFIGURE_OPTS_TARGET="--disable-vg \
                           --disable-sdl \
                           --disable-xvideo \
                           --disable-al \
                           --disable-oss \
                           --enable-zlib \
                           --host=$TARGET_NAME \
                           --enable-freetype \
                           $RETROARCH_SUPPORT_GL \
                           $RETROARCH_SUPPORT_GLES \
                           $RETROARCH_SUPPORT_VULKAN \
                           $RETROARCH_SUPPORT_QT \
                           $RETROARCH_SUPPORT_NEON"

pre_configure_target() {
  cd ..
  rm -rf .$TARGET_NAME
  export PKG_CONF_PATH=$TOOLCHAIN/bin/pkg-config
  echo ${PKG_VERSION:0:7} > .gitversion
}

make_target() {
  make
  make -C gfx/video_filters compiler=$CC extra_flags="$CFLAGS"
  make -C libretro-common/audio/dsp_filters compiler=$CC extra_flags="$CFLAGS"
}

makeinstall_target() {
  mkdir -p $INSTALL/etc
    cp $PKG_BUILD/retroarch.cfg $INSTALL/etc
  mkdir -p $INSTALL/usr/share/retroarch/video_filters
    cp $PKG_BUILD/gfx/video_filters/*.so $INSTALL/usr/share/retroarch/video_filters
    cp $PKG_BUILD/gfx/video_filters/*.filt $INSTALL/usr/share/retroarch/video_filters
  mkdir -p $INSTALL/usr/share/retroarch/audio_filters
    cp $PKG_BUILD/libretro-common/audio/dsp_filters/*.so $INSTALL/usr/share/retroarch/audio_filters
    cp $PKG_BUILD/libretro-common/audio/dsp_filters/*.dsp $INSTALL/usr/share/retroarch/audio_filters
  mkdir -p $INSTALL/usr/bin
    cp $PKG_BUILD/retroarch $INSTALL/usr/bin
    cp $PKG_DIR/scripts/$PROJECT/* $INSTALL/usr/bin

  if [[ "$PROJECT" =~ "Generic" ]]; then
    mkdir -p $INSTALL/usr/config/retroarch
    cp -PR $PKG_DIR/config/* $INSTALL/usr/config/retroarch/
  fi
  
  # General configuration
  sed -i -e "s/# savefile_directory =/savefile_directory = \/storage\/.config\/retroarch\/saves/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# screenshot_directory =/screenshot_directory = \"\/storage\/screenshots\"/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# libretro_directory =/libretro_directory = \"\/tmp\/cores\"/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# libretro_info_path =/libretro_info_path = \"\/tmp\/cores\"/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# content_database_path =/content_database_path =\/tmp\/database\/rdb/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# cheat_database_path =/cheat_database_path =\/tmp\/database\/cht/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# rgui_browser_directory =/rgui_browser_directory =\/storage\/roms/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# video_shader_dir =/video_shader_dir =\/tmp\/shaders/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# rgui_show_start_screen = true/rgui_show_start_screen = false/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# assets_directory =/assets_directory =\/tmp\/assets/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# overlay_directory =/overlay_directory = \"\/tmp\/overlay\"/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# menu_driver = \"rgui\"/menu_driver = \"xmb\"/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# video_shared_context = false/video_shared_context = true/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# menu_show_core_updater = true/# menu_show_core_updater = false/" $INSTALL/etc/retroarch.cfg
  echo 'cursor_directory = "/tmp/database/cursors"' >> $INSTALL/etc/retroarch.cfg
  echo 'recording_output_directory = "/storage/videos"' >> $INSTALL/etc/retroarch.cfg
  echo 'system_directory = "/storage/roms/bios"' >> $INSTALL/etc/retroarch.cfg
  
  # Video
  sed -i -e "s/# video_fullscreen = false/video_fullscreen = true/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# video_windowed_fullscreen = true/video_windowed_fullscreen = false/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# video_smooth = true/video_smooth = false/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# video_aspect_ratio_auto = false/video_aspect_ratio_auto = true/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# video_font_size = 48/video_font_size = 32/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# video_filter_dir =/video_filter_dir =\/usr\/share\/retroarch\/video_filters/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# video_gpu_screenshot = true/video_gpu_screenshot = false/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# video_fullscreen = false/video_fullscreen = true/" $INSTALL/etc/retroarch.cfg

  # Audio
  sed -i -e "s/# audio_driver =/audio_driver = \"alsathread\"/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# audio_filter_dir =/audio_filter_dir =\/usr\/share\/retroarch\/audio_filters/" $INSTALL/etc/retroarch.cfg
  if [ "$PROJECT" == "OdroidXU3" ]; then # workaround the 55fps bug
    sed -i -e "s/# audio_out_rate = 48000/audio_out_rate = 44100/" $INSTALL/etc/retroarch.cfg
  fi
  sed -i -e "s/# audio_filter_dir =/audio_filter_dir =\/usr\/share\/retroarch\/audio_filters/" $INSTALL/etc/retroarch.cfg
  if [ "$PROJECT" == "RPi" ]; then # set default audio device for RPi
    sed -i -e "s/# audio_device =/audio_device = \"sysdefault:CARD=ALSA\"/" $INSTALL/etc/retroarch.cfg
  fi

  # Input
  sed -i -e "s/# input_driver = sdl/input_driver = udev/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# input_max_users = 16/input_max_users = 5/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# input_autodetect_enable = true/input_autodetect_enable = true/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# joypad_autoconfig_dir =/joypad_autoconfig_dir = \/tmp\/autoconfig/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# input_remapping_directory =/input_remapping_directory = \/storage\/.config\/retroarch\/remappings/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# input_menu_toggle_gamepad_combo = 0/input_menu_toggle_gamepad_combo = 2/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# input_exit_emulator = escape/input_exit_emulator = ralt/" $INSTALL/etc/retroarch.cfg

  # Menu
  sed -i -e "s/# menu_mouse_enable = false/menu_mouse_enable = false/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# menu_core_enable = true/menu_core_enable = false/" $INSTALL/etc/retroarch.cfg
  sed -i -e "s/# thumbnails_directory =/thumbnails_directory = \/storage\/.config\/retroarch\/thumbnails/" $INSTALL/etc/retroarch.cfg
  echo "menu_show_advanced_settings = \"false\"" >> $INSTALL/etc/retroarch.cfg
  echo "menu_wallpaper_opacity = \"1.0\"" >> $INSTALL/etc/retroarch.cfg
  echo "content_show_images = \"false\"" >> $INSTALL/etc/retroarch.cfg
  echo "content_show_music = \"false\"" >> $INSTALL/etc/retroarch.cfg
  echo "content_show_video = \"false\"" >> $INSTALL/etc/retroarch.cfg

  # Updater
  if [ "$TARGET_ARCH" == "arm" ]; then
    sed -i -e "s/# core_updater_buildbot_url = \"http:\/\/buildbot.libretro.com\"/core_updater_buildbot_url = \"http:\/\/buildbot.libretro.com\/nightly\/linux\/armhf\/latest\/\"/" $INSTALL/etc/retroarch.cfg
  fi

  # Playlists
  echo "playlist_names = \"$RA_PLAYLIST_NAMES\"" >> $INSTALL/etc/retroarch.cfg
  echo "playlist_cores = \"$RA_PLAYLIST_CORES\"" >> $INSTALL/etc/retroarch.cfg
}

post_install() {  
  enable_service tmp-assets.mount
  enable_service tmp-autoconfig.mount
  enable_service tmp-cores.mount
  enable_service tmp-database.mount
  enable_service tmp-overlay.mount
  enable_service tmp-shaders.mount
}
