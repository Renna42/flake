{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    systemd = {
      enable = true;
      enableXdgAutostart = true;
      variables = ["--all"];
    };

    settings = {
      "$mainMod" = "SUPER";

      monitorv2 = {
        output = "desc:Technical Concepts Ltd R32U81 3L1257V001782";
        mode = "3840x2160@120";
        position = "0x0";
        scale = 1.25;
        vrr = 3;
        bitdepth = 10;
        cm = "hdr";
        sdrbrightness = 1.5;
        sdr_eotf = 2;
      };

      xwayland = {
        force_zero_scaling = true;
      };
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = "yes";
          scroll_factor = 0.3;
        };
        sensitivity = -0.1;
        accel_profile = "flat";
      };

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        # "col.active_border" = "rgba(5277c3aa) rgba(7ebae4aa) 45deg";
        # "col.inactive_border" = "rgba(2222227f)";
        allow_tearing = true;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        # shadow = {
        #   enabled = true;
        #   color = "rgba(0000005f)";
        #   color_inactive = "rgba(0000003f)";
        #   range = 25;
        # };
        blur = {
          enabled = true;
          size = 2;
          passes = 2;
          contrast = 1.2;
        };
      };

      debug = {
        disable_logs = false;
      };

      cursor = {
        no_hardware_cursors = true;
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windowsMove, 1, 7, myBezier"
          "windowsIn, 1, 3, default, popin 90%"
          "windowsOut, 1, 2, default, popin 95%"
          "border, 1, 3, default"
          "fade, 1, 3, default"
          "workspaces, 1, 5, default"
        ];
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = true;
        split_width_multiplier = 1.4;
      };

      misc = {
        force_default_wallpaper = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        render_unfocused_fps = 60;
        disable_hyprland_logo = true;
      };

      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      windowrulev2 = [
        "immediate, class:^(cs2)$"
        "tile,class:(Alacritty)"
        "tile,class:(kitty)"
        "float,class:(QQ)"
        "tile,class:(QQ),title:(QQ)"
        "float,title:(Volume Control)"
        "float,class:(steam)"
        "float,title:(Qt5 Configuration Tool)"
        "float,title:(Qt6 Configuration Tool)"
        "float,title:(Fcitx Configuration)"
        "float,class:(org.gnome.Nautilus)"
        "float,class:(org.kde.dolphin)"
        "float,class:(nemo)"
        "float,class:(eog)"
        "float,class:(org.kde.ark)"
        "float,class:(firefox),title:(Library)"
        "float,class:(vlc)"
        "float,class:(qemu.*)"
        "float,class:(org.telegram.desktop),title:(Media viewer)"
        "float,class:(io.github.tdesktop_x64.TDesktop),title:(Media viewer)"
        "float,class:(com.st.app.Main)"

        "float,class:(diel)"
        "float,class:(localsend)"
        "float,class:(com.github.hluk.copyq)"
        "size 642 652, class:(com.github.hluk.copyq)"
        "float, class:(clipse)"
        "size 642 652, class:(clipse)"
        "float, class:(yazi)"
        "size 1000 652, class:(yazi)"
        "bordercolor rgb(598da8) rgb(598da8), pinned:1"
        "renderunfocused,class:(vseeface.exe)"
        "opacity 0.0 override, class:^(xwaylandvideobridge)$"
        "noanim, class:^(xwaylandvideobridge)$"
        "noinitialfocus, class:^(xwaylandvideobridge)$"
        "maxsize 1 1, class:^(xwaylandvideobridge)$"
        "noblur, class:^(xwaylandvideobridge)$"
        "nofocus, class:^(xwaylandvideobridge)$"
      ];

      layerrule = [
        "blur on, match:namespace waybar"
        "ignore_alpha 0, match:namespace waybar"
        "blur on, match:namespace notifications"
        "ignore_alpha 0, match:namespace notifications"
        "blur on, match:namespace launcher"
        "ignore_alpha 0, match:namespace launcher"
      ];

      bind = [
        # Function Key bindings
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- --limit 1"
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1"
        ",XF86PowerOff, exec, pidof wlogout || wlogout"
        ",XF86Calculator, exec, [float] flatpak run org.kde.kcalc"

        # Hyprland hotkeys
        "$mainMod, Q, killactive, "
        "$mainMod, T, exec, kitty "
        "$mainMod, M, exec, loginctl terminate-user "
        "$mainMod, E, exec, [float] nemo"
        "$mainMod, F, togglefloating, "
        "$mainMod, R, exec, tofi-drun | xargs hyprctl dispatch exec --"
        "ALT, SPACE, exec, tofi-drun | xargs hyprctl dispatch exec --"
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod, J, togglesplit, # dwindle"
        "$mainMod, G, fullscreen"
        "$mainMod, U, bringactivetotop"
        "$mainMod, O, dpms, on"
        "$mainMod, Z, pin"
        "$mainMod, L, exec, loginctl lock-session"
        "$mainMod CTRL, L, exec, pidof wlogout || wlogout"

        # Hyprland some reload exec-once
        "$mainMod CTRL ALT, R, exec, killall waybar; waybar"
        "$mainMod CTRL ALT, R, exec, killall fcixt5; fcitx5"

        # Screenshot
        # "$mainMod SHIFT, S, exec, ${../../../assets/scripts/screenshot.sh} region"
        # "$mainMod SHIFT, W, exec, ${../../../assets/scripts/screenshot.sh} window"
        # ",print , exec, ${../../../assets/scripts/screenshot.sh}A fullscreen"

        "$mainMod, V, exec, copyq toggle"
        "$mainMod SHIFT, C, exec, hyprpicker -a"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;
  };

  home.packages = with pkgs; [
    grim
    wl-clipboard
    slurp
  ];

  xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}
