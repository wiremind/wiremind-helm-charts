# chaos-mesh-crds

Helm chart for deploying Chaos Mesh CRDs.

### How to update the Chart

The Chart has the same version as the `chaos-mesh`s, try to keep them equal.

CRDs are located [here](https://github.com/chaos-mesh/chaos-mesh/tree/master/helm/chaos-mesh/crds)

```
repo="chaos-mesh/chaos-mesh"
branch="v2.7.2"
folder="helm/chaos-mesh/crds"
files=$(curl -s "https://api.github.com/repos/$repo/contents/$folder?ref=$branch" | jq -r '.[].download_url')
for file in $files
do
    filename=$(basename "$file")
    curl -o "templates/$filename" -L "$file"
done
```
