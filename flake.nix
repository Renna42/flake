{
  description = "Renna's System Flake";

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
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    direnv-instant.url = "github:Mic92/direnv-instant";
    catppuccin.url = "github:catppuccin/nix";
    # hyprland.url = "github:hyprwm/Hyprland";

    flake-compat = {
      url = "github:NixOS/flake-compat";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    flake-utils,
    ...
  } @ inputs: let
    inherit (self) outputs;
    assetsPath = ./assets;
    secretsPath = ./secrets;

    globalSpecialArgs = {
      inherit
        inputs
        outputs
        assetsPath
        secretsPath
        ;
    };
    nixosMachines = ["Mizuka" "Quebec"];
    darwinMachines = ["Schwarzschild"];
  in
    flake-parts.lib.mkFlake {inherit inputs;} ({
      inputs,
      withSystem,
      ...
    }: {
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
      in {
        _module.args.pkgs = import self.inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
          overlays = [
            inputs.nur.overlays.default
            inputs.nix4vscode.overlays.default
            inputs.rust-overlay.overlays.default
            self.overlays.default
          ];
        };

        legacyPackages = adjustLegacyPackages (self.lib.makePackages pkgs ./pkgs {});
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
            just
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
        lib = import ./lib {inherit (nixpkgs) lib;};

        nix.settings = {
          # nix substituters shared between home-manager and nixos
          substituters = [
            "https://mirror.sjtu.edu.cn/nix-channels/store"
            "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
            "https://mirrors.ustc.edu.cn/nix-channels/store"
          ];
          extra-substituters = [
            "https://nix-community.cachix.org"
            "https://cache.garnix.io"
            "https://renna42.cachix.org"
          ];
        };

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
                  ({config, ...}: {
                    # Use the configured pkgs from perSystem
                    nixpkgs.pkgs = withSystem config.nixpkgs.hostPlatform.system (
                      {pkgs, ...}:
                      # perSystem module arguments
                        pkgs
                    );
                  })
                  ./nixos/common
                  ./nixos/configurations/${hostname}
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
                  inherit
                    hostname
                    ;
                };
              modules = [
                ({config, ...}: {
                  # Use the configured pkgs from perSystem
                  nixpkgs.pkgs = withSystem config.nixpkgs.hostPlatform.system (
                    {pkgs, ...}:
                    # perSystem module arguments
                      pkgs
                  );
                })
                ./darwin
                inputs.home-manager.darwinModules.home-manager
                inputs.sops-nix.darwinModules.sops
              ];
            }
        );
      };
    });
}
