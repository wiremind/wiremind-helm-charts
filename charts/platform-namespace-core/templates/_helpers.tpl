{{/*
Expand the name of the chart.
*/}}
{{- define "platform-namespace-core.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "platform-namespace-core.fullname" -}}
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
{{- define "platform-namespace-core.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "platform-namespace-core.labels" -}}
helm.sh/chart: {{ include "platform-namespace-core.chart" . }}
{{ include "platform-namespace-core.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "platform-namespace-core.selectorLabels" -}}
app.kubernetes.io/name: {{ include "platform-namespace-core.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Returns the service account name if defined, otherwise a fallback default.
Usage: {{ include "platform-namespace-core.serviceAccountName" (dict "def" $def "defName" $defName) }}
*/}}
{{- define "platform-namespace-core.serviceAccountName" -}}
{{- $def := .def -}}
{{- $defName := .defName -}}
{{- if and $def.serviceAccount (hasKey $def.serviceAccount "name") -}}
{{ $def.serviceAccount.name }}
{{- else -}}
{{ printf "%s" $defName }}
{{- end -}}
{{- end -}}

{{/*
Validate the platform-namespace-core chart.
*/}}
{{- define "platform-namespace-core.validate" -}}
{{- $errors := list -}}
{{ if .Values.namespace.create }}
{{- if not (hasKey .Values.namespace.labels "project") }}
{{- $errors = append $errors (printf "Namespace label 'project' must be defined for platform-namespace-core") -}}
{{- end -}}
{{- if not (hasKey .Values.namespace.labels "product") }}
{{- $errors = append $errors (printf "Namespace label 'product' must be defined for platform-namespace-core") -}}
{{- end -}}
{{- end -}}

{{- if gt (len $errors) 0 }}
{{- fail (join "\n" $errors) }}
{{- end -}}
{{- end -}}

{{/*
ClusterSecretStore name definition.
*/}}
{{- define "platform-namespace-core.cluster-secret-store.name" -}}
{{- if eq .Values.namespace.labels.project "platform" -}}
{{- printf "%s-platform-%s" .Values.clusterSecretStore.provider.name .Release.Name -}}
{{- else -}}
{{- printf "%s-%s" .Values.clusterSecretStore.provider.name .Release.Name -}}
{{- end -}}
{{- end -}}
