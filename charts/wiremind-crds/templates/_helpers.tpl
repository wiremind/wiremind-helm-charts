{{/*
Expand the name of the chart.
*/}}
{{- define "wiremind-crds.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "wiremind-crds.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "wiremind-crds.labels" -}}
helm.sh/chart: {{ include "wiremind-crds.chart" . }}
{{ include "wiremind-crds.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "wiremind-crds.selectorLabels" -}}
app.kubernetes.io/name: {{ include "wiremind-crds.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
