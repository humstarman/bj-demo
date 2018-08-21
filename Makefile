SHELL=/bin/bash
DOCKER_REGISTRY=10.254.0.50:5000
NAMESPACE=default
PORT=8080
HOST_PORT=8089
TAG=v1
NAME=bj-demo
IMAGE=${DOCKER_REGISTRY}/${NAME}:${TAG}
IMAGE_PULL_POLICY=Always
CONTAINER_NAME=${NAME}
URL=gmt.bj.me
MYSQL_NAME=mysql-proxy
MYSQL_PORT=3306
CLUSTER_IP=10.254.0.36
MYSQL_IP=192.168.100.42

all: build push deploy

build:
	@docker build -t ${IMAGE} ./tomcat

push:
	@docker push ${IMAGE} 

run:
	@docker run -d -p ${HOST_PORT}:${PORT} --name ${CONTAINER_NAME} ${IMAGE} 

clean-docker:
	@docker stop ${CONTAINER_NAME}
	@docker rm ${CONTAINER_NAME}

test:
	@curl http://127.0.0.1:${HOST_PORT}

run-it:
	@docker run -it -p ${HOST_PORT}:${PORT} --name ${CONTAINER_NAME} ${IMAGE} 

cp:
	@find ./manifests -type f -name "*.sed" | sed s?".sed"?""?g | xargs -I {} cp {}.sed {}

sed:
	@find ./manifests -type f -name "*.yaml" | xargs sed -i s?"{{.name}}"?"${NAME}"?g
	@find ./manifests -type f -name "*.yaml" | xargs sed -i s?"{{.mysql.name}}"?"${MYSQL_NAME}"?g
	@find ./manifests -type f -name "*.yaml" | xargs sed -i s?"{{.mysql.port}}"?"${MYSQL_PORT}"?g
	@find ./manifests -type f -name "*.yaml" | xargs sed -i s?"{{.url}}"?"${URL}"?g
	@find ./manifests -type f -name "*.yaml" | xargs sed -i s?"{{.namespace}}"?"${NAMESPACE}"?g
	@find ./manifests -type f -name "*.yaml" | xargs sed -i s?"{{.port}}"?"${PORT}"?g
	@find ./manifests -type f -name "*.yaml" | xargs sed -i s?"{{.image}}"?"${IMAGE}"?g
	@find ./manifests -type f -name "*.yaml" | xargs sed -i s?"{{.image.pull.policy}}"?"${IMAGE_PULL_POLICY}"?g
	@find ./manifests -type f -name "*.yaml" | xargs sed -i s?"{{.cluster.ip}}"?"${CLUSTER_IP}"?g
	@find ./manifests -type f -name "*.yaml" | xargs sed -i s?"{{.mysql.ip}}"?"${MYSQL_IP}"?g

deploy: cp sed
	@kubectl create -f ./manifests/.

clean:
	@kubectl delete -f ./manifests/.
	@find ./manifests -type f -name "*.yaml" | xargs rm -f

log:
	@./scripts/show-log.sh -n ${NAME} -s ${NAMESPACE}

del-pods:
	@./scripts/del-pod.sh -n ${NAME} -s ${NAMESPACE}

del-pod:
	@./scripts/del-pod.sh -n ${NAME} -s ${NAMESPACE} -o
