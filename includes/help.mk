.DEFAULT_GOAL: help

#> displays this message
help:
	@python2.7 -c "$$HELPSCRIPT"

define HELPSCRIPT
#!/usr/bin/env python
"""
This script parses the targets defined in MAKEFILE_LIST and displays any help
text provided; lines beginning with `#>', immediately preceeding a make recipe,
will be automatically included in `make help' output.
"""
import re, sys, argparse

targets = []
for makefile in '$(MAKEFILE_LIST)'.strip().split():
    helptext, found = [], False
    with open(makefile) as f:
        for line in f:
            while line.startswith('#>'):
                helptext.append(line)
                line, found = f.next(), True
            if found:
                targets.append((line.split(':', 1)[0],
                    dict(nargs='?', help=' '.join(x[3:] for x in helptext))))
                helptext, found = [], False

args = argparse.ArgumentParser('make', add_help=False)
for name, kwds in sorted(targets):
	args.add_argument(name.replace(' ', '|'), **kwds)
args.print_help()
endef
export HELPSCRIPT
