{{/*
Common service template.
Usage: {{ include "lib-common.service" . }}
*/}}
{{- define "lib-common.service" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "lib-common.fullname" . }}
  labels:
    {{- include "lib-common.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type | default "ClusterIP" }}
  ports:
    - port: {{ .Values.service.port | default 80 }}
      targetPort: {{ .Values.service.targetPort | default 8080 }}
      protocol: TCP
      name: http
  selector:
    {{- include "lib-common.selectorLabels" . | nindent 4 }}
{{- end -}}
