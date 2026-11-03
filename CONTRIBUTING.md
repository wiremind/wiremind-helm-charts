# Contributing

Issues and pull requests are welcome. Search the [existing issues](https://github.com/wiremind/wiremind-helm-charts/issues) first, and report security problems privately as described in [SECURITY.md](SECURITY.md).

## Pull requests

- Keep one chart per pull request.
- Bump `version` in the chart's `Chart.yaml` on every change: patch for fixes, minor for new values or features, major for breaking changes. CI rejects a changed chart whose version did not move, and only a new version gets released.
- Keep defaults backward compatible. When a change cannot be, make it a major bump and describe the migration in the pull request.
- Update `values.yaml` comments, `values.schema.json` when the chart has one, and the chart `README.md` for any new or changed value.
- Add or update a file under `charts/<chart>/ci/` when the change needs non-default values to be exercised.

## Commit messages

Commits follow [Conventional Commits](https://www.conventionalcommits.org/), checked in CI by cocogitto:

```text
fix(karma): set annotations on the HTTPRoute
feat(buildkitd)!: drop the legacy GC settings
```

The scope is the chart name.

## Testing locally

```bash
ct lint --config ct.yaml --charts charts/<chart>
helm template test charts/<chart> --debug
helm kubeconform --verbose charts/<chart>
```

CI also runs `ct install` in a kind cluster for every changed chart.

## CRD charts

After copying upstream CRDs into a `*-crds` chart, remove the `creationTimestamp: null` lines, which break validation:

```bash
find ./charts/<chart>-crds -type f -exec sed -i -e '/creationTimestamp: null/d' {} \;
```

`scripts/update_crds.sh` fetches CRDs from an upstream repository. CRDs larger than 256KB need server-side apply; document it in the chart README, as `charts/arc-crds/README.md` does.

## Code of conduct

Everyone taking part in this project follows the [Code of Conduct](CODE_OF_CONDUCT.md).
