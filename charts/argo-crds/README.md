# argo-crds

Helm chart for deploying Argo Workflow CRDs.

### How to update the Chart

The Chart has the same version as the `argo`s, try to keep them equal.

CRDs are located [here](https://github.com/argoproj/argo-helm/tree/argo-workflows-0.37.0/charts/argo-workflows/templates/crds)

**Do not forget to change the branch version**

```
cd charts/argo-crds

repo="argoproj/argo-helm"
branch="argo-workflows-0.37.0"
folder="charts/argo-workflows/templates/crds"

files=$(curl -s "https://api.github.com/repos/$repo/contents/$folder?ref=$branch" | jq -r '.[].download_url')

for file in $files
do
    filename=$(basename "$file")
    curl -o "templates/$filename" -L "$file"
done
```
