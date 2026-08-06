{
  lib,
  pkgs,
  ...
}: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc-ut
        kdePackages.fcitx5-qt
      ];
      settings = {
        globalOptions = {
          Hotkey = {
            AltTriggerKeys = "";
            EnumerateWithTriggerKeys = true;
            EnumerateSkipFirst = false;
          };
          Behavior = {
            ActiveByDefault = true;
            resetStateWhenFocusIn = "No";
            ShareInputState = "All";
            showInputMethodInformationWhenFocusIn = true;
          };
        };
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "rime";
          "Groups/0/Items/2".Name = "mozc";
        };
        addons = {
          classicui = {
            globalSection = {
              Font = lib.mkForce "MiSans 12";
              UseInputMethodLanguageToDisplayText = true;
              PerScreenDPI = false;
              ForceWaylandDPI = 0;
              EnableFractionalScale = true;
            };
          };
        };
      };
    };
  };
}
