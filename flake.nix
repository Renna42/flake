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
    direnv-instant.url = "github:Mic92/direnv-instant";
    catppuccin.url = "github:catppuccin/nix";
    hyprland.url = "github:hyprwm/Hyprland";

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
        pkgs,
        config,
        system,
        ...
      }: {
        _module.args.pkgs = import self.inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
          overlays = [
            inputs.nix4vscode.overlays.default
            self.overlays.default
          ];
        };

        packages =
          pkgs.lib.filterAttrs
          (
            pname: package:
              if builtins.hasAttr "meta" package
              then builtins.elem system package.meta.platforms
              else true
          )
          (
            pkgs.lib.packagesFromDirectoryRecursive {
              inherit (pkgs) callPackage;
              directory = ./packages;
            }
          );

        overlayAttrs = {
          flakePackages = config.packages;
        };

        checks = {
          pre-commit-check = inputs.git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              alejandra.enable = true;
              statix.enable = true;
            };
          };
        };
        formatter = pkgs.alejandra;
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nix
            home-manager
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

      flake =
        {
          nix.settings = {
            # nix substituters shared between home-manager and nixos
            substituters = let
              channelStore = x: "https://${x}/nix-channels/store";
              mirrors =
                [
                  (channelStore "mirror.sjtu.edu.cn")
                ]
                ++ map (x: channelStore "mirrors.${x}.edu.cn") [
                  "ustc"
                  "tuna.tsinghua"
                ];
              cachix = x: "https://${x}.cachix.org";
            in
              nixpkgs.lib.flatten [
                mirrors
                (cachix "nix-community")
                "https://cache.garnix.io"
                "https://cache.nixos.org"
                (cachix "hyprland")
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
                  inputs.hyprland.nixosModules.default
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
        }
        // (
          # Home-manager configurations
          let
            mkHomeConfig = {
              hostname,
              username ? "renna",
              system ? "x86_64-linux",
              home-manager ? inputs.home-manager,
            }: let
              platform = nixpkgs.lib.systems.elaborate system;
            in {
              "${username}@${hostname}" = withSystem system (
                {pkgs, ...}:
                  home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    modules = [
                      (./home/renna/configurations + "/${hostname}")
                      inputs.stylix.homeModules.stylix
                      inputs.catppuccin.homeModules.catppuccin
                      inputs.nix-index-database.homeModules.nix-index
                      inputs.direnv-instant.homeModules.direnv-instant
                      inputs.sops-nix.homeManagerModules.sops
                    ];
                    extraSpecialArgs =
                      globalSpecialArgs
                      // {
                        inherit
                          username
                          hostname
                          platform
                          ;
                      };
                  }
              );
            };
          in {
            homeConfigurations =
              mkHomeConfig {
                hostname = "Mizuka";
              }
              // mkHomeConfig {
                hostname = "Schwarzschild";
                system = "aarch64-darwin";
              };
          }
        );
    });
}
