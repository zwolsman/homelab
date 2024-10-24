# Homelab NixOS

# Nodes

- homelab-0 (192.168.1.150)
- homelab-1 (192.168.1.151)
- homelab-2 (192.168.1.152)

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

## Depoy

```sh
./inside-docker nix run github:nix-community/nixos-anywhere \
--extra-experimental-features "nix-command flakes" \
-- --flake '.#homelab-0' nixos@host
```

## Helm secrets

1. Generate GPG key

```sh
export KEY_NAME="Homelab helm secrets"
export KEY_COMMENT="Key used for helm secrets deployed to the homelab k8s cluster"

gpg --batch --full-generate-key <<EOF
%no-protection
Key-Type: 1
Key-Length: 4096
Subkey-Type: 1
Subkey-Length: 4096
Expire-Date: 0
Name-Comment: ${KEY_COMMENT}
Name-Real: ${KEY_NAME}
EOF
```

2. Update `$HOME/sops.yaml` to include the public key

3. Install [helm secrets](https://github.com/jkroepke/helm-secrets)

```sh
helm plugin install https://github.com/jkroepke/helm-secrets --version v4.6.2
```

4. Encrypt secrets

```sh
helm secrets encrypt secrets.yaml.dec > secrets.yaml
```
