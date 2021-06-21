{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "grafana-pdf-exporter.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "grafana-pdf-exporter.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Common new-style labels
*/}}
{{- define "grafana-pdf-exporter.labels" -}}
app.kubernetes.io/name: {{ include "grafana-pdf-exporter.name" . }}
helm.sh/chart: {{ include "grafana-pdf-exporter.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Values.appVersion }}
app.kubernetes.io/version: {{ .Values.appVersion | quote }}
{{- end }}
{{- if .Values.appGitSha }}
app.kubernetes.io/git-sha: {{ .Values.appGitSha | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Common new-style label selectors
*/}}
{{- define "grafana-pdf-exporter.matchLabels" -}}
app.kubernetes.io/name: {{ include "grafana-pdf-exporter.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

