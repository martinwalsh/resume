============
Martin Walsh
============
Linux System Administrator
--------------------------

Thanks for stopping by! Please check out my current resume here_.

.. _here: https://docs.google.com/viewer?url=https://raw.githubusercontent.com/martinwalsh/resume/master/build/resume.pdf


Rebuilding
----------

1. Checkout the source
2. Run :code:`make resume`, :code:`make resume.pdf` or :code:`make build/resume.pdf`

It is possible to render arbitrary latex source files by running :code:`make
<base-filename-of-tex-source>.pdf`, however it is unlikely to result satisfactorily
if your source uses packages not already included.


Prerequisites
-------------

The following items are required by select make targets:

- GNU Make
- A suitable `docker` binary and functional docker environment


Overview of Build Steps
-----------------------

:code:`make resume` performs the following steps:

- Builds a docker image which includes a
  texlive-full installation (sorry this takes a looong time)
- Executes :code:`xelatex` on :code:`src/resume.tex`
  inside a container based on the above image

NOTE: This project has only been tested on Mac OS X, although in theory it
should work just fine on a linux system (with prerequisites installed).


Additional Options
------------------

Run :code:`make help` (or just :code:`make`) to display details about additional
options.

::

  Targets:
    clean                removes build artifacts
    %.pdf                renders the given pdf document from tex source of the same name
    resume               builds the default resume
    help                 displays this message
    shell                start a bash shell in the build environment
