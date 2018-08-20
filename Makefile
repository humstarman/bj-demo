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
	@find ./manifests -type f -name "*.yaml" | xargs sed -i s?"{{.url}}"?"${URL}"?g
	@find ./manifests -type f -name "*.yaml" | xargs sed -i s?"{{.namespace}}"?"${NAMESPACE}"?g
	@find ./manifests -type f -name "*.yaml" | xargs sed -i s?"{{.port}}"?"${PORT}"?g
	@find ./manifests -type f -name "*.yaml" | xargs sed -i s?"{{.image}}"?"${IMAGE}"?g
	@find ./manifests -type f -name "*.yaml" | xargs sed -i s?"{{.image.pull.policy}}"?"${IMAGE_PULL_POLICY}"?g

deploy: cp sed
	@kubectl create -f ./manifests/.

clean:
	@kubectl delete -f ./manifests/.
	@find ./manifests -type f -name "*.yaml" | xargs rm -f
