# Redis Helm Chart

Helm chart for redis pulled from the bitnami repo with some customizations.

## Update the chart

If you updated the chart entirely using the script `update_charts.sh`, you need to:
- Update the postgresql dependency to use the right repo and image.
- Enabled http in the values.yaml

## Update app image

To update the image version, you need to build it from source at `https://github.com/bitnami/containers/tree/main/bitnami/redis` and push it to the github repo `ghcr.io/wiremind/bitnami/redis:<image_tag>`.
Then change the tag in the values.yaml file or update the chart entirely with `./scripts/update_charts.sh -r bitnami/charts -a redis --path bitnami --wiremind-image <image_tag>`.
