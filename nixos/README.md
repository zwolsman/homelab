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

# Setting Up a New NixOS Host

This is my personal guide for setting up a new NixOS host. Following these steps helps me get everything configured properly.

## Steps to Setup

### 1. Boot the NixOS Installer

First, boot into the NixOS installer.

### 2. Identify the Correct Drive

Run this command to see the available block devices and find the drive I want to use:

```sh
lsblk
```

### 3. Create Disko Configuration

Next, I'll create the Disko configuration, just double-check the name and disk to be safe:

```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /tmp/disko-configuration.nix
```

### 4. Generate New Configuration

Now, let's generate the new NixOS configuration:

```sh
nixos-generate-config --no-filesystems --root /mnt
```

### 5. Use Golden Nix to Install NixOS

Time to move the `golden.nix` configuration to `/mnt/etc/nixos/` and import the `disko-configuration.nix`.

### 6. Finish Installation

Wrap up the installation with:

```sh
nixos-install
reboot
```

### 7. Connect to the Host

Once it’s rebooted, log in as `server_admin`:

```sh
ssh server_admin@nixos
```

### 8. Open a Shell with the SSH-to-Age Tool

To open a shell, I’ll use:

```sh
nix-shell -p ssh-to-age
```

### 9. Get Host Machine Key

Configure the host machine key in `sops.yaml`. Get the public key with:

```sh
ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub
```

### 10. Encrypt Secrets

Finally, to encrypt secrets, run:

```sh
sops --encrypt --input-type yaml --output-type yaml secrets.yaml.dec > secrets.yaml
```

### 11. Install New Flake

Install the new configuration from the flake with everything set up.
