{hostname, ...}: {
  system = {
    defaults = {
      CustomUserPreferences = {
        "com.adobe.crashreporter".always_never_send = true;

        "com.microsoft.Word" = {
          SendAllTelemetryEnabled = false;
          UseOnlineContent = false;
        };
        "com.microsoft.Excel" = {
          SendAllTelemetryEnabled = false;
          UseOnlineContent = false;
        };
        "com.microsoft.Powerpoint" = {
          SendAllTelemetryEnabled = false;
          UseOnlineContent = false;
        };
        "com.microsoft.Outlook".SendAllTelemetryEnabled = false;
        "com.microsoft.onenote.mac".SendAllTelemetryEnabled = false;
        "com.microsoft.autoupdate2" = {
          AcknowledgedDataCollectionPolicy = "RequiredDataOnly";
          HowToCheck = "AutomaticDownload";
        };

        "org.localsend.localsendApp" = {
          "flutter.ls_alias" = hostname;
          "flutter.ls_color" = "system";
          "flutter.ls_minimize_to_tray" = true;
          launchAtLoginMinimized = 1;
        };

        "com.jordanbaird.Ice" = {
          SUAutomaticallyUpdate = false;
          SUEnableAutomaticChecks = false;
          SUHasLaunchedBefore = true;
        };

        "com.coteditor.CotEditor" = {
          SUAutomaticallyUpdate = false;
          SUEnableAutomaticChecks = false;
          SUHasLaunchedBefore = true;
          defaultTheme = "Dendrobates (Dark)";
        };

        "com.colliderli.iina" = {
          SUAutomaticallyUpdate = false;
          SUEnableAutomaticChecks = false;
          SUHasLaunchedBefore = true;
          SUSendProfileInfo = false;
          audioDriverEnableAVFoundation = true;
        };
      };
    };
  };
}
