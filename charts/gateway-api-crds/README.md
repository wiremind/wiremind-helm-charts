# gateway-api-crds

Helm chart for deploying gateway-api CRDs.

## How to update the Chart

The Chart has the same version as the `gateway-api`s, try to keep them equal.

CRDs are located [here](https://github.com/kubernetes-sigs/gateway-api/tree/v1.3.0/config/crd/experimental)

**Do not forget to change the branch version**

```
cd charts/gateway-api-crds
repo="kubernetes-sigs/gateway-api"
branch="v1.3.0"
folder="config/crd/experimental"
files=$(curl -s "https://api.github.com/repos/$repo/contents/$folder?ref=$branch" | jq -r '.[].download_url')
for file in $files
do
    filename=$(basename "$file")
    curl -o "templates/$filename" -L "$file"
done

rm -f templates/kustomization.yaml
cd -
```
