{{/*
Expand the name of the chart.
*/}}
{{- define "cert-manager-crds.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cert-manager-crds.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cert-manager-crds.labels" -}}
helm.sh/chart: {{ include "cert-manager-crds.chart" . }}
{{ include "cert-manager-crds.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cert-manager-crds.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cert-manager-crds.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

