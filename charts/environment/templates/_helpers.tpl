{{/*
Project components
Generates an Argo Events dataTemplate expression that maps a project ID to its
component list at runtime. Produces an if/else-if chain over all repositories.

Example output:
  {{ if eq (.Input.body.project.id | int) 330 }}["backend"]{{ else if eq (.Input.body.project.id | int) 331 }}["frontend"]{{ end }}

*/}}
{{- define "environment.project.components" -}}
  {{- $repos := .Values.project.repositories -}}
  {{- range $i, $repo := $repos -}}
    {{- if eq $i 0 -}}
      {{- `{{ if eq (.Input.body.project.id | int) ` -}}
    {{- else -}}
      {{- `{{ else if eq (.Input.body.project.id | int) ` -}}
    {{- end -}}
    {{- $repo.id -}}
    {{- ` }}` -}}
	{{- $components := list -}}
	{{- range $component := $repo.components -}}
	  {{- $components = append $components $component.name -}}
	{{- end -}}
    {{- $components | toJson -}}
  {{- end -}}
  {{- `{{ end }}` -}}
{{- end -}}
