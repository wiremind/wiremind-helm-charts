# external-secrets-crds

This Chart contains CRDs needed by [external-secrets](https://github.com/external-secrets/external-secrets).

The Chart has the same version as the `external-secrets`s, try to keep them equal even when no changes on the CRDs are made.

The CRDs are retrieved/adjusted from [here](https://github.com/external-secrets/external-secrets/tree/main/deploy/crds), Checkout the right tag and see if there are any changes.

If the version of the CRDs changes, aka breaking changes (this doesn't happen every day) more actions will be required!

**Do not forget to change APP_VERSION**

```
export APP_VERSION=0.15.0
cd charts/external-secrets-crds
helm pull external-secrets/external-secrets --version $APP_VERSION
tar -xvf external-secrets-${APP_VERSION}.tgz
cp -r external-secrets/templates/crds templates
bash ../../scripts/cut_crds.sh crds.yaml
```
