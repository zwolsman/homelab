# Homelab NixOS

# Nodes

- homelab-0
- homelab-1
- homelab-2

## Cross-compile with AARCH

Start colima container with rosetta virtualisation

```sh
$ colima start --profile vm --vm-type=vz --vz-rosetta
```

Run `nix` commands with `./inside-docker <command>` using the specified docker host (vm)

```sh
$ DOCKER_HOST=unix:///Users/mzwolsman/.colima/vm/docker.sock ./inside-docker <command>
```

## Depoy

```sh
./inside-docker nix run github:nix-community/nixos-anywhere \
--extra-experimental-features "nix-command flakes" \
-- --flake '.#homelab-0' nixos@host
```
