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
Create a default fully qualified historical name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "druid.historical.fullname" -}}
{{ template "druid.fullname" .context }}-historical-{{ .tierName }}
{{- end -}}

{{/*
Create a default fully qualified indexer name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "druid.indexer.fullname" -}}
{{ template "druid.fullname" .context }}-indexer-{{ .categoryrName }}
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
{{- range $tierName, $tierConfig := .Values.historical.tiers  }}
{{- $tiertobroker = append $tiertobroker (printf "\"%s\":\"%s\"" $tierConfig.envVars.druid_server_tier $.Values.broker.envVars.druid_service) }}
{{- end }}
{{- join "," $tiertobroker -}}
{{- end -}}
