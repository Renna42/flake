{
  config,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        spacing = 6;
        margin-top = 8;
        margin-left = 8;
        margin-right = 8;
        margin-bottom = 0;
        height = 36;

        modules-left = ["hyprland/window"];
        modules-center = ["hyprland/workspaces"];
        modules-right = ["tray" "pulseaudio" "network" "memory" "cpu" "battery" "clock"];

        "hyprland/workspaces" = {
          format = "{icon}";
          persistent-workspaces = {
            "*" = 10;
          };
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          format-icons = {
            "1" = ""; # \uf313
            "2" = ""; # \uf121
            "3" = ""; # \uf484
            "4" = "⚙"; # \uf013
            "5" = ""; # \uf11b
          };
        };

        "hyprland/window" = {
          format = " {initialTitle}";
          separate-outputs = true;
        };

        tray = {
          icon-size = 21;
          spacing = 10;
        };

        clock = {
          interval = 1;
          format = " {:%H:%M:%S}";
          format-alt = " {:%Y-%m-%d %H:%M:%S}";
          tooltip-format = "{calendar}";
          timezone = "Asia/Shanghai";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'>{}</span>";
              days = "<span color='#ecc6d9'>{}</span>";
              weeks = "<span color='#99ffdd'>W{}</span>";
              weekdays = "<span color='#ffcc66'>{}</span>";
              today = "<span color='#ff6699'><u>{}</u></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        cpu = {
          interval = 1;
          format = " {usage:1}%";
          tooltip = true;
        };

        memory = {
          interval = 1;
          format = " {used:0.1f}G";
          tooltip = true;
          tooltip-format = " RAM: {used:0.2f}G / {total:0.2f}G\nSwap: {swapUsed:0.2f}G / {swapTotal:0.2f}G";
        };

        network = {
          interval = 1;
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = " {ifname}";
          format-linked = " No IP ({ifname})";
          format-disconnected = " Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}, Gateway: {gwaddr}";
          format-alt = " {ipaddr}/{cidr}";
        };

        pulseaudio = {
          "scroll-step" = 5;
          format = "{icon} {volume:2}%";
          format-muted = "";
          format-bluetooth = "{icon} {volume}%";
          format-bluetooth-muted = " {icon}";
          format-icons = {
            default = ["" "" ""];
          };
          on-click-right = "pavucontrol";
          ignored-sinks = ["Easy Effects Sink"];
        };

        battery = {
          bat = "BAT0";
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-icons = ["" "" "" "" ""];
          max-length = 25;
        };
      };
    };

    style = ''
      * {
          text-shadow: none;
      }

      window#waybar {
          /* Large size for shorter side padding*/
          /* border-radius: 100px */
          background-color: transparent;
      }

      .modules-left {
          border-radius: 100px;
          background-color: rgba(18, 18, 18, 1.0);
          padding: 0 8px;
      }

      .modules-center {
          border-radius: 100px;
          background-color: rgba(18, 18, 18, 1.0);
      }

      .modules-right {
          border-radius: 100px;
          background-color: rgba(18, 18, 18, 1.0);
          padding: 0 8px;
      }

      tooltip {
          background-color: rgba(18, 18, 18, 1.0);
          border: 1px solid rgba(34, 34, 34, 0.5);
          border-radius: 15px;

          font-family: "Inconsolata SemiBold", "Symbols Nerd Font";
          font-size: 16px;
      }

      #clock,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #tray,
      #mode,
      #window,
      #workspaces {
          margin-top: 0px;
          margin-bottom: 0px;
          padding: 0px 6px 0px 6px;
          background-color: transparent;

          font-family: "Inconsolata SemiBold", "Symbols Nerd Font";
          font-size: 16px;
      }

      #workspaces {
          /* border: rgba(255, 255, 255, 0.2) solid 2px; */
          padding: 4px 12px;

          transition-property: background, color, border;
          transition-duration: 0.2s;
      }

      #workspaces button {
          border: none;
          border-radius: 0px;
          padding: 0px 0px;
          background: transparent;
          color: #ffffff;
          margin: 0 4px;
          min-width: 24px;

          transition-property: background, color, border, margin, padding;
          transition-duration: 0.2s;
      }

      #workspaces button:hover {
          /* background: rgba(255, 255, 255, 0.5); */
          color: rgba(255, 255, 255, 0.5);
      }

      #workspaces button.empty {
          color: rgba(255, 255, 255, 0.25);
      }

      #workspaces button.active {
          /* background: #ffffff; */
          color: #ffffff;
          border-bottom: 3px solid #ffffff;
          margin-bottom: 1px;
          /* padding: 0 4px; */
      }

      #workspaces button.urgent {
          color: #eb4d4b;
          border-bottom: 3px solid #eb4d4b;
      }

      #mode {
          background-color: #64727D;
          border-bottom: 3px solid #ffffff;
      }

      #clock {
          color: #eefff1;
      }

      #cpu {
          color: #FE968B;
      }

      #memory {
          color: #FFEAAA;
      }

      #pulseaudio {
          color: #a4e4fe;
      }

      #network {
          color: #b0f5e5;
      }

      #tray {
          /* border: rgba(255, 255, 255, 0.2) solid 2px; */
          color: transparent;
      }

      #window {
          color: #e6f2d6;
          margin-left: 4px;
      }
    '';
  };
}
