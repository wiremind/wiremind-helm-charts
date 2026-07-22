# Chartreuse Helm Chart

## What it is

Chartreuse is an Automated Alembic migrations within kubernetes.

Please refer to https://github.com/wiremind/chartreuse.

## Post-deployment restore Job (`restorePods`)

On the `upgradeBeforeDeployment` path the migration Job stops the tracked
Deployments (scale to 0 + HPA pause via `spec.behavior.scaleUp.selectPolicy:
Disabled`) and intentionally skips `start_pods()`, relying on the deployment
that follows to restore replicas. That deployment restores `spec.replicas`
only where the chart sets it — HPA-managed Deployments omit it — and never
touches the paused HPAs (`spec.behavior` is not chart-owned): without a
restore step they stay stranded at 0 / unable to scale up forever.

With `restorePods: true` (default) and `upgradeBeforeDeployment` + `stopPods`
enabled, the chart renders a `chartreuse-restore` Job that runs
`restore_stopped_pods()` after the deployment:

- `deploymentMethod: argocd` → ArgoCD `PostSync` hook.
- `deploymentMethod: helm` → `helm.sh/hook: post-upgrade`.

The Job is idempotent and annotation-gated (`wiremind.io/stopped-by`,
`wiremind.io/pre-pause-scale-behavior`), so it also heals leftovers from a
previous run that crashed or predates the restore Job. It requires chartreuse
package >= 7.0 in the image (the `chartreuse-restore` entrypoint).

## Using this chart under ArgoCD

The chart ships an opt-in ArgoCD-native mode that replaces the Helm hook
machinery with ArgoCD Sync hooks. Enable it by setting:

```yaml
deploymentMethod: argocd

argocd:
  # Sync-wave applied to the migration Job.
  # Default: -50 (runs before consumer Deployments at the default wave 0).
  syncWave: -50
```

The `deploymentMethod` value matches the umbrella `wiremind` chart and
`overwhelm`'s `--cd-version` derivation, so the same toggle propagates
end-to-end across overwhelm → wiremind → chartreuse.

### What it does

When `deploymentMethod: argocd`:

- The chartreuse migration `Job` is rendered with the following annotations:
  - `argocd.argoproj.io/hook: Sync`
  - `argocd.argoproj.io/hook-delete-policy: BeforeHookCreation`
  - `argocd.argoproj.io/sync-wave: "<argocd.syncWave>"`
- The Helm `-ephemeral` upgrade-hook resource set (ConfigMap, Role/RoleBinding,
  ServiceAccount, ExternalSecret) is **not rendered**. ArgoCD does not run
  Helm's `pre-upgrade`/`post-upgrade` hooks, so these resources serve no
  purpose under ArgoCD. The single unsuffixed resource set is used instead.
- The `HELM_IS_INSTALL` ConfigMap key is always emitted as `""` because
  ArgoCD does not have a notion of install-vs-upgrade.

### Why

Kubernetes `Job.spec.template` is immutable. ArgoCD applies resources via
`kubectl apply` by default, which fails on any image bump with:

```
Job.batch "<name>" is invalid: spec.template: Invalid value: ...:
  field is immutable
```

Declaring the Job as an ArgoCD Sync hook with `BeforeHookCreation` instructs
ArgoCD to **delete and recreate** the Job on every sync, sidestepping the
immutability constraint.

### Sync-wave model

The default `argocd.syncWave: -50` is designed to slot between database
resources (lower waves) and application Deployments (default wave `0` or
higher). Recommended ordering:

| Resource | Sync wave |
|----------|-----------|
| Database / database operator resources | `< -50` (e.g. `-100`) |
| Chartreuse migration Job | `-50` (default) |
| Application Deployments | `0` (default) |

Override `argocd.syncWave` if your deployment uses a different wave scheme.

### Backward compatibility

This mode is **opt-in**. With `deploymentMethod: helm` (the default), the
chart renders the same resources with the same annotations and naming as
previous versions; the only Helm-mode addition since 6.5.0 is the
`chartreuse-restore` post-upgrade hook Job described above (disable with
`restorePods: false` to get the pre-6.5.0 rendering).