{{/*
Expand the name of the chart.
*/}}
{{- define "ovh-exporter.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ovh-exporter.fullname" -}}
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
{{- define "ovh-exporter.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ovh-exporter.labels" -}}
helm.sh/chart: {{ include "ovh-exporter.chart" . }}
{{ include "ovh-exporter.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ovh-exporter.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ovh-exporter.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ovh-exporter.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ovh-exporter.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Stop rendering when a key is set in both extraEnv and extraSecretEnv.

extraEnv lands in the ConfigMap and extraSecretEnv in the Secret, and the
Deployment lists the ConfigMap first in envFrom, then the Secret. Kubernetes
resolves a duplicate key in favour of the last source, so the Secret silently
wins. Neither Helm nor `helm diff` reports it: both objects render fine, and
the conflict only exists once they are merged into the container. Failing here
turns that into a rendering error instead.
*/}}
{{- define "ovh-exporter.validateNoDuplicateEnvKey" -}}
{{- $extraSecretEnv := .Values.extraSecretEnv | default dict }}
{{- range $key, $_ := .Values.extraEnv | default dict }}
{{- if hasKey $extraSecretEnv $key }}
{{- fail (printf "%s is set in both extraEnv and extraSecretEnv. envFrom loads the Secret after the ConfigMap, so the Secret value would silently win. Keep the key in one of them only." $key) }}
{{- end }}
{{- end }}
{{- end }}
