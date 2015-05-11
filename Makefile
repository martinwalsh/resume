DOCKER_BINDIR := vendor
DOCKER_MACHINE_HOSTNAME := resume

include includes/help.mk
include includes/docker.mk

#> creates transient directories for build artifacts
vendor:
	@echo "=====> create the $@ directory"
	mkdir -p $@

#> renders a similarly named latex document as pdf
%.pdf: %.tex docker-build
	@echo "=====> building $@ from $<"
	$(DOCKER) run -ti -e SOURCE="$<" \
			--name $(DOCKER_IMAGE_NAME) $(DOCKER_IMAGE_NAME); \
			$(DOCKER) cp $(DOCKER_IMAGE_NAME):/resume/$@ `dirname $@` ; \
			$(DOCKER) rm $(DOCKER_IMAGE_NAME) > /dev/null

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
