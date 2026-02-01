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
      # Workaround for sops-nix on Darwin
      # https://github.com/Mic92/sops-nix/issues/890
      url = "github:Mic92/sops-nix?rev=d7593b87b0c1c33f9cfdd485a7fef081dd5362e7";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks.url = "github:cachix/git-hooks.nix";
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
    nixosMachines = ["Mizuka"];
    darwinMachines = ["Schwarzschild"];
  in
    flake-parts.lib.mkFlake {inherit inputs;} ({
      inputs,
      withSystem,
      ...
    }: {
      imports = [
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
        treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
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
            self.overlays.default
          ];
        };

        legacyPackages = self.lib.makePackages pkgs ./pkgs {};
        packages = flake-utils.lib.flattenTree self'.legacyPackages;

        overlayAttrs = {
          flakePackages = pkgs.lib.recurseIntoAttrs self'.legacyPackages;
        };

        checks = {
          pre-commit-check = inputs.git-hooks.lib.${system}.run {
            src = ./.;
            package = pkgs.prek;
            hooks = {
              treefmt = {
                enable = true;
                packageOverrides.treefmt = treefmtEval.config.build.wrapper;
              };
            };
          };
        };
        formatter = treefmtEval.config.build.wrapper;

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
          inherit (config.checks.pre-commit-check) shellHook;
          buildInputs = config.checks.pre-commit-check.enabledPackages;
          EDITOR = "codium -w";
        };
      };

      flake = {
        lib = import ./lib {inherit (nixpkgs) lib;};

        nix.settings = {
          # nix substituters shared between home-manager and nixos
          substituters = [
            "https://mirror.sjtu.edu.cn/nix-channels/store"
            "https://mirrorz.org/nix-channels/store"
            "https://nix-community.cachix.org"
            "https://renna42.cachix.org"
            "https://cache.garnix.io"
            "https://cache.nixos.org"
          ];
        };

        nixosConfigurations = nixpkgs.lib.genAttrs nixosMachines (
          hostname:
            nixpkgs.lib.nixosSystem {
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
                ./nixos/configurations/${hostname}
                inputs.stylix.nixosModules.stylix
                # inputs.hyprland.nixosModules.default
                inputs.home-manager.nixosModules.home-manager
                inputs.sops-nix.nixosModules.sops
              ];
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
