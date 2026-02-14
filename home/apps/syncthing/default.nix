{
  lib,
  config,
  secretsPath,
  hostname,
  ...
}: let
  stSopsFile = "${secretsPath}/st-${hostname}.yaml";
  captureOnePath = "${config.home.homeDirectory}/Pictures/Capture One Catalog Share";
in {
  options = {
    renna.syncthing = {
      captureone = lib.mkEnableOption "Enable Syncthing folder `Capture One Catalog Share`";
    };
  };

  config = {
    sops.secrets = {
      st_cert = {
        format = "yaml";
        sopsFile = stSopsFile;
      };
      st_key = {
        format = "yaml";
        sopsFile = stSopsFile;
      };
    };

    services.syncthing = {
      enable = true;
      cert = config.sops.secrets.st_cert.path;
      key = config.sops.secrets.st_key.path;
      settings = {
        devices = {
          IzmnAS = {
            name = "IzmnAS";
            id = "STXWTMY-JLIKVJV-7CF5KUN-RZNASSQ-APVZNRO-FQQ3MEK-NLXNSIC-F2JK6Q3";
          };
        };
        folders = {
          captureone = lib.mkIf config.renna.syncthing.captureone {
            id = "captureone";
            label = "Capture One Catalog Share";
            path = captureOnePath;
            devices = [
              "IzmnAS"
            ];
          };
        };
        options = {
          localAnnounceEnabled = true;
          relaysEnabled = true;
          urAccepted = -1; # No submitting anonymous usage data
        };
      };
    };

    home.file."${captureOnePath}/.stignore".text = lib.optionalString config.renna.syncthing.captureone ''
      .DS_Store
      Cache/
    '';
  };
}
