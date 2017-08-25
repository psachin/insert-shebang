#!/bin/sh -e

cd "$(dirname "$0")"

# PATH to GNU Emacs binary
ECUKES_EMACS=${EMACS:-"/home/psachin/github/emacs/src/emacs"}
export ECUKES_EMACS

echo "*** Emacs version ***"
echo "ECUKES_EMACS = $ECUKES_EMACS"
"$ECUKES_EMACS" --version
echo

bash ./run-tests.sh $TAGS
