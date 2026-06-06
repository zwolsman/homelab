# RustFS

S3-compatible object storage (MinIO alternative, written in Rust) used as the
storage backend for NetBox media/uploads.

Deployed from the upstream Helm chart, which is **not published to a Helm repo**,
so the ArgoCD `Application` consumes it from the git source
(`github.com/rustfs/rustfs`, path `helm/rustfs`, tag `1.0.0-beta.7`).

## Layout

- Runs in **standalone** mode, single replica (the chart defaults to a 4-replica
  distributed setup, which does not fit a small 3-node cluster).
- The chart auto-creates two Longhorn PVCs: `rustfs-data` (10Gi, the bucket
  store) and `rustfs-logs` (1Gi).
- S3 API on `rustfs-svc.rustfs.svc.cluster.local:9000` (in-cluster only).
- Web console exposed on the tailnet via the Tailscale Ingress (`rustfs`).
- A `PostSync` hook Job (`rustfs-create-buckets`) creates the `netbox` bucket.

## Secret

`rustfs-secret` holds `RUSTFS_ACCESS_KEY` / `RUSTFS_SECRET_KEY`. Generate the
sealed secret from the (gitignored) plaintext and commit it:

```sh
kubeseal \
  --controller-name sealed-secrets-controller \
  --controller-namespace kube-system \
  --format yaml \
  < apps/rustfs/secret.yaml \
  > apps/rustfs/sealed_secret.yaml
```

The same access/secret key pair is reused as NetBox's `AWS_ACCESS_KEY_ID` /
`AWS_SECRET_ACCESS_KEY` (see `apps/netbox`).

## Expanding storage later

Grow the `rustfs-data` PVC (Longhorn supports online volume expansion); add
disks to the nodes to back the larger volume.
