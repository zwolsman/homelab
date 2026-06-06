# NetBox

IPAM / DCIM for documenting the home network. Deployed from the official Helm
chart (`charts.netbox.oss.netboxlabs.com`, chart `8.3.13` / NetBox `v4.6.2`).

## Layout

- Single replica web + worker, modest resource limits (small cluster).
- Bundled **PostgreSQL** (standalone, 8Gi Longhorn) and **Valkey** (standalone,
  1Gi Longhorn) — passwords supplied via sealed secrets, not chart-generated, so
  ArgoCD's `helm template` (no cluster lookup) stays stable across syncs.
- Uploaded **media** is stored in the RustFS `netbox` S3 bucket
  (`rustfs-svc.rustfs.svc.cluster.local:9000`, path-style). Static files and
  scripts stay on the NetBox defaults.
- Exposed on the tailnet via the Tailscale Ingress (`netbox`).
- Prometheus `ServiceMonitor` enabled (`release: prometheus`).

## Secrets

The (gitignored) `secret.yaml` holds five Secrets with the exact keys the chart
and Bitnami subcharts expect (see comments in that file). Seal and commit:

```sh
kubeseal \
  --controller-name sealed-secrets-controller \
  --controller-namespace kube-system \
  --format yaml \
  < apps/netbox/secret.yaml \
  > apps/netbox/sealed_secret.yaml
```

`netbox-s3` reuses the RustFS access/secret key (see `apps/rustfs`). After the
first sync, log in at `https://netbox.<tailnet>` as `admin` with the generated
superuser password.

> Prerequisite: the RustFS app must be synced first so the `netbox` bucket
> exists (created by the RustFS PostSync hook).
