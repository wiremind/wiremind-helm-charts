{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "pythie.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pythie.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pythie.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "pythie.untar" -}}
set -e; set -x;
cd /mnt/models;
mc config host add s3 $S3_ENDPOINT_URL $S3_ACCESS_KEY_ID $S3_SECRET_ACCESS_KEY --api S3v4;
{{- range $model := .models -}}
# get file etag from s3 with minio client stat command and parse json result
file_etag=`mc stat {{ $model.path }}{{ $model.version }}/{{ $model.name }}.tgz | grep -i etag | tr -d ' ' | cut -d ':' -f2`;
# compare both etags and copy model files if they match
if [ "$file_etag" = "{{ $model.etag }}" ];
then
  echo "Model {{ $model.name }}: etag OK";
  mc cp -r {{ $model.path }}{{ $model.version }}/ /mnt/models;
else
  echo "Etags don't match for model {{ $model.name }}: aborting";
  exit 1;
fi
{{- end }}
count=`ls -1 *.tgz 2>/dev/null | wc -l`;
if [ $count != 0 ]; then for filename in *.tgz; do tar -zxvf "$filename"; rm "$filename"; done; fi
count=`ls -1 *.tar.gz 2>/dev/null | wc -l`;
if [ $count != 0 ]; then for filename in *.tar.gz; do tar -zxvf "$filename"; rm "$filename"; done; fi
chmod -R a+rx .;
{{- range $model := .models -}}
cp metadata.json {{ $model.name }}/;
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "pythie.labels" -}}
app.kubernetes.io/name: {{ include "pythie.name" . }}
helm.sh/chart: {{ include "pythie.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Model labels
*/}}
{{- define "pythie.modelLabels" -}}
{{- with .name }}
serving/truncated-name: {{ . | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- with .implementation }}
serving/implementation: {{ . | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end -}}

{{/*
Common label selectors
*/}}
{{- define "pythie.matchLabels" -}}
app.kubernetes.io/name: {{ include "pythie.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
