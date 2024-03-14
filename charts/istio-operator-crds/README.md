# istio-operator-crds

Helm chart for deploying Istio Operator CRDs.

### How to update the Chart

The Chart has the same version as the `istio-operator`s, try to keep them equal.

CRDs are located here:
- [Kiali operator](https://github.com/kiali/kiali-operator/blob/v1.63.2/manifests/kiali-ossm/manifests/kiali.monitoringdashboards.crd.yaml)
- [Istio operator](https://github.com/istio/istio/blob/1.16.7/manifests/charts/base/crds/crd-operator.yaml)
- [Istio base](https://github.com/istio/istio/blob/1.16.7/manifests/charts/base/crds/crd-all.gen.yaml) but are built by bazel, so you need to do the following instead of just copy pasting:

**Do not forget to change APP_VERSION**

```
export APP_VERSION=1.21.0
cd charts/istio-operator-crds
curl https://raw.githubusercontent.com/istio/istio/$APP_VERSION/manifests/charts/base/crds/crd-all.gen.yaml -L > crds.yaml
echo "---" >> crds.yaml
curl https://raw.githubusercontent.com/istio/istio/$APP_VERSION/manifests/charts/base/crds/crd-operator.yaml -L >> crds.yaml
bash ../../scripts/cut_crds.sh crds.yaml
```
