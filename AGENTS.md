# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains Wiremind's collection of Helm charts, published to [Artifact Hub](https://artifacthub.io/packages/search?repo=wiremind).

The repository contains two types of charts:

- **CRD Charts** (32 charts with `-crds` suffix): Pure CustomResourceDefinition charts that require special handling
- **Application Charts** (42 charts): Standard Helm charts for deploying services and workloads

## Common Development Commands

### Chart Linting and Testing

```bash
# Lint changed charts (what CI does)
ct lint --config ct.yaml

# Test installation in Kind cluster
ct install --config ct.yaml

# Test specific chart with dry-run
helm install test-release ./charts/CHART_NAME --dry-run --debug

# Validate manifests with kubeconform
helm kubeconform --verbose ./charts/CHART_NAME
```

### Working with Dependencies

```bash
# Update chart dependencies
helm dependency update ./charts/CHART_NAME

# Build dependency charts
helm dependency build ./charts/CHART_NAME
```

## CRD Chart Special Handling (CRITICAL)

### Required Cleanup After CRD Updates

**This is the most important non-obvious pattern in the repository.**

After updating any CRD chart, you MUST remove `creationTimestamp: null` metadata:

```bash
MY_CHART="chart-name-crds"
find ./charts/$MY_CHART -type f -exec sed -i -e '/creationTimestamp: null/d' {} \;
```

**Why?** controller-tools v2 validation fails on embedded metav1.ObjectMeta types containing `creationTimestamp: null`. This cleanup is mandatory or CI will fail.

### CRD Update Workflow

1. Download CRDs from upstream using curl or `./scripts/update_crds.sh`
2. **Clean creationTimestamp fields** (see command above)
3. Bump Chart.yaml version (patch for bug fixes, minor for new features)
4. Update chart README with source information and version
5. For CRDs >256KB, document server-side apply requirement in README

### Large CRD Handling

CRDs exceeding 256KB hit Kubernetes annotation limits and require server-side apply during installation. When adding/updating large CRDs:

- Document the server-side apply requirement in the chart README
- Provide installation instructions with `--server-side` flag
- See `charts/arc-crds/README.md` for an example

## Repository Architecture

### Chart Categories

**CRD Charts** (`*-crds`):

- Contain only CustomResourceDefinitions, no application logic
- Often dependencies for corresponding application charts
- Require creationTimestamp cleanup (see above)
- Examples: arc-crds, argo-cd-crds, cloudnative-pg-crds

**Application Charts**:

- Standard Helm charts deploying services and workloads
- May depend on CRD charts in Chart.yaml dependencies
- Examples: buildkitd, cerebro, elasticsearch, kibana

### Standard Chart Structure

```text
charts/CHART_NAME/
├── Chart.yaml              # Chart metadata and dependencies
├── values.yaml             # Default configuration values
├── templates/
│   ├── _helpers.tpl       # Template helper functions
│   └── *.yaml             # Kubernetes resource templates
├── ci/                    # CI test values (optional)
│   └── ci-values.yaml
└── README.md              # Chart documentation
```

### Testing Infrastructure

- **`ct.yaml`**: Chart-testing configuration with validation settings
- **`.kubeconform`**: Schema locations for CRD validation
- **`charts/*/ci/`**: Directory containing CI test value files (22+ test configurations)
- **Pre-installed CRDs**: CI pre-installs prometheus-operator-crds, istio-operator-crds, and snapshot-controller-crds before testing charts

## Helper Scripts

Located in `scripts/` directory:

### `update_crds.sh`

Download CRDs from GitHub repositories:

```bash
./scripts/update_crds.sh -r owner/repo -b branch --folder path/to/crds -o charts/my-crds/templates
```

### `cut_crds.sh`

Split multi-document YAML files into separate CRD files.

### `manage_crd_labels.sh`

Add or remove Helm labels to/from CRD templates:

```bash
DEBUG="1" YAML_ACTION="add" ./scripts/manage_crd_labels.sh charts/CHART_NAME
```

### `patch_crd_labels.sh`

Patch already-installed CRDs in a cluster with Helm labels (useful for adopting existing CRDs).

## CI/CD and Release Process

### Pull Request Workflow

Defined in `.github/workflows/lint_test.yml`:

1. Detects changed charts using chart-testing
2. Runs `ct lint` on each changed chart
3. Installs charts in a Kind cluster using `ct install`
4. Pre-installs required CRD dependencies before testing

### Release Workflow

Defined in `.github/workflows/release.yml`:

- Triggered automatically on push to `main` branch
- Uses helm/chart-releaser-action to create GitHub releases
- Publishes charts to GitHub Container Registry (ghcr.io)
- Only processes charts that have changed since last release

### Commit Compliance

Defined in `.github/workflows/compliance.yml`:

- Enforces conventional commit message format using cocogitto
- Required for all PRs before merging