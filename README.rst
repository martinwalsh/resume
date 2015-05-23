============
Martin Walsh
============
Linux System Administrator
--------------------------

Thanks for stopping by! Please check out my current resume here_.

.. _here: https://github.com/martinwalsh/resume/blob/master/build/resume.pdf


Rebuilding
----------

1. Checkout the source
2. Run :code:`make resume` or :code:`make src/resume.tex`

It is possible to render arbitrary latex source files by running :code:`make
<path-to-source>.tex`, however it is unlikely to result satisfactorily if your
source uses packages not already included.


Prerequisites
-------------

The following items are required by select make targets:

- make      (of course)
- curl      (for downloading the various docker utilities)
- python2.7 (for displaying help embedded as comments)


Overview of Build Steps
-----------------------

:code:`make resume` performs the following steps:

- Downloads docker-machine, if not already present
- Starts a docker host using the virtualbox driver
- Builds a docker image which includes a minimal texlive installation
- Executes :code:`pdflatex` on :code:`src/resume.tex` inside a container based
  on the above image

NOTE: This project has only been tested on Mac OS X, although in theory it
should work just fine on a linux system (with prerequisites installed).


Additional Options
------------------

Run :code:`make help` (or just :code:`make`) to display details about additional
options.

::

  usage: make [%.tex] [clean] [docker] [docker-build] [docker-clean]
              [docker-compose] [docker-debug] [docker-machine] [docker-run]
              [help] [resume] [vendor|build]

  positional arguments:
    %.tex           renders the given tex document in pdf format
    clean           removes build artifacts
    docker          downloads docker
    docker-build    builds a docker image in the current directory
    docker-clean    removes docker-specific build artifacts
    docker-compose  downloads docker-compose
    docker-debug    launches the docker container defined by DOCKER_IMAGE_NAME
                    (--entrypoint=bash)
    docker-machine  sets up a local docker virtual machine
    docker-run      launches the docker container defined by DOCKER_IMAGE_NAME
    help            displays this message
    resume          builds the default resume
    vendor|build    creates transient directories for build artifacts
