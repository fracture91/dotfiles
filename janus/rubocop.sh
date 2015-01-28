#!/bin/bash

# This is really dumb.
# For whatever reason, running rubocop is giving me this warning on stderr:
#  warning: parser/current is loading parser/ruby21, which recognizes
#  warning: 2.1.5-compliant syntax, but you are running 2.1.2.
# It seems like if rubocop prints anything to stderr, syntastic refuses to
# use it as a checker.  So, replace the default checker with this script.

rubocop 2> /dev/null "$@"
