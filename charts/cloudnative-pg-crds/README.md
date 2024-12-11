# cloudnative-pg-crds

Helm chart for deploying cloudnative-pg CRDs.

### How to update the Chart

The Chart has the same version as the `cloudnative-pg`s, try to keep them equal.

CRDs are located [here](https://github.com/cloudnative-pg/charts/blob/main/charts/cloudnative-pg/templates/crds/crds.yaml) but are built by bazel, so you need to do the following instead of just copy pasting:

**Do not forget to change APP_VERSION**

```
export APP_VERSION=v0.22.1
cd charts/cloudnative-pg-crds
curl https://github.com/cloudnative-pg/charts/blob/cloudnative-pg-$APP_VERSION/charts/cloudnative-pg/templates/crds/crds.yaml -L -o crds.yaml
bash ../../scripts/cut_crds.sh crds.yaml
```
