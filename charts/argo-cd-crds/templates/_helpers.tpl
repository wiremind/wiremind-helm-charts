{{/*
Expand the name of the chart.
*/}}
{{- define "argo-cd-crds.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "argo-cd-crds.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "argo-cd-crds.labels" -}}
helm.sh/chart: {{ include "argo-cd-crds.chart" . }}
{{ include "argo-cd-crds.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "argo-cd-crds.selectorLabels" -}}
app.kubernetes.io/name: {{ include "argo-cd-crds.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

