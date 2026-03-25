{
  config,
  lib,
  pkgs,
  hostname,
  ...
}: {
  environment.systemPackages = with pkgs; [
    git
  ];

  networking.hostName = hostname;
  networking.computerName = hostname;

  time.timeZone = "Asia/Shanghai";

  system = {
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    # This will be run as root. Take care.
    activationScripts.postActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      sudo -u ${config.system.primaryUser} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      smb.NetBIOSName = hostname;
      controlcenter.BatteryShowPercentage = true;
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;

      menuExtraClock = {
        Show24Hour = true; # show 24 hour clock
        ShowDate = 1; # always show full date when space allows
        ShowDayOfWeek = true; # show day with week
        ShowSeconds = true; # show clock with second precision
      };

      dock = {
        orientation = "bottom";
        autohide = true; # automatically hide and show the dock
        show-recents = false; # do not show recent apps in dock
        mru-spaces = false; # do not automatically rearrange spaces based on most recent use.
        expose-group-apps = true; # Group windows by application
        mineffect = "scale";
        launchanim = false;
      };

      finder = {
        _FXShowPosixPathInTitle = true; # show full path in finder title
        AppleShowAllExtensions = true; # show all file extensions
        FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
        QuitMenuItem = true; # enable quit menu item
        ShowPathbar = true; # show path bar
        ShowStatusBar = true; # show status bar
      };

      trackpad = {
        Clicking = true; # enable tap to click
        TrackpadRightClick = true; # enable two finger right click
        TrackpadThreeFingerDrag = true; # enable three finger drag
      };

      NSGlobalDomain = {
        "com.apple.keyboard.fnState" = true;
        "com.apple.swipescrolldirection" = true;
        AppleInterfaceStyle = "Dark"; # dark mode
        ApplePressAndHoldEnabled = false;
        AppleICUForce24HourTime = true;
        AppleMeasurementUnits = "Centimeters";
        AppleTemperatureUnit = "Celsius";
        AppleMetricUnits = 1;

        KeyRepeat = 2;
        InitialKeyRepeat = 25;

        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
      };

      CustomUserPreferences = {
        "com.apple.finder" = {
          AppleShowAllFiles = true;
          ShowExternalHardDrivesOnDesktop = true;
          ShowHardDrivesOnDesktop = true;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
          _FXSortFoldersFirst = true;
          # When performing a search, search the current folder by default
          FXDefaultSearchScope = "SCcf";
        };
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.screencapture" = {
          location = "~/Desktop";
          type = "png";
        };
        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
          allowIdentifierForAdvertising = false;
        };
        "com.apple.Maps".AppleLanguages = [
          "(zh-CN)"
        ];
        # Prevent Photos from opening automatically when devices are plugged in
        "com.apple.ImageCapture".disableHotPlug = true;
      };

      loginwindow = {
        GuestEnabled = false;
        SHOWFULLNAME = false;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      # Skip this when using external keyboard
      # swapLeftCtrlAndFn = true;
    };

    startup.chime = false;
  };

  security = {
    pam.services.sudo_local.touchIdAuth = true;
    pki.certificateFiles = [
      "${pkgs.dn42-cacert}/etc/ssl/certs/dn42-ca.crt"
    ];
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;

  programs.fish = {
    enable = true;
    useBabelfish = true;
  };

  environment.shells = with pkgs; [
    zsh
    fish
  ];

  environment.variables.SOPS_AGE_KEY_FILE = "$HOME/.config/sops/age/keys.txt";

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";
  system.stateVersion = 6;
}
