#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ]
  then
      echo "[usage] populate.sh [target binary path] [path of libs dir] [path of prepared corpus] [output path] [target js engine (ch/jsc/v8/ffx)]"
    exit 1
fi

PROJECT_ROOT=`realpath .`
ENGINE_PATH=`realpath $1`
LIBS_ROOT=`realpath $2`
CORPUS_ROOT=`realpath $3`
OUTPUT_ROOT=`realpath $4`

libs=""
if [ "$5" = "ch" ]
then
    libs="-lib=$LIBS_ROOT/lib.js -lib=$LIBS_ROOT/jsc.js -lib=$LIBS_ROOT/v8.js -lib=$LIBS_ROOT/ffx.js -lib=$LIBS_ROOT/chakra.js"
else
    libs="$LIBS_ROOT/lib.js $LIBS_ROOT/jsc.js $LIBS_ROOT/v8.js $LIBS_ROOT/ffx.js $LIBS_ROOT/chakra.js"
fi

# make_initial_corpus generates corpus directories with indices %d.
# output## will be replaced by output-%d where %d represents the index of the instance.
tmux new-session -s corpus -d \
        "$PROJECT_ROOT/fuzz/scripts/run-all.py -- $PROJECT_ROOT/fuzz/afl/afl-fuzz -m none -o $OUTPUT_ROOT/output## \
        -i $CORPUS_ROOT/output## \
        $ENGINE_PATH ${libs} @@"

