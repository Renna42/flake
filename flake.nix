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
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    direnv-instant = {
      url = "github:Mic92/direnv-instant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

    globalSpecialArgs = {
      inherit
        inputs
        outputs
        assetsPath
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
        inputs.home-manager.flakeModules.home-manager
      ];

      systems = flake-utils.lib.defaultSystems;
      perSystem = {
        pkgs,
        system,
        ...
      }: rec {
        _module.args.pkgs = import self.inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
          overlays = [
            inputs.nix4vscode.overlays.default
          ];
        };

        checks = {
          pre-commit-check = inputs.git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              alejandra.enable = true;
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
            jq
            nh
          ];
          inherit (checks.pre-commit-check) shellHook;
          buildInputs = checks.pre-commit-check.enabledPackages;
          EDITOR = "codium";
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
                  ./hosts/${hostname}.nix
                  ./hardwares/${hostname}.nix
                  inputs.stylix.nixosModules.stylix
                  inputs.hyprland.nixosModules.default
                  inputs.home-manager.nixosModules.home-manager
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
            }: {
              "${username}@${hostname}" = withSystem system (
                {pkgs, ...}:
                  home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    modules = [
                      (./home/renna/configurations + "/${hostname}")
                      inputs.stylix.homeModules.stylix
                      inputs.nix-index-database.homeModules.nix-index
                      inputs.direnv-instant.homeModules.direnv-instant
                    ];
                    extraSpecialArgs =
                      globalSpecialArgs
                      // {
                        inherit
                          inputs
                          outputs
                          username
                          hostname
                          system
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
