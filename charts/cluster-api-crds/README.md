# cluster-api-crds

Helm chart for deploying cluster-api CRDs.

## How to update the Chart

The Chart has the same version as the `cluster-api`s, try to keep them equal.

CRDs are located [here](https://github.com/kubernetes-sigs/cluster-api/tree/main/config/crd/bases)

**Do not forget to change the branch version**

```
cd charts/cluster-api-crds
repo="kubernetes-sigs/cluster-api"
branch="v1.9.6"
folder="config/crd/bases"
files=$(curl -s "https://api.github.com/repos/$repo/contents/$folder?ref=$branch" | jq -r '.[].download_url')
for file in $files
do
    filename=$(basename "$file")
    curl -o "templates/$filename" -L "$file"
done

cd templates/
sed 's/{{ /{{`{{/g' * --in-place *
sed 's/ }}/}}`}}/g' * --in-place *
cd ../../..
```
