{
  osConfig,
  lib,
  pkgs,
  unstablePkgs,
  ...
}: let
  anime4K_LowEnd = ''
    # Optimized shaders for lower-end GPU:
    CTRL+1 no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_M.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode A (Fast)"
    CTRL+2 no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_Soft_M.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode B (Fast)"
    CTRL+3 no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Upscale_Denoise_CNN_x2_M.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode C (Fast)"
    CTRL+4 no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_M.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_S.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode A+A (Fast)"
    CTRL+5 no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_Soft_M.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_Soft_S.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode B+B (Fast)"
    CTRL+6 no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Upscale_Denoise_CNN_x2_M.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_S.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode C+A (Fast)"

    CTRL+0 no-osd change-list glsl-shaders clr ""; show-text "GLSL shaders cleared"
  '';

  anime4K_HighEnd = ''
    # Optimized shaders for higher-end GPU:
    CTRL+1 no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_VL.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A (HQ)"
    CTRL+2 no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_Soft_VL.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B (HQ)"
    CTRL+3 no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode C (HQ)"
    CTRL+4 no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_VL.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_M.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A+A (HQ)"
    CTRL+5 no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_Soft_VL.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_Soft_M.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B+B (HQ)"
    CTRL+6 no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_M.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode C+A (HQ)"

    CTRL+0 no-osd change-list glsl-shaders clr ""; show-text "GLSL shaders cleared"
  '';

  anime4KInputs =
    if osConfig.networking.hostName != "high_end_not_used_for_now"
    then anime4K_LowEnd
    else anime4K_HighEnd;

  mpv-sockets =
    pkgs.runCommand "mpv-sockets"
    {
      passthru.scriptName = "mpvSockets.lua";
    }
    ''
      install -Dm644 ${pkgs.sources.mpv-sockets.src}/mpvSockets.lua $out/share/mpv/scripts/mpvSockets.lua
    '';
in {
  programs.mpv = {
    enable = true;
    package = pkgs.mpv.override {
      mpv-unwrapped =
        (pkgs.mpv-unwrapped.override {
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

          cddaSupport = true;
          vapoursynthSupport = true;
        }).overrideAttrs (old_: {
          inherit (pkgs.sources.mpv) src;
          version = "0.41.0-unstable-${pkgs.sources.mpv.date}";

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

      scripts = with pkgs.mpvScripts; [
        mpv-sockets
        dynamic-crop
        modernz
        mpris
        thumbfast
      ];

      extraMakeWrapperArgs = [
        # Add paths to required libraries
        "--prefix"
        "LD_LIBRARY_PATH"
        ":"
        "/run/opengl-driver/lib:${lib.makeLibraryPath [pkgs.ocl-icd]}"
      ];
    };

    config = {
      # HDR on supported displays
      vo = "gpu-next";
      target-colorspace-hint = true;
      gpu-api = "vulkan";
      gpu-context = "waylandvk";
      window-maximized = true;

      # High quality scaling
      cscale = "ewa_lanczossharp";
      hr-seek-framedrop = false;
      hwdec = "auto-copy";
      hwdec-codecs = "all";
      resume-playback = false;
      scale = "ewa_lanczossharp";

      # Prefer subtitles and audios: Chinese > English
      alang = "chi,zho,cmn,zh,eng,en";
      slang = "chi,zho,cmn,zh,eng,en";
    };
    extraInput = anime4KInputs;
  };
}
