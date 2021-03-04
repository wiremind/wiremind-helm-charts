# istio-operator

Helm chart for deploying Istio operator. This is a carbon-copy of the chart found in https://github.com/istio/istio, with container image versions pinned.

To commit/release a new version, please:

- git clone the github.com/istio/istio repository
- copy the helm chart located in manifests/charts/istio-operator here
- replace in the values the hub and the version
- replace in Chart.yaml:
  - version
  - set maintainers
  - add this source
  - set apiVersion to v2 (helm 3 only)
  - remove the tillerVersion (helm 3 only)
