{{/*
Expand the name of the chart.
*/}}
{{- define "velero-crds.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "velero-crds.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "velero-crds.labels" -}}
helm.sh/chart: {{ include "velero-crds.chart" . }}
{{ include "velero-crds.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "velero-crds.selectorLabels" -}}
app.kubernetes.io/name: {{ include "velero-crds.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

