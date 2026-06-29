# agentgateway-crds

Helm chart for deploying agentgateway CRDs.

### How to update the Chart

The Chart has the same version as the `agentgateway` release, try to keep them equal.

CRDs are located [here](https://github.com/agentgateway/agentgateway/tree/main/controller/install/helm/agentgateway-crds/templates).

Use the release tag that matches `appVersion`, for example [v1.3.1](https://github.com/agentgateway/agentgateway/tree/v1.3.1/controller/install/helm/agentgateway-crds/templates).

**Do not forget to change APP_VERSION**

```bash
export APP_VERSION=v1.3.1
./scripts/update_crds.sh -r agentgateway/agentgateway -b "$APP_VERSION" --folder controller/install/helm/agentgateway-crds/templates -o charts/agentgateway-crds/templates/
```

Install `gateway-api-crds` before this chart.
