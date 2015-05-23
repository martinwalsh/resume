OS_NAME := $(shell uname -s)
OS_ARCH := $(shell uname -m)
OS_CPU := ${shell case "$(OS_ARCH)" in *64*) echo amd64;; *) echo 386;; esac}

define _lower
$(shell awk '{ print tolower($$0) }' <<< "$1")
endef
