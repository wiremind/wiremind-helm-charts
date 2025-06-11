# velero-crds

This Chart contains CRDs needed by [velero](https://github.com/vmware-tanzu/velero).

The Chart has the same version as the `velero` Chart's, try to keep them equal even when no changes on the CRDs are made.

The CRDs are retrieved/adjustec from [here](https://github.com/vmware-tanzu/helm-charts/tree/main/charts/velero/crds), Checkout the right tag and see if there are any changes. Comment out `creationTimestamp` due to kubeconform + <https://github.com/kubernetes/kubernetes/issues/109427>.

If the version of the CRDs changes, aka breaking changes (this doesn't happen every day) more actions will be required!

```
cd charts/velero-crds
repo="vmware-tanzu/helm-charts"
branch="velero-10.0.4"
folder="charts/velero/crds"
files=$(curl -s "https://api.github.com/repos/$repo/contents/$folder?ref=$branch" | jq -r '.[].download_url')
for file in $files
do
    filename=$(basename "$file")
    curl -o "templates/$filename" -L "$file"
done

rm -f templates/kustomization.yaml
cd -
```
