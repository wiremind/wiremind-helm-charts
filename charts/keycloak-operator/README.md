# keycloak-operator

Helm chart for deploying Keycloak operator. This is a copy of the config files [found here](https://github.com/keycloak/keycloak-operator/tree/main/deploy).

### How to update the Chart

The Chart has the same version as the `keycloak-operator`s, try to keep them equal.

CRDs are retrieved from [here](https://github.com/keycloak/keycloak-operator/tree/main/deploy/crds).
RBACs are retrieved from [here](https://github.com/keycloak/keycloak-operator/tree/main/deploy/cluster_roles).
The Operator Deployment is retrieved from [here](https://github.com/keycloak/keycloak-operator/blob/main/deploy/operator.yaml).
CR usage examples are retrieved from [here](https://github.com/keycloak/keycloak-operator/tree/main/deploy/examples/).

If the version of the CRDs changes, aka breaking changes (this doesn't happen every day) more actions will be required!
