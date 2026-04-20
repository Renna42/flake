{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      arion
      docker-client
      podman-compose
    ]
    ++ config.virtualisation.podman.extraPackages;

  virtualisation = {
    docker.enable = false;
    podman = {
      enable = true;
      autoPrune = {
        enable = true;
        flags = ["-af"];
      };
      package = pkgs.podman;
      dockerSocket.enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      extraPackages = with pkgs; [
        nftables
      ];
    };
    containers.containersConf.settings = {
      network.firewall_driver = "nftables";
      engine.cdi_spec_dirs = [
        "/etc/cdi"
        "/var/run/cdi"
      ];
    };
  };

  systemd.services =
    {
      podman-auto-update.enable = true;
    }
    // (lib.mapAttrs' (
        k: v:
          lib.nameValuePair "podman-${k}" {
            environment.TMPDIR = "/var/cache/podman-download";
          }
      )
      config.virtualisation.oci-containers.containers);

  systemd.timers.podman-auto-update.enable = true;

  systemd.tmpfiles.settings = {
    podman-download = {
      "/var/cache/podman-download"."d" = {
        mode = "755";
        user = "root";
        group = "root";
      };
    };
  };

  users.users.renna.extraGroups = ["podman"];

  virtualisation.oci-containers.backend = "podman";

  # Make sure auto update is enabled for all containers
  assertions =
    lib.mapAttrsToList (n: v: {
      assertion = (v.labels."io.containers.autoupdate" or "") != "";
      message = "Container ${n} does not have auto update enabled";
    })
    config.virtualisation.oci-containers.containers;
}
