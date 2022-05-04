{{/*
Expand the name of the chart.
*/}}
{{- define "argo-crds.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "argo-crds.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "argo-crds.labels" -}}
helm.sh/chart: {{ include "cert-manager-crds.chart" . }}
{{ include "argo-crds.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "argo-crds.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cert-manager-crds.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

