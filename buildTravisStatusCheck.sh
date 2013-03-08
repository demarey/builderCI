#!/bin/bash
#
# checks for build success/failure and dumps appropriate file to stdou
#
#      -verbose flag causes unconditional transcript display
#
# Copyright (c) 2012 VMware, Inc. All Rights Reserved <dhenrich@vmware.com>.
#
if ( test -e TravisCISuccess.txt); then 
  echo "SUCCESS: $(basename $0)"
  if [ "$1" = "-verbose" ] ; then
    $BUILDER_CI_HOME/dumpTranscript.sh
  fi
  cat TravisCISuccess.txt
  exit 0
fi
if ( test -e TravisCIFailure.txt ); then 
  echo "FAILURE: $(basename $0)"
  $BUILDER_CI_HOME/dumpTranscript.sh
  cat TravisCIFailure.txt
  exit 1
fi
echo "neither SUCCESS nor FAILURE: $(basename $0)"
if [ "$1" = "-verbose" ] ; then
  $BUILDER_CI_HOME/dumpTranscript.sh
fi
