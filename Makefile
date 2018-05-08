include .makefiles/ludicrous.mk
include .makefiles/docker.mk


build:
	$(call log,create the $@ directory)
	mkdir -p $@
.PHONY: build


_pdf2tex = src/$(notdir $(patsubst %.pdf,%.tex,$(1)))


#> renders the given pdf document from tex source of the same name
%.pdf: docker.build | build _program_docker
	$(call log,building $@ from $(call _pdf2tex,$@))
	$(DOCKER) run -ti -e SOURCE="$(call _pdf2tex,$@)" \
			--name $(DOCKER_IMAGE_NAME) $(DOCKER_IMAGE_NAME); \
			$(DOCKER) cp $(DOCKER_IMAGE_NAME):/resume/src/$(notdir $@) build/; \
			$(DOCKER) rm $(DOCKER_IMAGE_NAME) > /dev/null


#> builds the default resume
resume:
	@rm -f build/resume.pdf
	$(MAKE) --no-print-directory build/resume.pdf
.PHONY: resume

_docker_entrypoint:
ifndef SOURCE
	$(error No source document specified (ex. make $@ SOURCE=src/resume.tex))
endif
	cd `dirname $(SOURCE)`; \
		( xelatex `basename $(SOURCE)` && xelatex `basename $(SOURCE)` ) || true
.PHONY: _docker_entrypoint


#> start a bash shell in the build environment
shell: docker.debug
.PHONY: shell


#> removes build artifacts
clean:: | _program_docker
	$(call log,removing build artifacts)
	docker rmi $(DOCKER_IMAGE_NAME)
