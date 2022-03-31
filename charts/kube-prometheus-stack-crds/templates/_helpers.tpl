{{/*
Expand the name of the chart.
*/}}
{{- define "kube-prometheus-stack-crds.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kube-prometheus-stack-crds.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kube-prometheus-stack-crds.labels" -}}
helm.sh/chart: {{ include "kube-prometheus-stack-crds.chart" . }}
{{ include "kube-prometheus-stack-crds.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kube-prometheus-stack-crds.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kube-prometheus-stack-crds.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

