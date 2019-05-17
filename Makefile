include .makefiles/ludicrous.mk
include .makefiles/docker-compose.mk


_run: | build
	docker-compose run resume
.PHONY: _run


#> start a shell session
shell: | _program_docker-compose
	docker-compose exec resume /bin/bash 2>/dev/null || docker-compose run resume /bin/bash


#> open the default resume
open:
	open build/resume.pdf


#> builds the default resume
resume: export SOURCE := src/resume.tex
resume: | _run
.PHONY: resume

_resume: SHELL := /bin/bash
_resume: | _var_SOURCE
	( cd `dirname $(SOURCE)`; \
		( xelatex `basename $(SOURCE)` && xelatex `basename $(SOURCE)` ) \
	) && \
	( mv -v $(patsubst %.tex,%.pdf,$(SOURCE)) build/ && \
		rm -fv $(patsubst %.tex,%,$(SOURCE)).{aux,log,out} ) || true
.PHONY: _resume
