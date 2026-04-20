{
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ../../gui/stylix.nix
  ];

  networking = {
    hostName = hostname;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    # proxy = {
    #   default = "http://10.22.0.114:7890";
    #   noProxy = "127.0.0.1,localhost,internal.domain";
    # };
    firewall = {
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
      enable = false;
    };
  };

  services.resolved.enable = true;
  services.udisks2.enable = true;

  programs.xwayland.enable = true;

  # Building man-cache is too slow, use this trick to inhibit it.
  # Only do that on my desktop machines because we have `fish`.
  # Source: https://discourse.nixos.org/t/slow-build-at-building-man-cache/52365
  documentation.man.cache.enable = false;

  # Set hardware time to local
  time.hardwareClockInLocalTime = true;

  boot.consoleLogLevel = 3;

  hardware = {
    block = {
      defaultScheduler = "mq-deadline";
      defaultSchedulerRotational = "bfq";
      scheduler."nvme[0-9]*" = "none";
    };
    enableRedistributableFirmware = true;
  };

  systemd = {
    settings.Manager = {
      DefaultTimeoutStartSec = "15s";
      DefaultTimeoutStopSec = "10s";

      DefaultLimitNOFILE = "2048:2097152";
    };
    user.extraConfig = ''
      DefaultLimitNOFILE=1024:1048576
    '';
    tmpfiles.rules = [
      # Improve performance for applications that use tcmalloc
      # https://github.com/google/tcmalloc/blob/master/docs/tuning.md#system-level-optimizations
      "w! /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"

      # THP Shrinker has been added in the 6.12 Kernel
      # Default Value is 511
      # THP=always policy vastly overprovisions THPs in sparsely accessed memory areas, resulting in excessive memory pressure and premature OOM killing
      # 409 means that any THP that has more than 409 out of 512 (80%) zero filled filled pages will be split.
      # This reduces the memory usage, when THP=always used and the memory usage goes down to around the same usage as when madvise is used, while still providing an equal performance improvement
      "w! /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none - - - - 409"
    ];
  };

  environment = {
    # Webkit2gtk fixes
    variables.WEBKIT_DISABLE_COMPOSITING_MODE = "1";
    systemPackages = with pkgs; [
      clinfo
      libva-utils
      vdpauinfo
      xdg-user-dirs
    ];
  };

  sops.age.keyFile = "/home/renna/.config/sops/age/keys.txt";
}
