# clickhouse-operator-crds

Helm chart for deploying clickhouse-operator CRDs.

### How to update the Chart

The Chart has the same version as the `clickhouse-operator`, try to keep them equal.

CRDs are retrieved from [here](https://github.com/Altinity/clickhouse-operator/tree/master/deploy/helm/clickhouse-operator/crds).

To download them, you can use the following script at root : 
```
./scripts/update_crds.sh -r Altinity/clickhouse-operator -b v0.25.3 --folder deploy/helm/clickhouse-operator/crds -o charts/clickhouse-operator-crds/templates/
```
