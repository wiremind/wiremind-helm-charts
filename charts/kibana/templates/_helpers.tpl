{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kibana.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kibana.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Release.Name .Values.nameOverride -}}
{{- printf "%s-%s" $name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "kibana.labels" -}}
app: {{ .Chart.Name }}
release: {{ .Release.Name | quote }}
heritage: {{ .Release.Service }}
{{- if .Values.labels }}
{{ toYaml .Values.labels }}
{{- end }}
{{- end -}}

{{- define "kibana.home_dir" -}}
/usr/share/kibana
{{- end -}}

{{- define "kibana.es-token" -}}
{{- if .Values.token.name -}}
{{ .Values.token.name }}
{{- else -}}
{{ template "kibana.fullname" . }}-es-token
{{- end -}}
{{- end -}}

{{- define "kibana.service-account" -}}
{{- if .Values.serviceAccount.name -}}
{{ .Values.serviceAccount.name }}
{{- else -}}
{{ template "kibana.fullname" . }}
{{- end -}}
{{- end -}}

{{- define "kibana.es-token-value" -}}
{{- $existingSecret := lookup "v1" "Secret" .Release.Namespace (include "kibana.es-token" .) -}}
{{- if $existingSecret -}}
{{ .Values.token.value | default (index $existingSecret.data "token" | b64dec) }}
{{- else -}}
{{ .Values.token.value -}}
{{- end -}}
{{- end -}}
