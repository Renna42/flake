{
  lib,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    languagePacks = [
      "en-US"
      "zh-CN"
    ];
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
          "uBlock0@raymondhill.net" = {
            install_url = moz "ublock-origin";
          };
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = moz "bitwarden-password-manager";
            default_area = "navbar";
          };
          "{5cce4ab5-3d47-41b9-af5e-8203eea05245}" = {
            install_url = moz "control-panel-for-twitter";
          };
          "addon@darkreader.org" = {
            install_url = moz "darkreader";
          };
          "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
            install_url = moz "return-youtube-dislikes";
          };
          "firefox-extension@steamdb.info" = {
            install_url = moz "steam-database";
          };
          "firefox@tampermonkey.net" = {
            install_url = moz "tampermonkey";
            default_area = "navbar";
          };
          "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}" = {
            install_url = moz "user-agent-string-switcher";
          };
          "{74145f27-f039-47ce-a470-a662b129930a}" = {
            install_url = moz "clearurls";
          };
          "chrome-mask@overengineer.dev" = {
            install_url = moz "chrome-mask";
          };
          "redirect-nix-wiki@undesided.me" = {
            install_url = moz "redirectnixwiki";
          };
          "headereditor-amo@addon.firefoxcn.net" = {
            install_url = moz "header-editor";
          };
          "{0982b844-4f35-48b7-9811-6832d916f21c}" = {
            install_url = moz "hcfy";
            default_area = "navbar";
          };
          "addon@celeus.cn" = {
            install_url = moz "bewlycat";
          };
          "@ublacklist" = {
            install_url = moz "ublacklist";
          };
          "cors-everywhere@spenibus" = {
            install_url = moz "cors-everywhere";
          };
          "youtubetweak@dark495.me" = {
            install_url = moz "youtube-tweak";
          };
          "Google_AI_Overviews_Blocker@zachbarnes.dev" = {
            install_url = moz "hide-google-ai-overviews";
          };
        };
      DisplayBookmarksToolbar = "never";
      DisableFirefoxScreenshots = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableSetDesktopBackground = true;
      OfferToSaveLogins = false;
      NoDefaultBookmarks = true;
      PasswordManagerEnabled = false;
      Homepage.StartPage = "previous-session";
      Preferences = {
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.quitShortcut.disabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "gfx.webrender.all" = true;
        "gfx.x11-egl.force-enabled" = true;
        "widget.dmabuf.force-enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "browser.translations.automaticallyPopup" = false;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "browser.search.separatePrivateDefault" = false;
        "browser.search.separatePrivateDefault.ui.enabled" = true;
        "dom.security.https_first" = true;
        "extensions.autoDisableScopes" = 0;
        "extensions.update.autoUpdateDefault" = false;
        "extensions.update.enabled" = false;
      };
      SearchEngines = {
        "Default" = "Google";
        "Remove" = ["百度"];
      };
      RequestedLocales = "zh-cn,zh,zh-tw,zh-hk,en-us,en";
    };
    profiles.renna = {
      id = 0;
      isDefault = true;
      name = "Renna";
    };
  };
  stylix.targets.firefox.profileNames = [
    "renna"
  ];
}
