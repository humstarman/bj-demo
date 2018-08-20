apiVersion: v1
kind: Service
metadata:
  namespace: {{.namespace}}
  labels:
    component: {{.name}} 
  name: {{.name}}
spec:
  type: ClusterIP 
  selector:
    component: {{.name}}
  ports:
    - port: {{.port}} 
      targetPort: {{.port}} 
      name: http 
