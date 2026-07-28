# ack-controllers-crds

Helm chart for deploying common AWS Controllers for Kubernetes (ACK) CRDs.

This chart is used to centralize CRDs that are shared across multiple ACK controllers, for now ack-s3-controller-crds and ack-iam-controller-crds 

###  How to update the common chart

When updating or adding new ACK CRDs, you can use the helper script to automatically move CRDs into the ack-controllers-crds chart without having to deal witl commons CRDS:

```
./scripts/move_common_crds.sh charts/ack-s3-controller-crds/templates charts/ack-iam-controller-crds/templates charts/ack-controllers-crds/templates
```
This script will:

✅ move all CRDs
✅ if a CRD already exists in DEST (by metadata.name), skip moving it again


This makes it easier to avoid Helm conflicts when installing multiple ACK controllers.

You can add additional controller charts as sources to the script if needed.

### CRD sources

| CRD | Upstream | Version |
| --- | --- | --- |
| `buckets.s3.services.k8s.aws` | [aws-controllers-k8s/s3-controller](https://github.com/aws-controllers-k8s/s3-controller/tree/v1.8.2/helm/crds) | v1.8.2 |
| `*.iam.services.k8s.aws` | [aws-controllers-k8s/iam-controller](https://github.com/aws-controllers-k8s/iam-controller/tree/v1.7.3/helm/crds) | v1.7.3 |
| `fieldexports.services.k8s.aws`, `iamroleselectors.services.k8s.aws` | ACK runtime commons, shipped identically by both controller charts above | v1.7.3 (iam) |
| `adoptedresources.services.k8s.aws` | ACK runtime commons, no longer shipped upstream | v1.4.2 (iam) |

CRDs are vendored from the upstream `helm/crds` folder of the matching controller
release, with `creationTimestamp: null` stripped. Keep the deployed controller
chart versions in sync with the table above.

`adoptedresources` was dropped from the upstream controller charts, but is kept
here on purpose: removing a CRD template deletes the CRD on upgrade, which would
cascade to every `AdoptedResource` object in the cluster. Remove it only after
confirming none are left.