# external-secrets-crds

This Chart contains CRDs needed by [external-secrets](https://github.com/external-secrets/external-secrets).

The Chart has the same version as the `external-secrets`s, try to keep them equal even when no changes on the CRDs are made.

The CRDs are retrieved/adjusted from [here](https://github.com/external-secrets/external-secrets/tree/main/deploy/crds), Checkout the right tag and see if there are any changes.

If the version of the CRDs changes, aka breaking changes (this doesn't happen every day) more actions will be required!

**Do not forget to change APP_VERSION**

``` bash
cd charts/external-secrets-crds
export APP_VERSION=$(grep "appVersion:" Chart.yaml | cut -d' ' -f2)
helm repo add external-secrets-operator https://charts.external-secrets.io/
helm pull external-secrets-operator/external-secrets --version $APP_VERSION
tar -xvf external-secrets-${APP_VERSION}.tgz
cp -f external-secrets/templates/crds/* templates/
rm -rf external-secrets*
```
