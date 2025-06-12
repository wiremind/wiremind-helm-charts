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