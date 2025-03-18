# trivy-operator-crds

Helm chart for deploying trivy-operator CRDs.

### How to update the Chart

The Chart has the same version as the `trivy-operator`, try to keep them equal.

CRDs are retrieved from [here](https://github.com/aquasecurity/trivy-operator/tree/main/deploy/helm/crds).


To download them, you can use the following script at root : 
```
./scripts/update_crds.sh -r aquasecurity/trivy-operator -b v0.25.0 --folder deploy/helm/crds -o charts/trivy-operator-crds/templates/
```