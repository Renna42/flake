default: switch

inspect:
  nix --accept-flake-config run github:bluskript/nix-inspect -- -p .

install hostname target:
    nix --accept-flake-config run github:nix-community/nixos-anywhere -- \
      --flake .#{{ hostname }} \
      --target-host {{ target }} \
      --copy-host-keys \
      --disko-mode disko \

bootstrap hostname disk:
    nix --extra-experimental-features "nix-command flakes" --accept-flake-config run 'github:nix-community/disko#disko-install' -- --flake .#{{ hostname }} --disk main {{ disk }}

build:
  nh os build . --accept-flake-config

switch:
  nh os switch . --accept-flake-config

boot:
  nh os boot . --accept-flake-config

dryrun:
  nixos-rebuild dry-run --flake . --sudo --accept-flake-config -v --log-format internal-json |& nom --json

darwin-switch:
  nh darwin switch . --accept-flake-config

gc:
  # remove all generations older than 7 days
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

  # garbage collect all unused nix store entries
  sudo nix store gc --debug

update:
  nix flake update

scan-age-key target:
  ssh {{ target }} cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age

updatekeys:
  sops updatekeys secrets/* -y
