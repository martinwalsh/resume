include $(dir $(lastword $(MAKEFILE_LIST)))common.mk

# docker
DOCKER_VERSION ?= 1.11.2
DOCKER_URL ?= \
	https://get.docker.com/builds/$(OS_NAME)/$(OS_ARCH)/docker-$(DOCKER_VERSION).tgz

# docker-machine
DOCKER_MACHINE_VERSION ?= v0.7.0
DOCKER_MACHINE_URL ?= \
	https://github.com/docker/machine/releases/download/$(DOCKER_MACHINE_VERSION)/docker-machine-$(OS_NAME)-$(OS_ARCH)

DOCKER_MACHINE_HOSTNAME ?= whatever

# docker-compose
DOCKER_COMPOSE_VERSION ?= 1.2.0
DOCKER_COMPOSE_URL ?= \
	https://github.com/docker/compose/releases/download/$(DOCKER_COMPOSE_VERSION)/docker-compose-$(OS_NAME)-$(OS_ARCH)

# shared
DOCKER_BINDIR ?= bin
BIN = $(DOCKER_BINDIR)
B2D_ISO := ~/.docker/machine/machines/$(DOCKER_MACHINE_HOSTNAME)/boot2docker.iso

DOCKER_IMAGE_NAME ?= $(DOCKER_MACHINE_HOSTNAME)
DOCKER_MACHINE_ENV = eval "$$($(BIN)/docker-machine env $(DOCKER_MACHINE_HOSTNAME))";

DOCKER = $(DOCKER_MACHINE_ENV) $(BIN)/docker
DOCKER_MACHINE = $(BIN)/docker-machine
DOCKER_COMPOSE = $(BIN)/docker-compose

$(BIN)/docker: | $(BIN)
	@echo "=====> downloading docker-$(DOCKER_VERSION)"
	curl -s -L '$(DOCKER_URL)' | tar -C $(BIN) --strip-components 1 -xvf - docker/docker
	@chmod +x $@ && touch $@

$(BIN)/docker-machine: | $(BIN)
	@echo "=====> downloading docker-machine-$(DOCKER_MACHINE_VERSION)"
	curl -o $@ -s -L '$(DOCKER_MACHINE_URL)'
	@chmod +x $@ && touch $@

$(BIN)/docker-compose: | $(BIN)
	@echo "=====> downloading docker-compose-$(DOCKER_COMPOSE_VERSION)"
	curl -o $@ -s -L '$(DOCKER_COMPOSE_URL)'
	@chmod +x $@ && touch $@

$(B2D_ISO): $(BIN)/docker-machine
	@echo "=====> creating docker-machine instance ($(DOCKER_MACHINE_HOSTNAME))"
	$(DOCKER_MACHINE) create --driver virtualbox $(DOCKER_MACHINE_HOSTNAME) || true

#> downloads docker
docker: $(BIN)/docker
.PHONY: docker

#> sets up a local docker virtual machine
docker-machine: $(B2D_ISO)
	@echo "=====> starting local docker virtual machine"
	$(DOCKER_MACHINE) start $(DOCKER_MACHINE_HOSTNAME) || true
.PHONY: docker-machine

#> downloads docker-compose
docker-compose: $(BIN)/docker-compose
.PHONY: docker-compose

#> builds a docker image in the current directory
docker-build: docker-machine docker
	@echo "=====> building docker image ($(DOCKER_IMAGE_NAME))"
	$(DOCKER) build -t $(DOCKER_IMAGE_NAME) .
.PHONY: docker.build

#> launches the docker container defined by DOCKER_IMAGE_NAME
docker-run: docker-build docker
	@echo "=====> launching docker container from $(DOCKER_IMAGE_NAME)"
	$(DOCKER) run --rm -ti $(DOCKER_IMAGE_NAME)
.PHONY: docker-run

#> launches the docker container defined by DOCKER_IMAGE_NAME (--entrypoint=bash)
docker-debug: docker-build docker
	@echo "=====> launching dcoker container from $(DOCKER_IMAGE_NAME) in debug mode"
	$(DOCKER) run --rm -ti --entrypoint=bash $(DOCKER_IMAGE_NAME)

#> removes docker-specific build artifacts
docker-clean:
	@echo "=====> remove docker-specific build artifacts"
	$(DOCKER_MACHINE) rm $(DOCKER_MACHINE_HOSTNAME) || true
.PHONY: docker-clean
