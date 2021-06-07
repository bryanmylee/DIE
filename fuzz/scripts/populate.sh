#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
  then
      echo "[usage] populate.sh [target binary path] [path of DIE-corpus dir] [target js engine (ch/jsc/v8/ffx)]"
    exit 1
fi

PROJECT_ROOT=`realpath .`
ENGINE_PATH=`realpath $1`
DIE_corpus=`realpath $2`
CORPUS_ROOT=`realpath "$2/.."`

libs=""
if [ "$3" = "ch" ]
then
    libs="-lib=$DIE_corpus/lib.js -lib=$DIE_corpus/jsc.js -lib=$DIE_corpus/v8.js -lib=$DIE_corpus/ffx.js -lib=$DIE_corpus/chakra.js"
else
    libs="$DIE_corpus/lib.js $DIE_corpus/jsc.js $DIE_corpus/v8.js $DIE_corpus/ffx.js $DIE_corpus/chakra.js"
fi

pushd $CORPUS_ROOT
tmux new-session -s corpus -d \
        "$PROJECT_ROOT/fuzz/scripts/run-all.py -- $PROJECT_ROOT/fuzz/afl/afl-fuzz -m none -o output \
        -i $CORPUS_ROOT/corpus/output \
        "$ENGINE_PATH" ${libs} @@"

