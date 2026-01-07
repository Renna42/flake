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
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    assetsPath = ./assets;
    makeNixosSystem = {
      hostname,
      system,
    }:
      lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            inputs
            assetsPath
            hostname
            ;
        };
        modules = [
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
            ];
            nixpkgs.config.allowUnfree = true;
          }
          ./hosts/${hostname}.nix
          ./hardwares/${hostname}.nix
          inputs.stylix.nixosModules.stylix
          inputs.hyprland.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
        ];
      };

    forAllSystems = lib.genAttrs lib.systems.flakeExposed;
  in {
    nixosConfigurations = {
      Mizuka = makeNixosSystem {
        hostname = "Mizuka";
        system = "x86_64-linux";
      };
    };
    formatter = forAllSystems (
      system: inputs.nixpkgs.legacyPackages.${system}.alejandra
    );
  };
}
