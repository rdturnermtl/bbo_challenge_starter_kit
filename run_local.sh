#!/bin/bash

set -ex
set -o pipefail

# Default number of steps and batch size for the challenge
# N_STEP=32
# N_BATCH=8

# For a fast experiment:
N_STEP=15
N_BATCH=1

# Input args
CODE_DIR=$1
N_REPEAT=$2

# Where output goes
DB_ROOT=./output
DBID=run_$(date +"%Y%m%d_%H%M%S")

# Setup vars
OPT=$(basename $CODE_DIR)
OPT_ROOT=$(dirname $CODE_DIR)

# Check that bayesmark is installed in this environment
which bayesmark-init
which bayesmark-launch
which bayesmark-exp
which bayesmark-agg
which bayesmark-anal

# Ensure output folder exists
mkdir -p $DB_ROOT

# Copy the baseline file in, we can skip this but we must include RandomSearch in the -o list
! test -d $DB_ROOT/$DBID/  # Check the folder does not yet exist
bayesmark-init -dir $DB_ROOT -b $DBID
cp ./input/baseline-$N_STEP-$N_BATCH.json $DB_ROOT/$DBID/derived/baseline.json

# By default, runs on all models (-c), data (-d), metrics (-m)
bayesmark-launch -dir $DB_ROOT -b $DBID -n $N_STEP -r $N_REPEAT -p $N_BATCH -o $OPT --opt-root $OPT_ROOT -v -c SVM DT -d boston wine
# To run on all problems use instead (slower):
# bayesmark-launch -dir $DB_ROOT -b $DBID -n $N_STEP -r $N_REPEAT -p $N_BATCH -o $OPT --opt-root $OPT_ROOT -v

# Now aggregate the results
bayesmark-agg -dir $DB_ROOT -b $DBID
# And analyze the scores
bayesmark-anal -dir $DB_ROOT -b $DBID -v
