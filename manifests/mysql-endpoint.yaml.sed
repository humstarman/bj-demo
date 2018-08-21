kind: Endpoints
apiVersion: v1
metadata:
  name: {{.mysql.name}} 
subsets:
  - addresses:
      - ip: {{.mysql.ip}} 
    ports:
      - port: {{.mysql.port}}
