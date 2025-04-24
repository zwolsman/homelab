# Homelab apps

Contains a collection of all apps in my homelab.

## Secret notes

1. Generate AGE key (`../assets/age/key.txt`)

```sh
nix-shell -p age-keygen
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

5. Make sure argocd has the private key

```sh
kubectl -n argocd create secret generic helm-secrets-age-key --from-file=key.txt=../assets/age/key.txt
```
