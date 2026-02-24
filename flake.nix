{
  description = "Renna's System Flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://attic.xuyh0120.win/lantian"
      "https://cache.garnix.io"
      "https://renna42.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "renna42.cachix.org-1:AqHSiL2lFKYHYJ0U2YFiW1kjItvFMmyyc6loFZR3/X8="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Using kernel 6.18 version because NVIDIA breaked it.
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    direnv-instant.url = "github:Mic92/direnv-instant";
    catppuccin.url = "github:catppuccin/nix";
    # hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    flake-utils,
    ...
  } @ inputs: let
    assetsPath = ./assets;
    secretsPath = ./secrets;

    overlays = nixpkgs.lib.attrValues self.overlays;
    globalSpecialArgs = {
      inherit
        inputs
        assetsPath
        secretsPath
        overlays
        ;
    };
    nixosMachines = [
      "Mizuka"
      "Quebec"
    ];
    darwinMachines = ["Schwarzschild"];
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.git-hooks-nix.flakeModule
        inputs.treefmt-nix.flakeModule
        inputs.flake-parts.flakeModules.easyOverlay
        inputs.home-manager.flakeModules.home-manager
      ];

      systems = flake-utils.lib.defaultSystems;
      perSystem = {
        self',
        pkgs,
        config,
        system,
        ...
      }: let
        # rename `self.legacyPackages.*.packages` -> `self.legacyPackages.*.packages'`
        # `self.legacyPackages.*.packages` collides with `self.packages` in nix cli
        adjustLegacyPackages = pkgs:
          nixpkgs.lib.attrsets.removeAttrs pkgs ["packages"]
          // {packages' = pkgs.packages;};

        pkgs' = import self.inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        legacyPackages = adjustLegacyPackages (self.lib.makePackages pkgs' ./pkgs {});
        packages = flake-utils.lib.flattenTree self'.legacyPackages;

        overlayAttrs = {
          flakePackages = pkgs.lib.recurseIntoAttrs self'.legacyPackages;
        };

        treefmt = {
          programs = {
            alejandra.enable = true;
            deadnix = {
              enable = true;
              no-lambda-arg = true;
              no-lambda-pattern-names = true;
            };
            statix = {
              enable = true;
              disabled-lints = ["repeated_keys" "faster_zipattrswith"];
            };
            keep-sorted.enable = true;
          };
        };

        pre-commit.settings = {
          package = pkgs.prek;
          hooks.treefmt = {
            enable = true;
            packageOverrides.treefmt = config.treefmt.build.wrapper;
          };
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nix
            alejandra
            nixd
            disko
            just
            omnix
            nh
            nix-output-monitor
            statix
            ssh-to-age
            openssh
            sops
          ];
          inherit (config.pre-commit) shellHook;
          buildInputs = config.pre-commit.settings.enabledPackages;
          EDITOR = "codium -w";
        };
      };

      flake = {
        overlays = {
          nix-cachyos-kernel = inputs.nix-cachyos-kernel.overlays.pinned;
          nur = inputs.nur.overlays.default;
          nix4vscode = inputs.nix4vscode.overlays.default;
          rust-overlay = inputs.rust-overlay.overlays.default;
        };

        lib = import ./lib {inherit (nixpkgs) lib;};

        nixosConfigurations = nixpkgs.lib.genAttrs nixosMachines (
          hostname:
            self.lib.withOfflineInstaller {
              flake = self;
              nixosConfig = nixpkgs.lib.nixosSystem {
                specialArgs =
                  globalSpecialArgs
                  // {
                    inherit hostname;
                  };
                modules = [
                  ./configurations/${hostname}
                  ./nixos/common
                  inputs.disko.nixosModules.disko
                  inputs.stylix.nixosModules.stylix
                  # inputs.hyprland.nixosModules.default
                  inputs.home-manager.nixosModules.home-manager
                  inputs.sops-nix.nixosModules.sops
                ];
              };
            }
        );

        darwinConfigurations = nixpkgs.lib.genAttrs darwinMachines (
          hostname:
            inputs.darwin.lib.darwinSystem {
              specialArgs =
                globalSpecialArgs
                // {
                  inherit hostname;
                };
              modules = [
                ./darwin
                inputs.home-manager.darwinModules.home-manager
                inputs.sops-nix.darwinModules.sops
              ];
            }
        );
      };
    };
}
