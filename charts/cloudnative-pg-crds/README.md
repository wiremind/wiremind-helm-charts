# cloudnative-pg-crds

Helm chart for deploying cloudnative-pg CRDs.

### How to update the Chart

The Chart has the same version as the `cloudnative-pg`s, try to keep them equal.

CRDs are located [here](https://github.com/cloudnative-pg/charts/blob/main/charts/cloudnative-pg/templates/crds/crds.yaml) but are built by bazel, so you need to do the following instead of just copy pasting:

**Do not forget to change APP_VERSION**

``` bash
export CHART_VERSION=v0.27.0
cd charts/cloudnative-pg-crds
curl https://raw.githubusercontent.com/cloudnative-pg/charts/refs/tags/cloudnative-pg-$CHART_VERSION/charts/cloudnative-pg/templates/crds/crds.yaml -L -o crds.yaml
sed -i '/{{- if .Values.crds.create }}/d; /{{- end }}/d' crds.yaml
bash ../../scripts/cut_crds.sh crds.yaml
```
