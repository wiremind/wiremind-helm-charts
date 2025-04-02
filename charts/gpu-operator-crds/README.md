# gpu-operator-crds

Helm chart for deploying gpu-operator CRDs.

### How to update the Chart

The Chart has the same version as the `gpu-operator`, try to keep them equal.

CRDs are retrieved from [here](https://github.com/NVIDIA/gpu-operator/tree/main/deployments/gpu-operator/crds).


To download them, you can use the following script at root : 
```
./scripts/update_crds.sh -r NVIDIA/gpu-operator -b v25.3.0 --folder deployments/gpu-operator/crds -o charts/gpu-operator-crds/templates/
```