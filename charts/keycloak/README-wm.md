# keycloak

Helm chart for keycloak pulled from the bitnami repo with some customizations.

## Update the chart

If you updated the chart entirely using the script `update_charts.sh`, you need to:
- Update the postgresql dependency to use the right repo and image.
- Enabled http in the values.yaml

## Update app image

To update the keycloak image version, you need to build it from source at `https://github.com/bitnami/containers/tree/main/bitnami/keycloak` and push it to the github repo `ghcr.io/wiremind/bitnami/keycloak:<image_tag>`.
Then change the tag in the values.yaml file or update the chart entirely with `./scripts/update_charts.sh -r bitnami/charts -a keycloak --path bitnami --wiremind-image <image_tag>`.
