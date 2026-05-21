# Wiremind fork of zalando/postgres-operator

This chart is a vendored fork of the upstream
[zalando/postgres-operator](https://github.com/zalando/postgres-operator/tree/v1.14.0/charts/postgres-operator)
Helm chart at tag `v1.14.0`. The only functional change is the addition of a
`deploymentAnnotations` values key that renders annotations onto the operator
`Deployment`'s `metadata.annotations` (upstream only exposes `podAnnotations`,
which annotates the pod template — that does not let ArgoCD pin a sync-wave on
the controller resource). Without this, ArgoCD applies `Postgresql` CRs at
sync-wave `-80` before any controller exists at default sync-wave `0`, which
deadlocks first-install. Our wiremind fork is versioned `1.14.0-wiremind0`;
on each upstream bump, sync the new release into this directory and re-apply
the four-file patch (`Chart.yaml`, `FORK.md`, `values.yaml`,
`templates/deployment.yaml`).
