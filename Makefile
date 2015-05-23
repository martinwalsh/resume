DOCKER_BINDIR := vendor
DOCKER_MACHINE_HOSTNAME := resume

include includes/help.mk
include includes/docker.mk

#> creates transient directories for build artifacts
vendor build:
	@echo "=====> create the $@ directory"
	mkdir -p $@

#> renders the given tex document in pdf format
%.tex: docker-build | build
	@echo "=====> building $(call _textopdf,$@) from $@"
	$(DOCKER) run -ti -e SOURCE="$@" \
			--name $(DOCKER_IMAGE_NAME) $(DOCKER_IMAGE_NAME); \
			$(DOCKER) cp $(DOCKER_IMAGE_NAME):/resume/$(call _textopdf,$@) build/ ; \
			$(DOCKER) rm $(DOCKER_IMAGE_NAME) > /dev/null

#> builds the default resume
resume:
	make src/resume.tex
.PHONY: resume

_entrypoint:
ifndef SOURCE
	$(error No source document specified (ex. make $@ SOURCE=src/resume.tex))
endif
	cd `dirname $(SOURCE)`; \
		pdflatex --interaction=nonstopmode `basename $(SOURCE)` || true
.PHONY: _entrypoint

#> removes build artifacts
clean: docker-clean
	@echo "=====> removing build artifacts"
	rm -rf vendor
.PHONY: clean
