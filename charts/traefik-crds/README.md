# traefik-crds

Helm chart for deploying Cert Manager CRDs.

## How to update the Chart

The Chart has the same version as the `traefik`s, try to keep them equal.

CRDs are located [here](https://github.com/traefik/traefik-helm-chart/tree/master/traefik/crds)

**Do not forget to change the branch version**

```
cd charts/traefik-crds
repo="traefik/traefik-helm-chart"
branch="v33.0.0"
folder="traefik/crds"
files=$(curl -s "https://api.github.com/repos/$repo/contents/$folder?ref=$branch" | jq -r '.[].download_url')
for file in $files
do
    filename=$(basename "$file")
    curl -o "templates/$filename" -L "$file"
done
```
