#!/bin/bash
export PYTHONPATH=python:apps/extension/python
export PYTHONPATH=${PYTHONPATH}:apps/graph_executor/python:apps/graph_executor/nnvm/python
export LD_LIBRARY_PATH=lib:${LD_LIBRARY_PATH}

CURR_DIR=$(cd `dirname $0`; pwd)
SCRIPT_DIR=$CURR_DIR/../../jvm/core/src/test/scripts
TEMP_DIR=$(mktemp -d)

python $SCRIPT_DIR/test_add_cpu.py $TEMP_DIR || exit -1
python $SCRIPT_DIR/test_add_gpu.py $TEMP_DIR || exit -1

make jvmpkg || exit -1
make jvmpkg JVM_TEST_ARGS="-DskipTests=false -Dtest.tempdir=$TEMP_DIR" || exit -1

rm -rf $TEMP_DIR
