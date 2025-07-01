{{/*
Expand the name of the chart.
*/}}
{{- define "platform-cluster-core.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "platform-cluster-core.fullname" -}}
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
{{- define "platform-cluster-core.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "platform-cluster-core.labels" -}}
helm.sh/chart: {{ include "platform-cluster-core.chart" . }}
{{ include "platform-cluster-core.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "platform-cluster-core.selectorLabels" -}}
app.kubernetes.io/name: {{ include "platform-cluster-core.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "platform-cluster-core.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "platform-cluster-core.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Filter out verbs that are prohibited
*/}}
{{- define "platform-cluster-core.verbs" -}}
{{- $verbs := hasKey .groupRule "verbs" | ternary .groupRule.verbs .groupConfigVerbs -}}
{{- $verbsProhibited := hasKey .groupRule "verbsProhibited" | ternary .groupRule.verbsProhibited list -}}
{{- range $verbProhibited := $verbsProhibited -}}
{{- if has $verbProhibited $verbs -}}
{{- $verbs = without $verbs $verbProhibited -}}
{{- end -}}
{{- end -}}
{{- range $verb := $verbs }}
- {{ $verb | quote }}
{{- end }}
{{- end -}}
