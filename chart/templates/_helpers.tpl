{{- /*
Return chart name (safe)
*/ -}}
{{- define "demo-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 -}}
{{- end -}}

{{- /*
Return fullname for resources
*/ -}}
{{- define "demo-app.fullname" -}}
{{- $name := include "demo-app.name" . -}}
{{- printf "%s" $name -}}
{{- end -}}
