kind: Endpoints
apiVersion: v1
metadata:
  name: {{.mysql.name}} 
subsets:
  - addresses:
      - ip: {{.host.ip}} 
    ports:
      - port: {{.mysql.port}}
