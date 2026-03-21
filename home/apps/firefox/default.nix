{
  lib,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    package =
      if pkgs.stdenv.isLinux
      then pkgs.firefox
      else null;
    languagePacks =
      if pkgs.stdenv.isLinux
      then ["zh-CN" "en-US"]
      else [];
    policies = {
      DisableAppUpdate = true;
      ExtensionSettings = let
        moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
      in
        lib.mapAttrs
        (
          _: value:
            {
              installation_mode = "force_installed";
              default_area = "menupanel";
            }
            // value
        )
        {
          # keep-sorted start block=yes case=no
          "@ublacklist" = {
            install_url = moz "ublacklist";
          };
          "addon@celeus.cn" = {
            install_url = moz "bewlycat";
          };
          "addon@darkreader.org" = {
            install_url = moz "darkreader";
          };
          "cors-everywhere@spenibus" = {
            install_url = moz "cors-everywhere";
          };
          "firefox-extension@steamdb.info" = {
            install_url = moz "steam-database";
          };
          "firefox@tampermonkey.net" = {
            install_url = moz "tampermonkey";
            default_area = "navbar";
          };
          "Google_AI_Overviews_Blocker@zachbarnes.dev" = {
            install_url = moz "hide-google-ai-overviews";
          };
          "headereditor-amo@addon.firefoxcn.net" = {
            install_url = moz "header-editor";
          };
          "redirect-nix-wiki@undesided.me" = {
            install_url = moz "redirectnixwiki";
          };
          "sponsorBlocker@ajay.app" = {
            install_url = moz "sponsorblock";
          };
          "uBlock0@raymondhill.net" = {
            install_url = moz "ublock-origin";
          };
          "{0982b844-4f35-48b7-9811-6832d916f21c}" = {
            install_url = moz "hcfy";
            default_area = "navbar";
          };
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = moz "bitwarden-password-manager";
            default_area = "navbar";
          };
          "{74145f27-f039-47ce-a470-a662b129930a}" = {
            install_url = moz "clearurls";
          };
          "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}" = {
            install_url = moz "user-agent-string-switcher";
          };
          # keep-sorted end
        };
      # keep-sorted start block=yes
      DisableFirefoxStudies = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableSetDesktopBackground = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "never";
      HardwareAcceleration = true;
      Homepage.Locked = true;
      Homepage.StartPage = "none";
      Homepage.URL = "chrome://browser/content/blanktab.html";
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      Preferences = {
        # keep-sorted start
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.ml.chat.enabled" = false;
        "browser.ml.enable" = false;
        "browser.ml.linkPreview.enable" = false;
        "browser.ml.pageAssist.enable" = false;
        "browser.ml.smartAssist.enable" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.quitShortcut.disabled" = true;
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.search.separatePrivateDefault" = false;
        "browser.search.separatePrivateDefault.ui.enabled" = true;
        "browser.tabs.groups.smart.enabled" = false;
        "browser.tabs.groups.smart.userEnabled" = false;
        "dom.security.https_first" = true;
        "extensions.autoDisableScopes" = 0;
        "extensions.ml.enabled" = false;
        "extensions.update.autoUpdateDefault" = false;
        "extensions.update.enabled" = false;
        "gfx.webrender.all" = true;
        "gfx.x11-egl.force-enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "widget.dmabuf.force-enabled" = true;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        # keep-sorted end
      };
      RequestedLocales = "zh-cn,zh,zh-tw,zh-hk,en-us,en";
      SearchEngines = {
        "Remove" = ["百度"];
      };
      # keep-sorted end
    };
    profiles.renna = {
      id = 0;
      isDefault = true;
      name = "Renna";

      search = {
        force = true;
        default = "google";
        privateDefault = "google";

        engines = {
          mynixos = {
            name = "MyNixOS";
            urls = [
              {
                template = "https://mynixos.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
            definedAliases = ["@mn"];
          };

          nixos-wiki = {
            name = "NixOS Wiki";
            urls = [
              {
                template = "https://wiki.nixos.org/w/index.php";
                params = [
                  {
                    name = "search";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@nw"];
          };

          noogle = {
            name = "Noogle";
            urls = [
              {
                template = "https://noogle.dev/q";
                params = [
                  {
                    name = "term";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@no"];
          };

          bing.metaData.hidden = true;
          google.metaData.alias = "@g"; # builtin engines only support specifying one additional alias
        };
      };
    };
  };
  stylix.targets.firefox.profileNames = [
    "renna"
  ];
}
