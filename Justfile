inspect:
    nix run github:bluskript/nix-inspect -- -p .

build:
    nixos-rebuild build --flake . --sudo -v --log-format internal-json |& nom --json

switch: fmt
    nixos-rebuild switch --flake . --sudo -v --log-format internal-json |& nom --json

boot:
    nixos-rebuild boot --flake . --sudo -v -L

dryrun:
    nixos-rebuild dry-run --flake . --sudo -v --log-format internal-json |& nom --json

gc:
    # remove all generations older than 7 days
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

    # garbage collect all unused nix store entries
    sudo nix store gc --debug

fmt:
	nix fmt .

update:
    nix flake update
