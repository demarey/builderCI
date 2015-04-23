#!/bin/bash -x
#
# Test driver script for builderCI itself
#
#      -verbose flag causes unconditional transcript display
#
# Copyright (c) 2012-2013 VMware, Inc. All Rights Reserved <dhenrich@vmware.com>.
# Copyright (C) 2014 GemTalk Systems LLC <dale.henrichs@gemtalksystems.com>
#

#run tests
./testTravisCI.sh "$@"
if [[ $? != 0 ]] ; then exit 1; fi

# make sure that system runs okay when you skip the metacello bootstrap step
cd $BUILDER_CI_HOME
./build.sh -i $ST -m -X -f "$BUILDER_CI_HOME/tests/skipMetacelloBootstrap.st" -o travisCI
if [[ $? != 0 ]] ; then 
  echo "ERROR: $(basename $0)"
  cd "${BUILD_PATH}/travisCI/"
  $BUILDER_CI_HOME/buildImageErrorCheck.sh # dump Transcript on error and exit
  $BUILDER_CI_HOME/dumpTranscript.sh
  exit 1
fi
cd "${BUILD_PATH}/travisCI/"
$BUILDER_CI_HOME/buildImageErrorCheck.sh
if [[ $? != 0 ]] ; then exit 1; fi
$BUILDER_CI_HOME/buildTravisStatusCheck.sh "$@"
if [[ $? != 0 ]] ; then exit 1; fi
