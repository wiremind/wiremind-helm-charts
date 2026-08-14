# Wiremind fork of pmint93/metabase

This chart is a vendored fork of the upstream
[pmint93/metabase](https://github.com/pmint93/helm-charts/tree/metabase-2.27.5/charts/metabase)
Helm chart at tag `metabase-2.27.5`. The functional change is the label set on
object metadata.

Upstream stamps only `{app, chart, release, heritage}` on each object, and it
supports no `commonLabels`. Wiremind tooling cannot group on that set, so every
metabase object falls into the "(no component)" bucket of the ArgoCD Components
view.

The fork adds a `metabase.wiremindLabels` helper. Each object's
`metadata.labels` now also carries:

- the standard `app.kubernetes.io/*` labels, from the chart's own (previously
  unused) `metabase.labels` helper,
- the `commonLabels` values key, which the caller sets. `overwhelm` passes
  `app.wiremind.io/overwhelm: metabase` there.

Two objects gained a `metadata.labels` block, because upstream gives them none:
the `HorizontalPodAutoscaler` and the `pg-dump` pre-upgrade hook `Job`.

## What the fork does not change

The change is metadata only. Every selector in this chart matches on
`{app, release}`, so the immutable `Deployment`, `Service`, `ServiceMonitor` and
`SecurityGroupPolicy` selectors stay as upstream wrote them. A live release
accepts the upgrade.

Pod template labels also stay as upstream wrote them. Use `podLabels` to label
the pods, as before.

Do not put an `app.kubernetes.io/*` key in `commonLabels`. The chart stamps that
set already, and a repeated key renders a duplicate YAML key. Helm accepts it,
but `kustomize build` fails on it.

## On each upstream bump

Sync the new release into this directory, then re-apply the patch:

1. `Chart.yaml` — version `<upstream>-wiremindN`, the wiremind icon, the
   `platform@wiremind.io` maintainer and the upstream chart source.
2. `FORK.md` — this file.
3. `values.yaml` — the `commonLabels` key.
4. `templates/_helpers.tpl` — the `metabase.wiremindLabels` helper.
5. Every template that renders an object: one
   `{{- include "metabase.wiremindLabels" . | nindent 4 }}` line after
   `heritage:`. `templates/pvc.yaml` uses the helper in place of
   `metabase.labels`. `templates/hpa.yaml` and `templates/pg-dump-hook.yaml`
   need the full block.
