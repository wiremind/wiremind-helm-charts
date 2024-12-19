# snapshot-controller-crds

Helm chart for deploying snapshot controller CRDs.

### How to update the Chart

The Chart has the same version as the `snapshot-controller`s, try to keep them equal.

CRDs are retrieved from [here](https://github.com/kubernetes-csi/external-snapshotter/tree/master/client/config/crd).

You can download them with these commands

```
export APP_VERSION="v8.2.0"
curl -fsSL https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/$APP_VERSION/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml -o templates/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
curl -fsSL https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/$APP_VERSION/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml -o templates/snapshot.storage.k8s.io_volumesnapshots.yaml
curl -fsSL https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/$APP_VERSION/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml -o templates/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
curl -fsSL https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/refs/tags/$APP_VERSION/client/config/crd/groupsnapshot.storage.k8s.io_volumegroupsnapshots.yaml -o templates/groupsnapshot.storage.k8s.io_volumegroupsnapshots.yaml
curl -fsSL https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/refs/tags/$APP_VERSION/client/config/crd/groupsnapshot.storage.k8s.io_volumegroupsnapshotcontents.yaml -o templates/groupsnapshot.storage.k8s.io_volumegroupsnapshotcontents.yaml
curl -fsSL https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/refs/tags/$APP_VERSION/client/config/crd/groupsnapshot.storage.k8s.io_volumegroupsnapshotclasses.yaml -o templates/groupsnapshot.storage.k8s.io_volumegroupsnapshotclasses.yaml
```
