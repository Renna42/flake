{
  description = "Renna's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    assetsPath = ./assets;
    usersDir = ./modules/users;
    users = lib.mapAttrsToList (
      name: type: lib.removeSuffix ".nix" name
    ) (builtins.readDir usersDir);
    makeNixosSystem = {
      hostname,
      system,
    }:
      lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            inputs
            users
            assetsPath
            hostname
            ;
        };
        modules =
          [
            {
              nixpkgs.overlays = [
                (final: prev: {
                  inherit
                    (prev.lixPackageSets.stable)
                    nixpkgs-review
                    nix-eval-jobs
                    nix-fast-build
                    colmena
                    ;
                })
                inputs.nix4vscode.overlays.default
                inputs.niri.overlays.niri
              ];
              nixpkgs.config.allowUnfree = true;
            }
            ./hosts/${hostname}.nix
            ./hardwares/${hostname}.nix
            inputs.stylix.nixosModules.stylix
            inputs.niri.nixosModules.niri
            inputs.hyprland.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
          ]
          ++ (lib.filesystem.listFilesRecursive usersDir);
      };
  in {
    nixosConfigurations = {
      Mizuka = makeNixosSystem {
        hostname = "Mizuka";
        system = "x86_64-linux";
      };
    };
    formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
