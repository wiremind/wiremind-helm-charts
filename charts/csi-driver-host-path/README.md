# csi-driver-host-path

[csi-driver-host-path](https://github.com/kubernetes-csi/csi-driver-host-path) is a sample (non-production) CSI Driver that creates a local directory as a volume on a single node

## How to update the Chart

The Chart has the same `appVersion` as the `csi-driver-host-path`, keep them equal.

Most of the files are carbon copy of the ones located [here](https://github.com/kubernetes-csi/csi-driver-host-path/tree/master/deploy/kubernetes-1.24/hostpath), and you should update them with the following script:

```
cd charts/csi-driver-host-path/templates
```

### CSI Driver host path

**Do not forget to change CSI_DRIVER_HOST_PATH_VERSION**

```
export CSI_DRIVER_HOST_PATH_VERSION=v1.11.0
curl -Lo /tmp/csi-hostpath-driverinfo.yaml https://raw.githubusercontent.com/kubernetes-csi/csi-driver-host-path/$CSI_DRIVER_HOST_PATH_VERSION/deploy/kubernetes-1.24/hostpath/csi-hostpath-driverinfo.yaml && yq 'del(.metadata.labels)' /tmp/csi-hostpath-driverinfo.yaml > csi-hostpath-driverinfo.yaml
curl -Lo /tmp/csi-hostpath-snapshotclass.yaml https://raw.githubusercontent.com/kubernetes-csi/csi-driver-host-path/$CSI_DRIVER_HOST_PATH_VERSION/deploy/kubernetes-1.24/hostpath/csi-hostpath-snapshotclass.yaml && yq 'del(.metadata.labels)' /tmp/csi-hostpath-snapshotclass.yaml > csi-hostpath-snapshotclass.yaml
curl -Lo /tmp/csi-hostpath-plugin.yaml https://raw.githubusercontent.com/kubernetes-csi/csi-driver-host-path/$CSI_DRIVER_HOST_PATH_VERSION/deploy/kubernetes-1.24/hostpath/csi-hostpath-plugin.yaml && yq 'del(.metadata.labels)' -s '.metadata.name' /tmp/csi-hostpath-plugin.yaml
```

### External attacher
```
export CSI_EXTERNAL_ATTACHER_VERSION="v4.3.0"
curl -Lo rbac-csi-attacher.yaml https://raw.githubusercontent.com/kubernetes-csi/external-attacher/$CSI_EXTERNAL_ATTACHER_VERSION/deploy/kubernetes/rbac.yaml
```

### External health monitor
```
export CSI_EXTERNAL_HEALTH_MONITOR_VERSION="v0.9.0"
curl -Lo rbac-csi-external-health-monitor.yaml https://raw.githubusercontent.com/kubernetes-csi/external-health-monitor/$CSI_EXTERNAL_HEALTH_MONITOR_VERSION/deploy/kubernetes/external-health-monitor-controller/rbac.yaml
```

### External provisioner
```
export CSI_EXTERNAL_PROVISIONER_VERSION="v3.5.0"
curl -Lo rbac-csi-provisioner.yaml https://raw.githubusercontent.com/kubernetes-csi/external-provisioner/$CSI_EXTERNAL_PROVISIONER_VERSION/deploy/kubernetes/rbac.yaml
```

### External resizer
```
export CSI_EXTERNAL_RESIZER_VERSION="v1.8.0"
curl -Lo rbac-csi-resizer.yaml https://raw.githubusercontent.com/kubernetes-csi/external-resizer/$CSI_EXTERNAL_RESIZER_VERSION/deploy/kubernetes/rbac.yaml
```

### External snapshotter
```
export CSI_EXTERNAL_SNAPSHOTTER_VERSION="v6.2.2"
curl -Lo rbac-csi-snapshotter.yaml https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/$CSI_EXTERNAL_SNAPSHOTTER_VERSION/deploy/kubernetes/csi-snapshotter/rbac-csi-snapshotter.yaml
```

### Global

```
sed -i 's/namespace: default/namespace: {{ .Release.Namespace }}/g' *
```