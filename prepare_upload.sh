#!/bin/bash

set -ex
set -o pipefail

# Input args
CODE_DIR=$1

# Setup vars
NAME=upload_$(basename $CODE_DIR)
# Eliminate final slash
CODE_DIR=$(dirname $CODE_DIR)/$(basename $CODE_DIR)

# Copy in provided files
cp -r -n $CODE_DIR ./$NAME

# Make a blank req file if none provided
REQ_FILE=./$NAME/requirements.txt
touch $REQ_FILE

# Download all the wheels/tar balls with our docker as the target
pip download -r $REQ_FILE -d ./$NAME --python-version 36 --implementation cp --platform manylinux1_x86_64 --abi cp36m --no-deps

# Test zip does not exist yet to avoid clobber
! test -f $NAME.zip

# Build the zip with correct directory structure
(cd $NAME && zip -r ../$NAME.zip ./*)

# Display final output for user at end
set +x

echo "----------------------------------------------------------------"
echo "Built achive for upload"
unzip -l ./$NAME.zip

echo "For scoring, upload $NAME.zip at address:"
echo "https://bbochallenge.com/my-submissions"
