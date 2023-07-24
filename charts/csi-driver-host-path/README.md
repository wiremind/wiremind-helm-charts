# csi-driver-host-path

[csi-driver-host-path](https://github.com/kubernetes-csi/csi-driver-host-path) is a sample (non-production) CSI Driver that creates a local directory as a volume on a single node

### How to update the Chart

The Chart has the same `appVersion` as the `csi-driver-host-path`, keep them equal.

Most of the files are carbon copy of the ones located [here](https://github.com/kubernetes-csi/csi-driver-host-path/tree/master/deploy/kubernetes-1.24/hostpath), and you should update them with the following script:

**Do not forget to change APP_VERSION**

```
export APP_VERSION=v1.11.0
cd charts/csi-driver-host-path/templates
curl -Lo /tmp/csi-hostpath-driverinfo.yaml https://raw.githubusercontent.com/kubernetes-csi/csi-driver-host-path/$APP_VERSION/deploy/kubernetes-1.24/hostpath/csi-hostpath-driverinfo.yaml && yq 'del(.metadata.labels)' /tmp/csi-hostpath-driverinfo.yaml > csi-hostpath-driverinfo.yaml
curl -Lo /tmp/csi-hostpath-snapshotclass.yaml https://raw.githubusercontent.com/kubernetes-csi/csi-driver-host-path/$APP_VERSION/deploy/kubernetes-1.24/hostpath/csi-hostpath-snapshotclass.yaml && yq 'del(.metadata.labels)' /tmp/csi-hostpath-snapshotclass.yaml > csi-hostpath-snapshotclass.yaml
curl -Lo /tmp/csi-hostpath-plugin.yaml https://raw.githubusercontent.com/kubernetes-csi/csi-driver-host-path/$APP_VERSION/deploy/kubernetes-1.24/hostpath/csi-hostpath-plugin.yaml && yq 'del(.metadata.labels)' -s '.metadata.name' /tmp/csi-hostpath-plugin.yaml
sed -i 's/namespace: default/namespace: {{ .Release.Namespace }}/g' *
```
