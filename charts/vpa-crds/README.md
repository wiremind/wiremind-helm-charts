# vpa-crds

Helm chart for deploying VPA CRDs.

### How to update the Chart

CRDs are retrieved from [here](https://github.com/FairwindsOps/charts/tree/master/stable/vpa).

To download them, you can use the following script at root : 

```
./scripts/update_crds.sh -r FairwindsOps/charts -b master --folder stable/vpa/crds -o charts/vpa-crds/templates/
```