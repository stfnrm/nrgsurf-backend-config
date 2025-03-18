{{/*
    Create chart name and version as used by the chart label.
    */}}
    {{- define "my-app.name" -}}
    {{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
    {{- end }}