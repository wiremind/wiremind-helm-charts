{{/*
Expand the name of the chart.
*/}}
{{- define "keycloak-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "keycloak-operator.fullname" -}}
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
{{- define "keycloak-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "keycloak-operator.labels" -}}
helm.sh/chart: {{ include "keycloak-operator.chart" . }}
{{ include "keycloak-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "keycloak-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "keycloak-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "keycloak-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "keycloak-operator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create hardcoded values from keycloak-operator
https://github.com/keycloak/keycloak-operator/blob/main/pkg/model/constants.go
*/}}
{{- define "keycloak-operator.keycloak.applicationName" -}}
{{- default "keycloak" .Values.keycloak.applicationNameOverride }}
{{- end }}
{{- define "keycloak-operator.keycloak.servicePort" -}}
{{- default "8443" .Values.keycloak.servicePortOverride }}
{{- end }}
