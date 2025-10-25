{{- define "my-flask-app.name" -}}
{{- default .Chart.Name .Chart.Name -}}
{{- end -}}

{{- define "my-flask-app.fullname" -}}
{{- printf "%s" .Release.Name -}}
{{- end -}}
