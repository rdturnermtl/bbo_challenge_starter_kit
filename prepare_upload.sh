#!/bin/bash

set -ex
set -o pipefail

CODE_DIR=$1
REQ_FILE=$2

NAME=upload_$(basename $CODE_DIR)
# Eliminate final slash
CODE_DIR=$(dirname $CODE_DIR)/$(basename $CODE_DIR)

# Copy in provided files
cp -r -n $CODE_DIR ./$NAME

# Download all the wheels/tar balls with our docker as the target
pip download -r $REQ_FILE -d ./$NAME --python-version 37 --implementation cp --platform manylinux1_x86_64 --abi cp37m --no-deps

# Test zip does not exist yet
! test -f $NAME.zip

(cd $NAME && zip -r ../$NAME.zip ./*)

set +x

echo "----------------------------------------------------------------"
echo "Built achive for upload"
unzip -l ./$NAME.zip

echo "For scoring, upload $NAME.zip at address:"
echo "https://chirp.azurewebsites.net/my-submissions"
