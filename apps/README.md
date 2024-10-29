# Homelab apps

Contains a collection of all apps in my homelab.

## Secret notes

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

2. Update `.sops.yaml` to include the public key

3. Install [helm secrets](https://github.com/jkroepke/helm-secrets)

```sh
helm plugin install https://github.com/jkroepke/helm-secrets --version v4.6.2
```

4. Encrypt secrets

```sh
helm secrets encrypt secrets.yaml.dec > secrets.yaml
```
5. Make sure argocd has the private key. Export it first and then import the private key by creating a kubernetes secret.

```sh
gpg --armor --export-secret-keys <secret> > key.asc

kubectl -n argocd create secret generic helm-secrets-private-keys --from-file=key.asc
```