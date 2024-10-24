# Helm notes

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
