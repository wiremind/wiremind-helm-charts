{{/*
Expand the name of the chart.
*/}}
{{- define "postgres-operator-crds.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "postgres-operator-crds.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "postgres-operator-crds.labels" -}}
helm.sh/chart: {{ include "postgres-operator-crds.chart" . }}
{{ include "postgres-operator-crds.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "postgres-operator-crds.selectorLabels" -}}
app.kubernetes.io/name: {{ include "postgres-operator-crds.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

