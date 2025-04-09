# node-feature-discovery-crds

Helm chart for deploying node feature discovery CRDs.

### How to update the Chart

The Chart has the same version as the `node-feature-discovery`, try to keep them equal.

CRDs are retrieved from [here](https://github.com/kubernetes-sigs/node-feature-discovery/tree/master/deployment/helm/node-feature-discovery/crds).


To download them, you can use the following script at root : 
```
./scripts/update_crds.sh -r kubernetes-sigs/node-feature-discovery -b v0.17.2 --folder deployment/helm/node-feature-discovery/crds -o charts/node-feature-discovery-crds/templates/
```