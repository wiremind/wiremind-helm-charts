# s3-controller-crds

Helm chart for deploying ACK s3-controller CRDs.

### How to update the Chart

The Chart has the same version as the `s3-controller`s, try to keep them equal.

CRDs are retrieved from [here](https://github.com/aws-controllers-k8s/s3-controller/tree/main/helm/crds).

To download them, you can use the following script at root : 
```
./scripts/update_crds.sh -r aws-controllers-k8s/s3-controller -b v1.0.33 --folder helm/crds -o charts/ack-s3-controller-crds/templates/
```