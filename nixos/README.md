# NixOS Notes

## Building NixOS flake

As the NixOS flake is in the dir `./nixos` we need to use the `?dir` parameter for the flake and then the flake path. For example:

**Example dir parameter**

```sh
$ sudo nixos-rebuild switch --flake "github:zwolsman/homelab?dir=nixos#<flake>"
```

**Working `nixos-rebuild switch` full path**

```sh
$ sudo nixos-rebuild switch --flake "github:zwolsman/homelab?dir=nixos#homelab-0"
```

## Cross-compile with AARCH

Start colima container with rosetta virtualisation

```sh
$ colima start --profile vm --vm-type=vz --vz-rosetta
```

Run `nix` commands with `./inside-docker <command>` using the specified docker host (vm)

```sh
$ DOCKER_HOST=unix:///Users/mzwolsman/.colima/vm/docker.sock ./inside-docker <command>
```

## Deploy with NixOS Anywhere

```sh
./inside-docker nix run github:nix-community/nixos-anywhere \
--extra-experimental-features "nix-command flakes" \
-- --flake '.#homelab-0' nixos@host
```

## Secrets

1. Configure `.sops.yaml` to include public keys for the servers.
2. Encrypt `secrets.yaml.dec` to `secrets.yaml`

```sh
sops --encrypt --input-type yaml --output-type yaml secrets.yaml.dec > secrets.yaml
```
