{{/*
Expand the name of the chart.
*/}}
{{- define "elasticsearch-cluster.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "elasticsearch-cluster.fullname" -}}
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
{{- define "elasticsearch-cluster.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "elasticsearch-cluster.labels" -}}
helm.sh/chart: {{ include "elasticsearch-cluster.chart" . }}
{{ include "elasticsearch-cluster.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "elasticsearch-cluster.selectorLabels" -}}
app.kubernetes.io/name: {{ include "elasticsearch-cluster.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "elasticsearch-cluster.elasticsearch-url" -}}
{{ printf "http://%s-%s-headless:9200" (index .Values "es-data-hot" "clusterName") (index .Values "es-data-hot" "nodeGroup") }}
{{- end }}

{{- define "elasticsearch-cluster.elasticsearch-credentials" -}}
{{ printf "%s-%s-credentials" (index .Values "es-data-hot" "clusterName") (index .Values "es-data-hot" "nodeGroup") }}
{{- end }}

{{- define "elasticsearch-cluster.setup.configmap" -}}
{{- if .queryConfig.enabled }}
{{- if .query }}
{{ .queryConfigName | kebabcase }}-query.json: |
    {{ .query | toJson }}
{{- end }}
{{ .queryConfigName | kebabcase }}-config.env: |
    ELASTICSEARCH_HOST="{{ hasKey .queryConfig "elasticsearchHost" | ternary .queryConfig.elasticsearchHost (include "elasticsearch-cluster.elasticsearch-url" .context) }}"
    ENDPOINT="{{ .queryConfig.endpoint }}"
    METHOD="{{ .queryConfig.method }}"
    DEBUG="{{ hasKey .queryConfig "debug" | ternary .queryConfig.debug false }}"
    {{- if .queryConfig.headers }}
    HEADERS="{{ printf "%s" (.queryConfig.headers | join ";") }}"
    {{- else }}
    HEADERS=""
    {{- end }}
{{- end }}
{{- end }}
