# vpa-crds

Helm chart for deploying VPA CRDs.

### How to update the Chart

CRDs are retrieved from [here](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/deploy/vpa-v1-crd-gen.yaml).

To download them, you can use the following script at root :

```
./scripts/update_crds.sh -r kubernetes/autoscaler -b vertical-pod-autoscaler-1.8.0 --folder vertical-pod-autoscaler/deploy/vpa-v1-crd-gen.yaml -o charts/vertical-pod-autoscaler-crds/templates/
```
