{
  flake,
  nixosConfig,
  lib,
}: let
  getInputDrvs = pkgs: flakeLock:
    lib.attrsets.mapAttrsToList (
      name: value:
      # Reuse flake inputs
        if builtins.hasAttr name flake.inputs
        then flake.inputs."${name}"
        else if name == "root"
        then flake
        else if value.locked.type == "github"
        then
          pkgs.fetchFromGitHub {
            inherit (value.locked) owner repo rev;
            hash = value.locked.narHash;
          }
        else if value.locked.type == "gitlab"
        then
          pkgs.fetchFromGitLab {
            inherit (value.locked) owner repo rev;
            domain = value.locked.host;
            hash = value.locked.narHash;
          }
        else
          pkgs.fetchgit {
            inherit (value.locked) url rev;
            hash = value.locked.narHash;
          }
    )
    flakeLock.nodes;
  flakeLock = lib.importJSON "${flake}/flake.lock";
in
  nixosConfig
  // {
    offlineInstaller =
      (lib.nixosSystem {
        modules = [
          (
            {
              modulesPath,
              pkgs,
              ...
            }: {
              imports = [(modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")];

              nixpkgs.hostPlatform = nixosConfig.config.nixpkgs.hostPlatform;

              nix.settings = {
                experimental-features = [
                  "nix-command"
                  "flakes"
                ];
                substituters = [
                  "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
                  "https://mirrors.ustc.edu.cn/nix-channels/store"
                  "https://nix-community.cachix.org"
                ];
                trusted-public-keys = [
                  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                ];
              };

              environment.defaultPackages = with pkgs; [
                nixos-anywhere
                just
                disko
                nh
              ];

              isoImage = {
                contents = [
                  {
                    source = flake.outPath;
                    target = "/flake";
                  }
                ];
                storeContents =
                  [
                    nixosConfig.config.system.build.toplevel
                  ]
                  ++ (getInputDrvs pkgs flakeLock);
                includeSystemBuildDependencies = false;
              };

              users.users.root = {
                isSystemUser = true;
                shell = pkgs.bashInteractive;
                initialHashedPassword = lib.mkForce "$y$j9T$KHYs8lBhE5S.gupM7N/QE/$zurxi/XMT5n6aACZu9tz3RBLBQ6Ge/eCUwODOjRMqe0";
                openssh.authorizedKeys.keys = lib.mkForce [
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHL5pMTK8LGrizHB2VvgL1RG9cNKxAhYXb59NqSyAwpw"
                ];
              };
            }
          )
        ];
      }).config.system.build.isoImage;
  }
