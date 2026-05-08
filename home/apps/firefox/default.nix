{
  inputs,
  lib,
  pkgs,
  ...
}: let
  profileName = "renna";

  p11-kit-proxy =
    if pkgs.stdenv.isDarwin
    then "${pkgs.p11-kit}/lib/p11-kit-proxy.dylib"
    else "${pkgs.p11-kit}/lib/p11-kit-proxy.so";
  p11-kit-trust =
    if pkgs.stdenv.isDarwin
    then "${pkgs.p11-kit}/lib/pkcs11/p11-kit-trust.dylib"
    else "${pkgs.p11-kit}/lib/pkcs11/p11-kit-trust.so";

  redirectnixwiki = inputs.firefox-addons.lib.buildFirefoxAddon rec {
    pname = "RedirectNixWiki";
    version = "1.0";
    addonId = "redirect-nix-wiki@undesided.me";
    derivationArgs = {
      src = pkgs.fetchurl {
        url = "https://addons.mozilla.org/firefox/downloads/file/4373121/redirectnixwiki-1.0.xpi";
        hash = "sha256-ygnfXIv5bW7TTuh1PezvGICZq3fCSQ+G7hclRSNv0D8=";
      };
      meta = {
        addonName = pname;
        platform = lib.platforms.all;
        license = lib.licenses.mit;
      };
    };
  } {inherit lib pkgs;};
in {
  imports = [inputs.betterfox-nix.homeModules.betterfox];

  programs.firefox = {
    enable = true;
    package =
      if pkgs.stdenv.isLinux
      then pkgs.firefox
      else null;
    languagePacks =
      if pkgs.stdenv.isLinux
      then [
        "zh-CN"
        "en-US"
      ]
      else [];
    betterfox = {
      enable = true;
      profiles.${profileName}.settings = {
        fastfox.enable = true;
        securefox.enable = true;
        peskyfox.enable = true;
      };
    };
    policies = {
      # keep-sorted start block=yes
      AIControls = {
        Default = {
          Value = "blocked";
          Locked = true;
        };
      };
      Certificates = {
        ImportEnterpriseRoots = true;
      };
      DNSOverHTTPS = {
        Enabled = false;
        Locked = true;
      };
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableSetDesktopBackground = true;
      DisableTelemetry = true;
      DisabledCiphers = {
        "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256" = false;
        "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256" = false;
        "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256" = false;
        "TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256" = false;
        "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384" = false;
        "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384" = false;

        # Reenabled for breaking many sites
        "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA" = false;
        "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA" = false;
        "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA" = false;
        "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA" = false;
        "TLS_DHE_RSA_WITH_AES_128_CBC_SHA" = false;
        "TLS_DHE_RSA_WITH_AES_256_CBC_SHA" = false;
        "TLS_RSA_WITH_AES_128_GCM_SHA256" = false;
        "TLS_RSA_WITH_AES_256_GCM_SHA384" = false;
        "TLS_RSA_WITH_AES_128_CBC_SHA" = false;
        "TLS_RSA_WITH_AES_256_CBC_SHA" = false;
        "TLS_RSA_WITH_3DES_EDE_CBC_SHA" = false;
      };
      DisplayBookmarksToolbar = "never";
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Category = "standard";
      };
      FirefoxHome = {
        Highlights = false;
        Locked = true;
        Pocket = false;
        Search = true;
        Snippets = false;
        SponsoredPocket = false;
        SponsoredTopSites = false;
        TopSites = false;
      };
      GenerativeAI = {
        Enabled = false;
        Locked = true;
      };
      HardwareAcceleration = true;
      Homepage = {
        URL = "about:home";
        Locked = true;
        StartPage = "homepage";
      };
      IPProtectionAvailable = false;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      PasswordManagerEnabled = false;
      RequestedLocales = "zh-cn,zh,zh-tw,zh-hk,en-us,en";
      SearchBar = "unified";
      SearchEngines = {
        "Remove" = ["百度"];
      };
      SearchSuggestEnabled = true;
      SecurityDevices = {
        Add = {
          inherit p11-kit-proxy p11-kit-trust;
        };
      };
      ShowHomeButton = false;
      SkipTermsOfUse = true;
      TranslateEnabled = false;
      UseSystemPrintDialog = true;
      UserMessaging = {
        WhatsNew = false;
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
      };
      # keep-sorted end
      ExtensionSettings = {
        # keep-sorted start block=yes case=no
        "firefox@tampermonkey.net" = {
          default_area = "navbar";
        };
        "{0982b844-4f35-48b7-9811-6832d916f21c}" = {
          default_area = "navbar";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          default_area = "navbar";
        };
        # keep-sorted end
      };
      Preferences = {
        # keep-sorted start
        "browser.aboutConfig.showWarning" = false;
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.quitShortcut.disabled" = true;
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.tabs.unloadTabInContextMenu" = true;
        "dom.security.https_first" = true;
        "extensions.autoDisableScopes" = 0; # Auto enable installed extensions
        "extensions.ml.enabled" = false;
        "extensions.update.autoUpdateDefault" = false;
        "extensions.update.enabled" = false;
        "extensions.webextensions.ExtensionStorageIDB.enabled" = false; # Make home-manager extension config work
        "gfx.wayland.hdr" = false; # FIXME: causes crashes
        "gfx.wayland.hdr.force-enabled" = false; # FIXME: causes crashes
        "gfx.webrender.all" = true;
        "gfx.webrender.compositor.force-enabled" = false; # FIXME: causes crashes
        "gfx.x11-egl.force-enabled" = true;
        "image.avif.enabled" = true;
        "image.jxl.enabled" = true;
        "media.av1.enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "media.hevc.enabled" = true;
        "media.hls.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "media.videocontrols.picture-in-picture.enabled" = false;
        "security.insecure_connection_text.enabled" = true;
        "security.insecure_connection_text.pbmode.enabled" = true;
        "security.osclientcerts.autoload" = true;
        "svg.context-properties.content.enabled" = true;
        "widget.dmabuf.force-enabled" = true;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        # keep-sorted end
      };
    };
    profiles.${profileName} = {
      id = 0;
      isDefault = true;
      name = "Renna";

      extensions = {
        packages = with pkgs.firefox-addons; [
          # keep-sorted start
          bewlycat
          bitwarden-password-manager
          clearurls
          cors-everywhere
          darkreader
          hcfy
          header-editor
          hide-google-ai-overviews
          redirectnixwiki
          sponsorblock
          steam-database
          tampermonkey
          ublacklist
          ublock-origin
          user-agent-string-switcher
          # keep-sorted end
        ];
        force = true;
      };

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
  stylix.targets.firefox.profileNames = [profileName];

  home.sessionVariables = {
    MOZ_X11_EGL = "1";
    MOZ_USE_XINPUT2 = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };
}
