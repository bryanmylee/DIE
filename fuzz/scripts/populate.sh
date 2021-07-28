#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ] || [ -z "$6" ] || [ -z "$7" ]
  then
      echo "[usage] populate.sh [target binary path] [path of libs dir] [path of prepared corpus] [output path] [target js engine (ch/jsc/v8/ffx)] [redis_port] [num_cores]"
    exit 1
fi

SCRIPT_ROOT=`dirname $0`
ENGINE_PATH=`realpath $1`
LIBS_ROOT=`realpath $2`
CORPUS_ROOT=`realpath $3`
OUTPUT_ROOT=`realpath $4`
ENGINE=$5
REDIS_PORT=$6
NUM_CORES=$7

libs=""

if [ "$ENGINE" = "ch" ]
then
    libs="-lib=$LIBS_ROOT/lib.js -lib=$LIBS_ROOT/jsc.js -lib=$LIBS_ROOT/v8.js -lib=$LIBS_ROOT/ffx.js -lib=$LIBS_ROOT/chakra.js"
else
    libs="$LIBS_ROOT/lib.js $LIBS_ROOT/jsc.js $LIBS_ROOT/v8.js $LIBS_ROOT/ffx.js $LIBS_ROOT/chakra.js"
fi

# make_initial_corpus generates corpus directories with indices %d.
# output## will be replaced by output-%d where %d represents the index of the instance by the run-all.py script.
tmux new-session -s corpus-$PORT -d \
        "$SCRIPT_ROOT/run-all.py --cpu=$NUM_CORES --redis_port=$REDIS_PORT -- $SCRIPT_ROOT/../afl/afl-fuzz -m none -o $OUTPUT_ROOT/output## \
        -i $CORPUS_ROOT/output## \
        $ENGINE_PATH ${libs} @@"

