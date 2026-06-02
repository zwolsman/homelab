# Apps

Kubernetes applications managed by Argo CD. Secrets are managed using [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets) (Bitnami), which encrypts Kubernetes Secret manifests so they can be safely committed to git. Decryption happens automatically in-cluster via the `sealed-secrets-controller` running in `kube-system`.

## Prerequisites

- [`kubeseal`](https://github.com/bitnami-labs/sealed-secrets#kubeseal) CLI installed locally
- `kubectl` access to the cluster with the sealed-secrets controller running

## Secret convention

Each app that requires secrets follows this pattern:

| File                 | Description                                                 |
| -------------------- | ----------------------------------------------------------- |
| `secret.yaml`        | Plaintext Secret manifest — **gitignored**, never committed |
| `sealed_secret.yaml` | Encrypted SealedSecret manifest — committed, safe in git    |

The `secret.yaml` serves as a local template. Fill it in, seal it, then discard or keep it locally.

## Workflow: sealing a new secret

**1. Fill in the plaintext secret template**

Edit the app's `secret.yaml` with the real values (base64-encoded data fields as required by the Kubernetes Secret spec):

```sh
# Example: generate a secret.yaml from a file
kubectl create secret generic my-secret \
  --namespace <app> \
  --from-file=file.json \
  --dry-run=client -o yaml > apps/<app>/secret.yaml

# Example: generate a secret.yaml from literals
kubectl create secret generic my-secret \
  --namespace <app> \
  --from-literal=key=value \
  --dry-run=client -o yaml > apps/<app>/secret.yaml
```

**2. Seal the secret**

```sh
kubeseal --format yaml < apps/<app>/secret.yaml > apps/<app>/sealed_secret.yaml
```

**3. Commit the sealed secret**

```sh
git add apps/<app>/sealed_secret.yaml
git commit -m "feat(apps): seal <app> secret"
```

## Updating an existing sealed secret

Re-seal from an updated `secret.yaml` and overwrite the existing `sealed_secret.yaml`:

```sh
kubeseal --format yaml < apps/<app>/secret.yaml > apps/<app>/sealed_secret.yaml
git add apps/<app>/sealed_secret.yaml
git commit -m "fix(<app>): rotate sealed secret"
```

## Important: sealed secrets are cluster-specific

SealedSecrets are encrypted with the public key of the cluster's `sealed-secrets-controller`. A `sealed_secret.yaml` from this repo will only decrypt on the cluster it was sealed against. If you rebuild the cluster without restoring the prior controller key, all sealed secrets become undecryptable and must be re-sealed from scratch against the new key.
