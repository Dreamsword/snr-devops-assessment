{{/*
Common deployment template.
Usage: {{ include "lib-common.deployment" . }}
*/}}
{{- define "lib-common.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "lib-common.fullname" . }}
  labels:
    {{- include "lib-common.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount | default 1 }}
  selector:
    matchLabels:
      {{- include "lib-common.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "lib-common.selectorLabels" . | nindent 8 }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy | default "IfNotPresent" }}
        ports:
            - name: http
              containerPort: {{ .Values.service.targetPort | default 8080 }}
              protocol: TCP
          {{- if .Values.probes }}
          {{- if .Values.probes.liveness }}
          livenessProbe:
            httpGet:
              path: {{ .Values.probes.liveness.path }}
              port: http
            initialDelaySeconds: {{ .Values.probes.liveness.initialDelaySeconds | default 10 }}
            periodSeconds: {{ .Values.probes.liveness.periodSeconds | default 10 }}
          {{- end }}
          {{- if .Values.probes.readiness }}
          readinessProbe:
            httpGet:
              path: {{ .Values.probes.readiness.path }}
              port: http
            initialDelaySeconds: {{ .Values.probes.readiness.initialDelaySeconds | default 5 }}
            periodSeconds: {{ .Values.probes.readiness.periodSeconds | default 10 }}
          {{- end }}
          {{- end }}
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
{{- end -}}
