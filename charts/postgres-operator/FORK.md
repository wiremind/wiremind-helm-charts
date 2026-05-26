# Wiremind fork of zalando/postgres-operator

This chart is a vendored fork of the upstream
[zalando/postgres-operator](https://github.com/zalando/postgres-operator/tree/v1.14.0/charts/postgres-operator)
Helm chart at tag `v1.14.0`. The functional changes are:

- `deploymentAnnotations` values key that renders annotations onto the operator
  `Deployment`'s `metadata.annotations` (upstream only exposes `podAnnotations`,
  which annotates the pod template).
- `operatorConfigurationAnnotations` values key that renders annotations onto
  the `OperatorConfiguration` CR's `metadata.annotations`.

These let GitOps tooling pin per-resource ordering metadata (e.g. sync waves)
on the controller resources, which upstream does not expose.

Our wiremind fork is versioned `1.14.0-wiremind1`; on each upstream bump, sync
the new release into this directory and re-apply the five-file patch
(`Chart.yaml`, `FORK.md`, `values.yaml`, `templates/deployment.yaml`,
`templates/operatorconfiguration.yaml`).
