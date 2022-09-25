{{/*
Expand the name of the chart.
*/}}
{{- define "helm-zookeeper.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "helm-zookeeper.fullname" -}}
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
{{- define "helm-zookeeper.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "helm-zookeeper.labels" -}}
helm.sh/chart: {{ include "helm-zookeeper.chart" . }}
{{ include "helm-zookeeper.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "helm-zookeeper.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helm-zookeeper.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "helm-zookeeper.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "helm-zookeeper.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}






{{/*
Expand the name of the chart.
*/}}
{{- define "tools.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create fully qualified name
*/}}
{{- define "tools.names.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name:= default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "." -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create namespace
*/}}
{{- define "tools.namespace" -}}
{{- .Values.namespace -}}
{{- end -}}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tools.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "tools.labels" -}}
helm.sh/chart: {{ include "tools.chart" . }}
{{ include "tools.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tools.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tools.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Values.commonLabels -}}
{{- printf "\n" -}}
{{- include "tools.tplvalues.render" (dict "value" .Values.commonLabels "context" $ ) -}}
{{- end -}}
{{- end -}}

{{/*
Renders values that contains template
*/}}
{{- define "tools.tplvalues.render" -}}
{{- if typeIs "string" .value -}}
{{- tpl .value .context -}}
{{- else -}}
{{- tpl (.value | toYaml) .context -}}
{{- end -}}
{{- end -}}


{{/*
Renders common annotations
*/}}
{{- define "tools.commonannotations" -}}
{{- include "tools.tplvalues.render" (dict "value" .Values.commonAnnotations "context" $ ) -}}
{{- end -}}

{{/*
Renders common annotations
*/}}
{{- define "tools.podannotations" -}}
{{- include "tools.tplvalues.render" (dict "value" .Values.podAnnotations "context" $ ) -}}
{{- end -}}

{{/*
Renders master name
*/}}
{{- define "tools.master.name" -}}
{{ printf "%s" (include "tools.names.fullname" .) }}
{{- end -}}


{{/*
Renders worker name
*/}}
{{- define "tools.worker.name" -}}
{{ printf "%s-worker" (include "tools.names.fullname" .) }}
{{- end -}}

{{/*
Renders service name
*/}}
{{- define "tools.service.name" -}}
{{ printf "%s-svc" (include "tools.names.fullname" .) }}
{{- end -}}


{{/*
Renders headless name
*/}}
{{- define "tools.service.headless" -}}
{{ printf "%s-headless" (include "tools.names.fullname" .) }}
{{- end -}}

{{/*
Renders master name
*/}}
{{- define "tools.master.url" -}}
{{ printf "%s-0.%s.%s.svc.cluster.local" (include "tools.master.name" .) (include "tools.service.headless" .) .Values.namespace}}
{{- end -}}

{{/*
Renders disruption name
*/}}
{{- define "tools.disruption.budget" -}}
{{ printf "%s-disruption-budget" (include "tools.names.fullname" .) }}
{{- end -}}


