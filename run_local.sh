#!/bin/bash

set -ex
set -o pipefail

# Constants for where initial folder is
DB_ROOT=./output
DBID=demo

# Default number of steps and batch size for the challenge
N_STEP=32
N_BATCH=8

# Input args
CODE_DIR=$1
N_REPEAT=$2

# Setup vars
OPT=$(basename $CODE_DIR)
OPT_ROOT=$(dirname $CODE_DIR)

# Check that bayesmark is installed in this environment
which bayesmark-launch
which bayesmark-exp
which bayesmark-agg
which bayesmark-anal

# Test output folder exists
test -d $DB_ROOT

# Test that baseline file already present (otherwise we must include RandomSearch in the -o list)
test -f $DB_ROOT/$DBID/derived/baseline.json

# By default, runs on all models (-c), data (-d), metrics (-m)
bayesmark-launch -dir $DB_ROOT -b $DBID -n $N_STEP -r $N_REPEAT -p $N_BATCH -o $OPT --opt-root $OPT_ROOT -v

# Now aggregate the results
bayesmark-agg -dir $DB_ROOT -b $DBID
# And analyze the scores
bayesmark-anal -dir $DB_ROOT -b $DBID -v
