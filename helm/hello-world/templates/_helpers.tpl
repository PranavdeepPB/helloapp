{{- define "hello-world.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "hello-world.fullname" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "hello-world.labels" -}}
app: {{ include "hello-world.name" . }}
version: {{ .Chart.AppVersion }}
{{- end }}