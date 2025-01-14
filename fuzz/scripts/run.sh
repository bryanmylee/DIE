#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ] || [ -z "$6" ]
  then
    echo "[usage] populate.sh [target binary path] [path of libs dir] [output path] [target js engine (ch/jsc/v8/ffx)] [redis_port] [num_cores]"
    exit 1
fi

SCRIPT_ROOT=`dirname $0`
ENGINE_PATH=`realpath $1`
LIBS_ROOT=`realpath $2`
OUTPUT_ROOT=`realpath $3`
ENGINE=$4
REDIS_PORT=$5
NUM_CORES=$6

libs=""

if [ "$ENGINE" = "ch" ]
then
    libs="-lib=$LIBS_ROOT/lib.js -lib=$LIBS_ROOT/jsc.js -lib=$LIBS_ROOT/v8.js -lib=$LIBS_ROOT/ffx.js -lib=$LIBS_ROOT/chakra.js"
else
    libs="$LIBS_ROOT/lib.js $LIBS_ROOT/jsc.js $LIBS_ROOT/v8.js $LIBS_ROOT/ffx.js $LIBS_ROOT/chakra.js"
fi

# make_initial_corpus generates corpus directories with indices %d.
# output## will be replaced by output-%d where %d represents the index of the instance by the run-all.py script.
tmux new-session -s fuzzer-$PORT -d \
        "$SCRIPT_ROOT/run-all.py --cpu=$NUM_CORES --redis_port=$REDIS_PORT -- $SCRIPT_ROOT/../afl/afl-fuzz -m none -o $OUTPUT_ROOT/output## \
        $ENGINE_PATH ${libs} @@"
