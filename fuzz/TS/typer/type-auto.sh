#!/bin/bash
TARGET=$HOME/fz-8.8-12h
V8=$HOME/build/die-8.8/d8
NUM_CORES=16
CORES=`seq 1 1 $NUM_CORES`
NUM_CASES=`ls $TARGET | wc -l`
NUM_CASES_PER_CORE=`expr $NUM_CASES / $NUM_CORES + 1`

pushd $TARGET
for CORE in $CORES
do
  mkdir -p ../temp/sub-$CORE
  mv `ls . | head -$NUM_CASES_PER_CORE` ../temp/sub-$CORE/
done
for CORE in $CORES
do
  mv ../temp/sub-$CORE .
done
rm -rf ../temp
popd

for CORE in $CORES
do
  tmux new-window -n "typing-$CORE" "./typer.py $TARGET/sub-$CORE $V8; /bin/bash" &
done

