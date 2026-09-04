# ack-controllers-crds

Helm chart for deploying common AWS Controllers for Kubernetes (ACK) CRDs.

This chart centralizes the CRDs of the ACK controllers we deploy, currently the s3
and iam ones. Installing them from a single chart avoids the Helm ownership
conflicts you get when several ACK controller charts each ship the same shared
`services.k8s.aws` CRDs.

###  How to update the common chart

Vendor the CRDs from the `helm/crds` folder of the upstream controller release you
are moving to, then follow the CRD-chart rules in the repo `AGENTS.md`. Run the
script once per controller vendored here, so the s3 and iam CRDs do not drift
apart:

```
./scripts/update_crds.sh -r aws-controllers-k8s/s3-controller -b v1.11.0 \
  --folder helm/crds -o charts/ack-controllers-crds/templates
./scripts/update_crds.sh -r aws-controllers-k8s/iam-controller -b v1.7.3 \
  --folder helm/crds -o charts/ack-controllers-crds/templates
```

The script only downloads and overwrites, so running it per controller never
prunes the CRDs vendored by the other one, nor `adoptedresources` which upstream
no longer ships.

1. Strip `creationTimestamp: null` from the result (mandatory, CI fails otherwise):
   `find ./charts/ack-controllers-crds/templates -name '*.yaml' -exec sed -i -e '/creationTimestamp: null/d' {} \;`
2. Bump `Chart.yaml` (patch for fixes, minor for new fields or new CRDs).
3. Update the CRD sources table below, and keep the controller chart versions
   deployed from `wiremind-services-configuration` in sync with it.

Shared `services.k8s.aws` CRDs are shipped identically by the upstream controller
charts, so vendoring them from either release gives the same bytes.

### CRD sources

| CRD | Upstream | Version |
| --- | --- | --- |
| `buckets.s3.services.k8s.aws` | [aws-controllers-k8s/s3-controller](https://github.com/aws-controllers-k8s/s3-controller/tree/v1.11.0/helm/crds) | v1.11.0 |
| `*.iam.services.k8s.aws` | [aws-controllers-k8s/iam-controller](https://github.com/aws-controllers-k8s/iam-controller/tree/v1.7.3/helm/crds) | v1.7.3 |
| `fieldexports.services.k8s.aws`, `iamroleselectors.services.k8s.aws` | ACK runtime commons, shipped identically by both controller charts above | v1.7.3 (iam) |
| `adoptedresources.services.k8s.aws` | ACK runtime commons, no longer shipped upstream | v1.4.2 (iam) |

CRDs are vendored from the upstream `helm/crds` folder of the matching controller
release, with `creationTimestamp: null` stripped. Keep the deployed controller
chart versions in sync with the table above.

`adoptedresources` was dropped from the upstream controller charts, but is kept
here on purpose: removing a CRD template deletes the CRD on upgrade, which would
cascade to every `AdoptedResource` object in the cluster. Remove it only after
confirming none are left.