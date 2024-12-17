# dask-crds

Helm chart for deploying Cert Manager CRDs.

### How to update the Chart

The Chart has the same version as the `dask-gateway`s, try to keep them equal.

CRDs are located [here](https://github.com/dask/dask-gateway/tree/main/resources/helm/dask-gateway/crds)

**Do not forget to change the branch version**

```
cd charts/dask-crds

repo="dask/dask-gateway"
branch="2024.1.0"
folder="resources/helm/dask-gateway/crds"

files=$(curl -s "https://api.github.com/repos/$repo/contents/$folder?ref=$branch" | jq -r '.[].download_url')

for file in $files
do
    filename=$(basename "$file")
    curl -o "templates/$filename" -L "$file"
done
```
