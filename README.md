[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/wiremind)](https://artifacthub.io/packages/search?repo=wiremind)

# wiremind Helm Charts

This is a set of Helm Charts used and maintained by Wiremind. Do not hesitate to create Pull Requests.

All charts are visible from the Artifact Hub: https://artifacthub.io/packages/search?repo=wiremind&sort=relevance&page=1

## Dependency Management

This repository uses automated dependency management tools to keep charts up to date. See [DEPENDENCY_MANAGEMENT.md](DEPENDENCY_MANAGEMENT.md) for details on how to activate and use Dependabot and Renovate.

## CRDs charts

To update CRDs of a specific chart, please refer to its README.md, if there is none, just copy paste the upstream CRDs into ours.

Then run this command:
```bash
MY_CHART="mycrdschartname"
find ./charts/$MY_CHART -type f -exec sed -i -e '/creationTimestamp: null/d' {} \;
```

Running this command is mandatory because of this:
> During the [upgrade to controller-tools@v2](https://github.com/kubernetes-sigs/cluster-api/pull/1054) for v1alpha2, we noticed a failure would occur running Cluster API test suite against the new CRDs, specifically `spec.metadata.creationTimestamp in body must be removed`. The investigation showed that `controller-tools@v2` behaves differently than its previous version when handling types from [metav1](k8s.io/apimachinery/pkg/apis/meta/v1) package. \n In more details, we found that embedded (non-top level) types that embedded `metav1.ObjectMeta` had validation properties, including for `creationTimestamp` (metav1.Time). The `metav1.Time` type specifies a custom json marshaller that, when IsZero() is true, returns `null` which breaks validation because the field isn't marked as nullable. \n In future versions, controller-tools@v2 might allow overriding the type and validation for embedded types. When that happens, this hack should be revisited.

## Add new charts from public repos

To add and update charts from public repos use the script at root `./scripts/update_charts.sh -r <repo> -a <app_name> --path <custom_path>`.
If the chart already exists please refer to it's README-wm.md file before updating it.
