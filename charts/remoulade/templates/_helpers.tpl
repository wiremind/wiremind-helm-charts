{{/*
Expand the name of the chart.
*/}}
{{- define "remoulade.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "remoulade.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "remoulade.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "remoulade.labels" -}}
helm.sh/chart: {{ include "remoulade.chart" . }}
{{ include "remoulade.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "remoulade.selectorLabels" -}}
app.kubernetes.io/name: {{ include "remoulade.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "remoulade.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "remoulade.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "remoulade.postgresql-host" -}}
{{ printf "%s-postgresql" .Release.Name }}
{{- end }}

{{- define "remoulade.rabbitmq-host" -}}
{{ printf "%s-rabbitmq" .Release.Name }}
{{- end }}

{{- define "remoulade.redis-name" -}}
{{ printf "%s-redis" .Release.Name }}
{{- end }}

{{- define "remoulade.redis-host" -}}
{{ printf "%s-master" (include "remoulade.redis-name" .) }}
{{- end }}

{{/*
Overwrite broken template from postgresql. This chart does not support being aliased
See:
  https://github.com/bitnami/charts/blob/a6751cdd33c461fabbc459fbea6f219ec64ab6b2/bitnami/postgresql/templates/NOTES.txt#L91
  https://github.com/bitnami/charts/blob/de27be6e649472608f076a04a36be3674fe3b84e/bitnami/common/templates/validations/_postgresql.tpl
*/}}
{{- define "common.errors.upgrade.passwords.empty" -}}
  Skipping PostgreSQL password validation...
{{- end -}}
