default: deploy

inspect:
  nix run github:bluskript/nix-inspect -- -p .

install hostname target *FLAGS:
  nix run github:nix-community/nixos-anywhere -- \
    --flake .#{{ hostname }} \
    --target-host {{ target }} \
    --copy-host-keys \
    --disko-mode disko \
    {{ FLAGS }}

bootstrap hostname disk:
  nix --extra-experimental-features "nix-command flakes" --accept-flake-config run 'github:nix-community/disko#disko-install' -- --flake .#{{ hostname }} --disk main {{ disk }}

generate-hardware-config hostname target:
  ssh {{ target }} "nix --extra-experimental-features nix-command --extra-experimental-features flakes shell nixpkgs#nixos-install-tools -c nixos-generate-config --show-hardware-config --no-filesystems" > ./configurations/{{ hostname }}/hardware-configuration.nix

build:
  nixos-rebuild build --flake .# --sudo --accept-flake-config --log-format internal-json |& nom --json

deploy:
  nixos-rebuild switch --flake .# --sudo --accept-flake-config --log-format internal-json |& nom --json

boot:
  nixos-rebuild boot --flake .# --sudo --accept-flake-config --log-format internal-json |& nom --json

dryrun:
  nixos-rebuild dry-run --flake .# --sudo --accept-flake-config --log-format internal-json |& nom --json

darwin-bootstrap:
  sudo nix --extra-experimental-features nix-command --extra-experimental-features flakes run nix-darwin -- switch --flake .

darwin-deploy:
  nh darwin switch .# --accept-flake-config

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

rdeploy:
    deploy

rdeploy-host hostname:
    deploy .#{{ hostname }}

rdeploy-host-bare hostname target:
  nixos-rebuild switch --flake .#{{ hostname }} --target-host {{ target }} --accept-flake-config --log-format internal-json |& nom --json

st-generate:
  #!/usr/bin/env sh
  export STHOMEDIR=$(mktemp -d)
  nix run nixpkgs#syncthing -- generate
  export STCERT=$(cat ${STHOMEDIR}/cert.pem)
  export STKEY=$(cat ${STHOMEDIR}/key.pem)
  export OUTPUT=secrets/st-${HOSTNAME}.yaml
  yq --null-input '
    .st_cert = strenv(STCERT) | .st_cert style="literal" |
    .st_key = strenv(STKEY) | .st_key style="literal"
  ' | sops -e --filename-override ${OUTPUT} /dev/stdin > ${OUTPUT}
