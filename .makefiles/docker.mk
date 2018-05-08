DOCKER = $(shell which docker 2> /dev/null)
DOCKER_IMAGE_NAME ?= resume


# builds a docker image in the current directory
docker.build:
	${call log,building docker image ($(DOCKER_IMAGE_NAME))}
	$(DOCKER) build -t $(DOCKER_IMAGE_NAME) .
.PHONY: docker.build


# launches the docker container defined by DOCKER_IMAGE_NAME (--entrypoint=bash)
docker.debug: docker.build
	$(call log,launching docker container from $(DOCKER_IMAGE_NAME) in debug mode)
	$(DOCKER) run --rm -ti --entrypoint=bash $(DOCKER_IMAGE_NAME)
.PHONY: docker.debug
