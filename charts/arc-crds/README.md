# actions-runner-controller CRDs

Helm chart for deploying actions-runner-controller CRDs.

## How to update the Chart

The Chart has the same version as the `actions-runner-controller`s, try to keep them equal.

CRDs are located [here](https://github.com/actions/actions-runner-controller/tree/v0.27.6/config/crd/bases)

**Do not forget to change the branch version**

```
cd charts/arc-crds
repo="actions/actions-runner-controller"
branch="v0.27.6"
folder="config/crd/bases"
files=$(curl -s "https://api.github.com/repos/$repo/contents/$folder?ref=$branch" | jq -r '.[].download_url')
for file in $files
do
    filename=$(basename "$file")
    curl -o "templates/$filename" -L "$file"
done

rm -f templates/kustomization.yaml
cd -
```
