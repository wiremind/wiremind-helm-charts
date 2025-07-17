# argo-cd-crds

A Helm chart that deploys Argo CD CRD resources.

### How to update the Chart

The Chart has the same version as the `argo`s, try to keep them equal.

CRDs are located [here](https://github.com/argoproj/argo-helm/tree/argo-cd-8.1.3/charts/argo-cd/templates/crds)

**Do not forget to change the branch version**

```
cd charts/argo-cd-crds

repo="argoproj/argo-helm"
git_ref="argo-cd-8.1.3"
folder="charts/argo-cd/templates/crds"

files=$(curl -s "https://api.github.com/repos/$repo/contents/$folder?ref=$git_ref" | jq -r '.[].download_url')

for file in $files
do
    filename=$(basename "$file")
    curl -o "templates/$filename" -L "$file"
done
```
