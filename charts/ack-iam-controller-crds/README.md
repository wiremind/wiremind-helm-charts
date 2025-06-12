# s3-controller-crds

Helm chart for deploying ACK iam-controller CRDs.

### How to update the Chart

The Chart has the same version as the `iam-controller`s, try to keep them equal.

CRDs are retrieved from [here](https://github.com/aws-controllers-k8s/iam-controller/tree/main/helm/crds).

```
./scripts/update_crds.sh -r aws-controllers-k8s/iam-controller -b v1.4.2 --folder helm/crds -o charts/ack-iam-controller-crds/templates/
```