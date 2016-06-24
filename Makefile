IMAGE=localhost/dind-generator:latest

all: build

build:
	docker build -t ${IMAGE} .

check: build
	docker run -it --rm \
		--entrypoint /bin/sh \
		${IMAGE}

run: build
	docker run -it --rm \
		-P \
		-v $$(pwd)/src:/usr/src/app \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e CERT_PATH=/data/resin-containers/cloud_formation/ssl/jenkins-builders \
		${IMAGE}

shell: build
	docker run -it --rm \
		--entrypoint /bin/sh \
		-v $$(pwd)/src:/usr/src/app \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e CERT_PATH=/data/resin-containers/cloud_formation/ssl/jenkins-builders \
		-p 8090:80 \
		${IMAGE}

