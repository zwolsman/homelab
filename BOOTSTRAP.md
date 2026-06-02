# Bootstrap

How did I bootstrap my homelab? Future me will be happy with these steps :)

## Prerequisites

- [`talosctl`](https://www.talos.dev/latest/introduction/getting-started/) installed and on your `$PATH`
- [`topf`](https://postfinance.github.io/topf/main/) installed and on your `$PATH`
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/) installed and on your `$PATH`
- [`helm`](https://helm.sh/docs/intro/install/) installed and on your `$PATH`

---

## Steps

### 1. Boot Talos

Boot the nodes into Talos Linux.

### 2. Apply config

Apply the machine configuration and bootstrap the cluster in one step:

```sh
topf apply --auto-bootstrap
```

### 3. Install Argo CD helm chart

Create the namespace and install Argo CD via Helm:

```sh
kubectl create namespace argocd

helm install argocd oci://ghcr.io/argoproj/argo-helm/argo-cd \
  --namespace argocd
```

### 4. Install Argo CD app

```sh
kubectl kustomize apps/argocd | kubectl apply -f -
```

### 5. Install Longhorn

```sh
kubectl kustomize apps/longhorn | kubectl apply -f -
```

Longhorn requires two values overrides before it will install cleanly:

**Disable the pre-upgrade check** (no Helm release history exists yet):

```yaml
preUpgradeChecker:
  jobEnabled: false
```

**Disable metrics** (the monitoring CRDs are not installed yet):

```yaml
metrics:
  enabled: false
```

### 6. Install monitoring

```sh
kubectl kustomize apps/monitoring | kubectl apply -f -
```