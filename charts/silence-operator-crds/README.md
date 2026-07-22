# silence-operator-crds

Helm chart for deploying silence operator CRDs.

### How to update the Chart

The Chart has the same version as the `silence-operator`, try to keep them equal.

To download CRDs, you can use the following script at root :

```
./scripts/update_crds.sh -r giantswarm/silence-operator/ -b v0.20.1 --folder helm/silence-operator/templates/crds.yml -o charts/silence-operator-crds/templates/
```
