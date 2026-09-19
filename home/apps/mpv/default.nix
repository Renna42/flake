{
  lib,
  pkgs,
  unstablePkgs,
  ...
}: let
  mpvConfig = pkgs.sources.mpv-config.src;

  ffmpeg =
    (unstablePkgs.ffmpeg_9.override {
      withUnfree = true;
    }).overrideAttrs (old: {
      patches =
        (old.patches or [])
        ++ [
          # https://github.com/nilaoda/Blog/discussions/81
          # https://gitee.com/openharmony/third_party_ffmpeg/pulls/49/files
          ../../../patches/ffmpeg-libavcodec-av3a.patch
          # https://gitee.com/openharmony/third_party_ffmpeg/pulls/128/files
          ../../../patches/ffmpeg-libavformat-av3a.patch
        ];

      doCheck = false;
      doInstallCheck = false;
    });
in {
  programs.mpv = {
    enable = true;
    package = pkgs.mpv.override {
      mpv-unwrapped =
        (pkgs.mpv-unwrapped.override {
          inherit ffmpeg;

          cddaSupport = true;
          vapoursynthSupport = true;
        }).overrideAttrs (old_: {
          inherit (pkgs.sources.mpv) src;
          version = "0.41.0-unstable-${pkgs.sources.mpv.date or pkgs.sources.mpv.version}"; # sometimes may not have the date

          patches = let
            patchesDir = "${pkgs.sources.mpv-omniphony.src}/patches-master";
          in
            (old_.patches or [])
            ++ lib.mapAttrsToList (name: _: "${patchesDir}/${name}") (builtins.readDir patchesDir);

          postPatch = lib.concatStringsSep "\n" [
            # Don't reference compile time dependencies or create a build outputs cycle
            # between out and dev
            ''
              substituteInPlace meson.build \
                --replace-fail "conf_data.set_quoted('CONFIGURATION', meson.build_options().strip().replace('\\\\', '\\\\\\\\'))" \
                               "conf_data.set_quoted('CONFIGURATION', '<omitted>')"
            ''
            # A trick to patchShebang everything except mpv_identify.sh
            ''
              pushd TOOLS
              mv mpv_identify.sh mpv_identify
              patchShebangs *.py *.sh
              mv mpv_identify mpv_identify.sh
              popd
            ''
          ];

          dontVersionCheck = true;
        });

      scripts = with unstablePkgs.mpvScripts; [
        # keep-sorted start
        autosubsync-mpv
        dynamic-crop
        eisa01.simplebookmark
        eisa01.simplehistory
        eisa01.undoredo
        modernz
        mpris
        mpv-sub-select
        quality-menu
        sponsorblock-minimal
        thumbfast
        # keep-sorted end
      ];

      extraMakeWrapperArgs = [
        # Add paths to required libraries
        "--prefix"
        "LD_LIBRARY_PATH"
        ":"
        "/run/opengl-driver/lib:${lib.makeLibraryPath [pkgs.ocl-icd]}"
      ];
    };

    scriptOpts = {
      # keep-sorted start block=yes
      autosubsync = {
        ffmpeg_path = "${lib.getExe ffmpeg}";
        ffsubsync_path = "${lib.getExe pkgs.ffsubsync}";
        alass_path = "${lib.getExe pkgs.renna.ilass}";
        audio_subsync_tool = "alass";
        altsub_subsync_tool = "alass";
        unload_old_sub = false;
      };
      dynamic_crop = {
        mode = 3;
        start_delay = 0;
        prevent_change_timer = 30;
        prevent_change_mode = 0;
        fix_windowed_behavior = 0;
        linked_tolerance = 2;
        ratios = "2.76 2.55 24/9 2.4 2.39 2.35 2.2 2.1 2 1.9 1.85 16/9 5/3 1.5 1.43 4/3 1.25 9/16 9/18 9/21";
        segmentation = 0.5;
        detect_limit = 26;
        detect_round = 2;
      };
      ytdl_hook = {
        try_ytdl_first = true;
        exclude = "%.avi$|%.flac$|%.flv$|%.mp3$|%.m3u$|%.m3u8$|%.m4a$|%.m4v$|%.mkv$|%.mp4$|%.ts$|%.VOB$|%.wav$|%.webm$|%.wmw$";
        include = "^%w+%.youtube%.com/|^youtube%.com/|^youtu%.be/|^%w+%.twitch%.tv/|^twitch%.tv/";
        ytdl_path = "${lib.getExe pkgs.yt-dlp}";
      };
      # keep-sorted end
    };

    config = {
      # HDR on supported displays
      vo = "gpu-next";
      target-colorspace-hint = true;
      gpu-api = "vulkan";
      gpu-context = "waylandvk";
      hwdec = "auto-copy-safe";
      hwdec-codecs = "all";

      osc = false;
      window-maximized = true;
      autofit-smaller = "40%x30%";
      idle = true;
      hr-seek = true;
      hr-seek-framedrop = false;
      save-position-on-quit = true;
      write-filename-in-watch-later-config = true;
      resume-playback-check-mtime = true;
      watch-later-options = "start,vid,aid,sid";
      save-watch-history = true;
      reset-on-next-file = "vid,aid,sid,secondary-sid,vf,af,loop-file,deinterlace,contrast,brightness,gamma,saturation,hue,video-zoom,video-rotate,video-pan-x,video-pan-y,panscan,speed,audio-delay,sub-pos,sub-scale,sub-delay,sub-speed,sub-visibility,secondary-sub-visibility";
      demuxer-max-bytes = "500MiB";
      demuxer-readahead-secs = 20;
      directory-mode = "ignore";
      directory-filter-types = "video,audio";
      autocreate-playlist = "same";

      osd-fonts-dir = "${unstablePkgs.mpvScripts.modernz}/share/fonts/truetype";

      icc-profile-auto = true;
      inverse-tone-mapping = true;
      scale = "ewa_lanczossharp";
      cscale = "bilinear";
      dscale = "ewa_robidouxsharp";
      linear-downscaling = false;

      ao = "pipewire";
      replaygain = "album";
      audio-display = "embedded-first";
      gapless-audio = "weak";
      audio-file-auto = "exact";

      sub-codepage = "gb18030";
      slang = "chs,sc,zh-Hans,zh-CN,cht,tc,zh-Hant,zh-HK,zh-TW,chi,zho,zh";
      sub-ass-vsfilter-color-compat = "full";
      sub-ass-style-overrides-append = [
        "Encoding=-1"
        "ScaledBorderAndShadow=no"
      ];
      sub-font-size = 50;
      sub-bold = true;
      sub-color = "#FFFFFF";
      sub-outline-size = 0.5;
      sub-outline-color = "#000000";
      sub-shadow-offset = 0.5;
      sub-back-color = "#000000";
      sub-spacing = 1;
      sub-blur = 0.5;
      sub-margin-x = 25;
      sub-margin-y = 22;
      sub-use-margins = true;
      sub-justify = "left";

      load-context-menu = true;
      ytdl-format = "bestvideo*+bestaudio/best";
      ytdl-raw-options-append = [
        "sub-langs=\"zh.*\""
        "write-subs="
        "write-auto-subs="
        "yes-playlist="
        "cookies-from-browser=Firefox"
      ];

      glsl-shaders-append = [
        "${mpvConfig}/shaders/igv/SSimDownscaler.glsl"
      ];
    };
  };
}
