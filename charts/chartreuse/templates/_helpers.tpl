{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "chartreuse.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "chartreuse.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chartreuse.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "chartreuse.labels" -}}
app.kubernetes.io/name: {{ include "chartreuse.name" . }}
helm.sh/chart: {{ include "chartreuse.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "chartreuse.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "chartreuse.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "chartreuse.upgradeJobAnnotations" -}}
{{- if eq .Values.deploymentMethod "argocd" -}}
"argocd.argoproj.io/hook": Sync
"argocd.argoproj.io/hook-delete-policy": BeforeHookCreation
"argocd.argoproj.io/sync-wave": {{ .Values.argocd.syncWave | quote }}
{{- else -}}
{{- if .Values.upgradeBeforeDeployment -}}
{{- if .Release.IsInstall }}
# No hook: we deploy this job during the initial install, as part of the Helm Release
{{- end }}
{{- if .Release.IsUpgrade }}
# Should be run in pre-upgrade only (not pre-install)
"helm.sh/hook": pre-upgrade
"helm.sh/hook-weight": {{ .Values.upgradeJobWeight | quote }}
"helm.sh/hook-delete-policy": "before-hook-creation"
{{- end }}
{{- else }}
# Should be run in post-install,post-upgrade wherever it is install or upgrade.
"helm.sh/hook": post-install,post-upgrade
"helm.sh/hook-weight": {{ .Values.upgradeJobWeight | quote }}
"helm.sh/hook-delete-policy": "before-hook-creation"
{{- end }}
{{- end -}}
{{- end -}}

{{/*
ArgoCD sync-wave for the Job's dependency resources (ServiceAccount, ConfigMap,
RBAC, ExternalSecret). In ArgoCD mode the Job is a Sync hook at `argocd.syncWave`;
ArgoCD applies (and health-gates) lower waves first, so these dependencies must sit
one wave earlier than the Job or the hook deadlocks creating its pod (missing SA /
ConfigMap / Secret). Empty under Helm, where they ship as part of the Release.
*/}}
{{- define "chartreuse.dependencyAnnotations" -}}
{{- if eq .Values.deploymentMethod "argocd" -}}
"argocd.argoproj.io/sync-wave": {{ sub (int .Values.argocd.syncWave) 1 | quote }}
{{- end -}}
{{- end -}}

{{/*
Annotations for the chartreuse-config ExternalSecret.
- helm mode: a render-time timestamp (moved here from a label) bumps the object on
  every `helm upgrade`, forcing external-secrets to re-pull while `refreshInterval`
  is intentionally long.
- argocd mode: only the dependency sync-wave; NO timestamp. Manifests are committed
  to git, so a per-render `now` would churn the diff and break idempotency. A config
  change already mutates the ExternalSecret spec (bumping .metadata.generation), which
  triggers an immediate re-sync; tune `refreshInterval` to catch store-side rotation.
The two branches are mutually exclusive, so they never need joining.
*/}}
{{- define "chartreuse.externalSecretAnnotations" -}}
{{- include "chartreuse.dependencyAnnotations" . -}}
{{- if ne .Values.deploymentMethod "argocd" -}}
helm.sh/release-time: {{ now | unixEpoch | quote }}
{{- end -}}
{{- end -}}

{{- define "chartreuse.annotations.ephemeral" -}}
{{- if .Values.upgradeBeforeDeployment -}}
"helm.sh/hook": pre-upgrade
{{- else }}
"helm.sh/hook": post-install,post-upgrade
{{- end }}
"helm.sh/hook-weight": "-1"
"helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded,hook-failed"
{{- end -}}

# Adds suffix -ephemeral if it is a helm hook
{{- define "chartreuse.hook.suffix" -}}
{{- if eq .Values.deploymentMethod "argocd" -}}
{{/* No suffix in ArgoCD mode - single unsuffixed resource set, with the Job as a Sync hook. */}}
{{- else -}}
{{- if .Values.upgradeBeforeDeployment -}}
{{- if .Release.IsUpgrade -}}
-ephemeral
{{- end -}}
{{- else -}}
-ephemeral
{{- end -}}
{{- end -}}
{{- end -}}
