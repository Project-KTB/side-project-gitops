{{/*
Chart 이름을 반환합니다.
*/}}
{{- define "side-project-backend.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Helm Release를 포함한 전체 리소스 이름을 반환합니다.

Release 이름을 side-project-backend로 사용하면 최종 이름도
side-project-backend가 됩니다.
*/}}
{{- define "side-project-backend.fullname" -}}
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
helm.sh/chart 라벨에 사용할 Chart 이름과 버전입니다.
*/}}
{{- define "side-project-backend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Deployment, Service, topologySpreadConstraints가 공통으로 사용하는 라벨입니다.
*/}}
{{- define "side-project-backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "side-project-backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
모든 리소스에 공통으로 적용하는 권장 라벨입니다.
*/}}
{{- define "side-project-backend.labels" -}}
helm.sh/chart: {{ include "side-project-backend.chart" . }}
{{ include "side-project-backend.selectorLabels" . }}
app.kubernetes.io/version: {{ default .Chart.AppVersion .Values.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: backend
app.kubernetes.io/part-of: side-project
{{- end }}

{{/*
ConfigMap 이름입니다.
*/}}
{{- define "side-project-backend.configMapName" -}}
{{- printf "%s-config" (include "side-project-backend.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
