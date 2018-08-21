kind: Service
apiVersion: v1
metadata:
  name: {{.mysql.name}} 
spec:
  clusterIP: {{.cluster.ip}}
  ports:
    - protocol: TCP 
      port: {{.mysql.port}}
      targetPort: {{.mysql.port}}
