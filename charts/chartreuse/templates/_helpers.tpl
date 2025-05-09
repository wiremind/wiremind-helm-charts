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


{{- define "chartreuse.alembic.url" -}}
{{- if .Values.alembic.externalSecrets.enabled -}}
{{ printf "%s://%s:{{ .password }}@%s%s:%s/%s?sslmode=prefer" .Values.alembic.dialect .Values.alembic.username .Release.Name .Values.alembic.urlSuffix .Values.alembic.port .Values.alembic.database }}
{{- else -}}
{{ printf "%s://%s:%s@%s%s:%s/%s?sslmode=prefer" .Values.alembic.dialect .Values.alembic.username .Values.alembic.password .Release.Name .Values.alembic.urlSuffix .Values.alembic.port .Values.alembic.database }}
{{- end -}}
{{- end -}}

{{- define "chartreuse.pg_isready.url" -}}
{{- if .Values.alembic.alternativePgIsreadyChartreuseAlembicUrl.enabled -}}
{{- if .Values.alembic.externalSecrets.enabled -}}
{{ printf "postgres://%s:{{ .password }}@%s%s:%s/%s?sslmode=prefer" .Values.alembic.alternativePgIsreadyChartreuseAlembicUrl.username .Release.Name .Values.alembic.alternativePgIsreadyChartreuseAlembicUrl.urlSuffix .Values.alembic.alternativePgIsreadyChartreuseAlembicUrl.port .Values.alembic.alternativePgIsreadyChartreuseAlembicUrl.database }}
{{- else -}}
{{ printf "postgres://%s:%s@%s%s:%s/%s?sslmode=prefer" .Values.alembic.alternativePgIsreadyChartreuseAlembicUrl.username .Values.alembic.alternativePgIsreadyChartreuseAlembicUrl.password .Release.Name .Values.alembic.alternativePgIsreadyChartreuseAlembicUrl.urlSuffix .Values.alembic.alternativePgIsreadyChartreuseAlembicUrl.port .Values.alembic.alternativePgIsreadyChartreuseAlembicUrl.database }}
{{- end -}}
{{- else -}}
{{ include "chartreuse.alembic.url" . }}
{{- end -}}
{{- end -}}


{{- define "chartreuse.upgradeJobAnnotations" -}}
{{- if .Values.upgradeBeforeDeployment -}}
{{- if .Release.IsInstall }}
# No hook: we deploy this job during the initial install, as part of the Helm Release
{{- end }}
{{- if .Release.IsUpgrade }}
# Should be run in pre-upgrade only (not pre-install)
"helm.sh/hook": pre-upgrade
"helm.sh/hook-weight": {{ .Values.upgradeJobWeight | quote }}
"helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded"
{{- end }}
{{- else }}
# Should be run in post-install,post-upgrade wherever it is install or upgrade.
"helm.sh/hook": post-install,post-upgrade
"helm.sh/hook-weight": {{ .Values.upgradeJobWeight | quote }}
"helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded"
{{- end }}
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
{{- if .Values.upgradeBeforeDeployment -}}
{{- if .Release.IsUpgrade -}}
-ephemeral
{{- end -}}
{{- else -}}
-ephemeral
{{- end -}}
{{- end -}}
