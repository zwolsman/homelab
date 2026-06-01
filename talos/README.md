# Talos

This directory manages the Kubernetes nodes running [Talos Linux](https://talos.dev) — replacing the previous NixOS setup. Cluster configuration is handled by [topf](https://postfinance.github.io/topf), secrets are encrypted with [SOPS](https://github.com/getsops/sops), and environment variables are managed via [direnv](https://direnv.net).

## Overview

| Tool                                        | Purpose                                                  |
| ------------------------------------------- | -------------------------------------------------------- |
| [Talos](https://talos.dev)                  | Immutable, API-driven Linux OS for Kubernetes nodes      |
| [topf](https://github.com/postfinance/topf) | Manages the Talos cluster lifecycle with layered patches |
| [SOPS](https://github.com/getsops/sops)     | Encrypts secrets at rest in the repository               |
| [direnv](https://direnv.net)                | Loads environment variables automatically per directory  |

## Prerequisites

- [`topf`](https://github.com/postfinance/topf/releases) installed and on your `PATH`
- [`sops`](https://github.com/getsops/sops) installed
- [`direnv`](https://direnv.net) installed and [hooked into your shell](https://direnv.net/docs/hook.html)
- A SOPS key configured (age or GPG) that can decrypt the secrets in this repo

## Directory Structure

```
talos/
├── .envrc                                      # direnv: sets TALOSCONFIG, KUBECONFIG, etc.
├── secrets.enc.yaml                            # SOPS-encrypted cluster secrets
├── topf.yaml                                   # topf cluster configuration
├── all/                                        # Applied to every node
├── controlplane/                               # Applied to control plane nodes only
├── worker/                                     # Applied to worker nodes only
├── node
│   └── node1
│       └── 01-some-nodespecific-patch.yaml     # Applied to specific node
└──schematics
    ├── schematic-poweredge.yaml                # Dell PowerEdge R710 Schematic
    └── schematic.yaml                          # Generic schematic
```

## Getting Started

### 1. Allow direnv

When you `cd` into this directory, direnv will load the required environment variables. On first use, you need to allow it:

```sh
direnv allow
```

This sets variables like `TALOSCONFIG` and `KUBECONFIG` so `talosctl` and `kubectl` point at the right cluster automatically.

### 2. Bootstrap a new cluster

Generate and apply the initial machine configs:

```sh
topf apply --bootstrap
```

Once the cluster is up, fetch the credentials:

```sh
topf kubeconfig > kubeconfig    # writes kubeconfig to the path set in .envrc
topf talosconfig > talosconfig  # writes talosconfig to the path set in .envrc
```

### 3. Apply config changes

After editing patches or `topf.yaml`, apply the updated configuration:

```sh
topf apply
```

topf handles config generation, diffing, and rolling the changes out node by node.

## Secrets

Secrets (certificates, tokens, etc.) are stored encrypted in `secrets.enc.yaml`. topf decrypts them automatically at runtime via SOPS as long as your key is available.

To edit secrets:

```sh
sops secrets.enc.yaml
```

## Upgrading

### Talos version

```sh
topf upgrade --talos
```

### Kubernetes version

```sh
topf upgrade --kubernetes
```

topf drains nodes and upgrades them one at a time to maintain cluster availability.

## Useful Commands

```sh
# Check node status
talosctl health

# View current machine config for a node
topf nodes

# Reset a node (destructive!)
topf reset --node <node-ip>
```

## Migration from NixOS

The previous NixOS-based node setup has been retired in favour of Talos. Key differences:

- **No SSH access** — Talos nodes are managed entirely through the Talos API (`talosctl`). There is no shell to log into.
- **Immutable OS** — the root filesystem is read-only; all customisation is done through machine config patches.
- **Declarative config** — node configuration lives in this directory as versioned YAML patches, not Nix expressions.
- **Kubernetes-first** — Talos is purpose-built to run Kubernetes; there is no general-purpose OS layer.
