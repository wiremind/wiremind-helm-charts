# external-secrets-crds

This Chart contains CRDs needed by [external-secrets](https://github.com/external-secrets/external-secrets).

The Chart has the same version as the `external-secrets`s, try to keep them equal even when no changes on the CRDs are made.

The CRDs are retrieved/adjusted from [here](https://github.com/external-secrets/external-secrets/tree/main/deploy/crds), Checkout the right tag and see if there are any changes.

If the version of the CRDs changes, aka breaking changes (this doesn't happen every day) more actions will be required!

**Do not forget to change APP_VERSION**

```
export APP_VERSION=v0.13.0
cd charts/external-secrets-crds
curl https://raw.githubusercontent.com/external-secrets/external-secrets/refs/tags/${APP_VERSION}/deploy/crds/bundle.yaml -L -o crds.yaml
bash ../../scripts/cut_crds.sh crds.yaml
```
