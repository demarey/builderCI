#!/bin/bash
#
# Copyright (c) 2012 VMware, Inc. All Rights Reserved <dhenrich@vmware.com>.
# Copyright (c) 2013-2014 GemTalk Systems, LLC <dhenrich@gemtalksystems.com>.
#
if ( test -e PharoDebug.log ); then 
  cat PharoDebug.log | tr '\r' '\n' | sed 's/^/  /'
  cat TravisTranscript.txt
  exit 1
fi
if ( test -e SqueakDebug.log ); then 
  cat SqueakDebug.log | tr '\r' '\n' | sed 's/^/  /'
  cat TravisTranscript.txt
  exit 1
fi
exit 0
