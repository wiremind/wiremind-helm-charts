# cert-manager-crds

Helm chart for deploying Cert Manager CRDs.

### How to update the Chart

The Chart has the same version as the `cert-manager`s, try to keep them equal.

CRDs are located [here](https://github.com/cert-manager/cert-manager/tree/master/deploy/crds) but are built by bazel, so you need to do the following instead of just copy pasting:

**Do not forget to change APP_VERSION**

```
export APP_VERSION=v1.7.1
cd charts/cert-manager-crds
curl https://github.com/cert-manager/cert-manager/releases/download/$APP_VERSION/cert-manager.crds.yaml -L -o crds.yaml
bash ../../scripts/cut_crds.sh crds.yaml
```
