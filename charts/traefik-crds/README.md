# traefik-crds

Helm chart for deploying Cert Manager CRDs.

## How to update the Chart

The Chart has the same version as the `traefik`s, try to keep them equal.

CRDs are located [here](https://github.com/traefik/traefik-helm-chart/tree/master/traefik/crds)

## Script

```bash
HELM_CHART_VERSION="v25.0.0"
curl -LO https://raw.githubusercontent.com/traefik/traefik-helm-chart/${HELM_CHART_VERSION}/traefik/crds/traefik.io_ingressroutes.yaml
curl -LO https://raw.githubusercontent.com/traefik/traefik-helm-chart/${HELM_CHART_VERSION}/traefik/crds/traefik.io_ingressroutetcps.yaml
curl -LO https://raw.githubusercontent.com/traefik/traefik-helm-chart/${HELM_CHART_VERSION}/traefik/crds/traefik.io_ingressrouteudps.yaml
curl -LO https://raw.githubusercontent.com/traefik/traefik-helm-chart/${HELM_CHART_VERSION}/traefik/crds/traefik.io_middlewares.yaml
curl -LO https://raw.githubusercontent.com/traefik/traefik-helm-chart/${HELM_CHART_VERSION}/traefik/crds/traefik.io_middlewaretcps.yaml
curl -LO https://raw.githubusercontent.com/traefik/traefik-helm-chart/${HELM_CHART_VERSION}/traefik/crds/traefik.io_serverstransports.yaml
curl -LO https://raw.githubusercontent.com/traefik/traefik-helm-chart/${HELM_CHART_VERSION}/traefik/crds/traefik.io_tlsoptions.yaml
curl -LO https://raw.githubusercontent.com/traefik/traefik-helm-chart/${HELM_CHART_VERSION}/traefik/crds/traefik.io_tlsstores.yaml
curl -LO https://raw.githubusercontent.com/traefik/traefik-helm-chart/${HELM_CHART_VERSION}/traefik/crds/traefik.io_traefikservices.yaml
curl -LO https://raw.githubusercontent.com/traefik/traefik-helm-chart/${HELM_CHART_VERSION}/traefik/crds/traefik.containo.us_ingressroutes.yaml
curl -LO https://raw.githubusercontent.com/traefik/traefik-helm-chart/${HELM_CHART_VERSION}/traefik/crds/traefik.containo.us_ingressroutetcps.yaml
curl -LO https://raw.githubusercontent.com/traefik/traefik-helm-chart/${HELM_CHART_VERSION}/traefik/crds/traefik.containo.us_ingressrouteudps.yaml
curl -LO https://raw.githubusercontent.com/traefik/traefik-helm-chart/${HELM_CHART_VERSION}/traefik/crds/traefik.containo.us_middlewares.yaml
curl -LO https://raw.githubusercontent.com/traefik/traefik-helm-chart/${HELM_CHART_VERSION}/traefik/crds/traefik.containo.us_middlewaretcps.yaml
curl -LO https://raw.githubusercontent.com/traefik/traefik-helm-chart/${HELM_CHART_VERSION}/traefik/crds/traefik.containo.us_serverstransports.yaml
curl -LO https://raw.githubusercontent.com/traefik/traefik-helm-chart/${HELM_CHART_VERSION}/traefik/crds/traefik.containo.us_tlsoptions.yaml
curl -LO https://raw.githubusercontent.com/traefik/traefik-helm-chart/${HELM_CHART_VERSION}/traefik/crds/traefik.containo.us_tlsstores.yaml
curl -LO https://raw.githubusercontent.com/traefik/traefik-helm-chart/${HELM_CHART_VERSION}/traefik/crds/traefik.containo.us_traefikservices.yaml
```
