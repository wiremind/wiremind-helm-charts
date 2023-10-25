{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "druid.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "druid.fullname" -}}
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
{{- define "druid.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified historical tier name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "druid.historical.tier.fullname" -}}
{{ template "druid.fullname" .context }}-{{ .context.Values.historical.defaults.name }}-{{ .tierName }}
{{- end -}}

{{/*
Create a default fully qualified historical name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "druid.historical.fullname" -}}
{{ template "druid.fullname" . }}-{{ .Values.historical.defaults.name }}
{{- end -}}

{{/*
Create a default fully qualified indexer category name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "druid.indexer.category.fullname" -}}
{{ template "druid.fullname" .context }}-{{ .context.Values.indexer.defaults.name }}-{{ .categoryName }}
{{- end -}}

{{/*
Create a default fully qualified indexer name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "druid.indexer.fullname" -}}
{{ template "druid.fullname" . }}-{{ .Values.indexer.defaults.name }}
{{- end -}}

{{/*
Create a default fully qualified broker name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "druid.broker.fullname" -}}
{{ template "druid.fullname" . }}-{{ .Values.broker.name }}
{{- end -}}

{{/*
Create a default fully qualified router name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "druid.router.fullname" -}}
{{ template "druid.fullname" . }}-{{ .Values.router.name }}
{{- end -}}

{{/*
Create a default fully qualified coordinator name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "druid.coordinator.fullname" -}}
{{ template "druid.fullname" . }}-{{ .Values.coordinator.name }}
{{- end -}}

{{/*
Create a default fully qualified monitoring component name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "druid.monitoring.fullname" -}}
{{ template "druid.fullname" . }}-{{ .Values.monitoring.name }}
{{- end -}}

{{/*
Create a default fully qualified postgresql-s3-backup component name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "druid.postgresql-s3-backup.fullname" -}}
{{ template "druid.fullname" . }}-pg-s3-backup
{{- end -}}

{{/*
Create a default fully qualified configJobs component name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "druid.configJobs.fullname" -}}
{{ template "druid.fullname" . }}-config-job
{{- end -}}

{{/*
Common labels
*/}}
{{- define "druid.common-labels" -}}
app.kubernetes.io/name: {{ include "druid.name" . }}
helm.sh/chart: {{ include "druid.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Common label selectors
*/}}
{{- define "druid.common-matchLabels" -}}
app.kubernetes.io/name: {{ include "druid.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
TierToBrokerMap
*/}}
{{- define "tiertobroker.map" -}}
{{- $tiertobroker := list }}
{{- range $tierName, $tierConfig := .Values.historical.tiers }}
{{- $tiertobroker = append $tiertobroker (printf "\"%s\":\"%s\"" (include "druid.server.tier" (dict "tierName" $tierName "tierConfig" $tierConfig)) (include "druid.service.broker" $)) }}
{{- end }}
{{- join "," $tiertobroker -}}
{{- end -}}

{{- define "druid.server.tier" -}}
{{- .tierConfig.envVars.druid_server_tier | default (printf "tier_%s" .tierName) -}}
{{- end -}}

{{- define "druid.service.broker" -}}
{{- printf "%s" (.Values.broker.envVars.druid_service | default "druid/broker") -}}
{{- end -}}

{{/*
Parameters:
- tierName
- tierConfig
- context
*/}}
{{- define "druid.historical.config.individual.content" -}}
{{- range $key, $val := .tierConfig.envVars }}
{{ $key }}: {{ $val | quote }}
{{- end }}
{{- end -}}

{{/*
Parameters:
- tierConfig
*/}}
{{- define "druid.historical.secret.individual.content" -}}
{{- range $key, $val := .tierConfig.secretEnvVars -}}
{{ $key }}: {{ $val | b64enc }}
{{- end }}
{{- end -}}

{{/*
Create the name of the broker service account
*/}}
{{- define "druid.broker.serviceAccountName" -}}
  {{- if .Values.broker.serviceAccount.create }}
    {{- default (include "druid.broker.fullname" .) .Values.broker.serviceAccount.name }}
  {{- else }}
    {{- default "default" .Values.broker.serviceAccount.name }}
  {{- end }}
{{- end }}

{{/*
Create the name of the historical service account
*/}}
{{- define "druid.historical.serviceAccountName" -}}
  {{- if .Values.historical.defaults.serviceAccount.create }}
    {{- default (include "druid.historical.fullname" .) .Values.historical.defaults.serviceAccount.name }}
  {{- else }}
    {{- default "default" .Values.historical.defaults.serviceAccount.name }}
  {{- end }}
{{- end }}

{{/*
Create the name of the indexer service account
*/}}
{{- define "druid.indexer.serviceAccountName" -}}
  {{- if .Values.indexer.defaults.serviceAccount.create }}
    {{- default (include "druid.indexer.fullname" .) .Values.indexer.defaults.serviceAccount.name }}
  {{- else }}
    {{- default "default" .Values.indexer.defaults.serviceAccount.name }}
  {{- end }}
{{- end }}

{{/*
Create the name of the coordinator service account
*/}}
{{- define "druid.coordinator.serviceAccountName" -}}
  {{- if .Values.coordinator.serviceAccount.create }}
    {{- default (include "druid.coordinator.fullname" .) .Values.coordinator.serviceAccount.name }}
  {{- else }}
    {{- default "default" .Values.coordinator.serviceAccount.name }}
  {{- end }}
{{- end }}

{{/*
Create the name of the overlord service account
*/}}
{{- define "druid.overlord.serviceAccountName" -}}
  {{- if .Values.overlord.serviceAccount.create }}
    {{- default (include "druid.overlord.fullname" .) .Values.overlord.serviceAccount.name }}
  {{- else }}
    {{- default "default" .Values.overlord.serviceAccount.name }}
  {{- end }}
{{- end }}

{{/*
Create the name of the router service account
*/}}
{{- define "druid.router.serviceAccountName" -}}
  {{- if .Values.router.serviceAccount.create }}
    {{- default (include "druid.router.fullname" .) .Values.router.serviceAccount.name }}
  {{- else }}
    {{- default "default" .Values.router.serviceAccount.name }}
  {{- end }}
{{- end }}
