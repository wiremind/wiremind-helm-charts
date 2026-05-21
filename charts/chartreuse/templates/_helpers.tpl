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
{{- if eq (.Values.deploymentMethod | default "helm") "argocd" -}}
{{- if .Values.upgradeBeforeDeployment -}}
# ArgoCD has no IsInstall concept (every reconcile is a sync); run PreSync
# so the migration fires before resources on both create and update.
"argocd.argoproj.io/hook": PreSync
"argocd.argoproj.io/sync-wave": {{ .Values.upgradeJobWeight | quote }}
"argocd.argoproj.io/hook-delete-policy": BeforeHookCreation
{{- else }}
# Should be run as a PostSync hook in ArgoCD (equivalent of post-install,post-upgrade).
"argocd.argoproj.io/hook": PostSync
"argocd.argoproj.io/sync-wave": {{ .Values.upgradeJobWeight | quote }}
"argocd.argoproj.io/hook-delete-policy": BeforeHookCreation
{{- end }}
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
{{- end }}
{{- end -}}

{{- define "chartreuse.annotations.ephemeral" -}}
{{- if eq (.Values.deploymentMethod | default "helm") "argocd" -}}
{{- if .Values.upgradeBeforeDeployment -}}
"argocd.argoproj.io/hook": PreSync
{{- else }}
"argocd.argoproj.io/hook": PostSync
{{- end }}
"argocd.argoproj.io/sync-wave": "-1"
"argocd.argoproj.io/hook-delete-policy": BeforeHookCreation,HookSucceeded,HookFailed
{{- else -}}
{{- if .Values.upgradeBeforeDeployment -}}
"helm.sh/hook": pre-upgrade
{{- else }}
"helm.sh/hook": post-install,post-upgrade
{{- end }}
"helm.sh/hook-weight": "-1"
"helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded,hook-failed"
{{- end }}
{{- end -}}

# Adds suffix -ephemeral if the resource is rendered as a hook (helm or argocd).
# Under ArgoCD every sync is hook-like, so the suffix follows the same rule as
# under Helm: always suffixed in the post-deployment path, only suffixed on
# upgrade in the pre-deployment path.
{{- define "chartreuse.hook.suffix" -}}
{{- if eq (.Values.deploymentMethod | default "helm") "argocd" -}}
{{- if .Values.upgradeBeforeDeployment -}}
{{- /* PreSync hook on every sync; suffix to avoid colliding with non-hook resources. */ -}}
-ephemeral
{{- else -}}
-ephemeral
{{- end -}}
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
