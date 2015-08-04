#!/bin/bash -x
#
# build_client_image.sh -- Downloads and installs the desired Smalltalk
#   installation: PharoCore-1-3, Pharo-1.4, Pharo-2.0, Squeak-4.3, Squeak-4.4
#
# Copyright (c) 2012 VMware, Inc. All Rights Reserved <dhenrich@vmware.com>.
# Copyright (c) 2013-2014 GemTalk Systems, LLC <dhenrich@gemtalksystems.com>.
#
# Environment variables defined in .travis.yml
#
#

set -e # exit on error

IMAGE_BASE_NAME=$ST
IMAGE_TARGET_NAME=$ST

case "$ST" in
  PharoCore-1.2)
    pharoGetURL="get.pharo.org/12"
    ;;
  PharoCore-1.3)
    pharoGetURL="get.pharo.org/13"
    ;;
  Pharo-1.4)
    pharoGetURL="get.pharo.org/14"
    ;;
  Pharo-2.0)
    pharoGetURL="get.pharo.org/20"
    ;;
  Pharo-3.0)
    pharoGetURL="get.pharo.org/30"
    ;;
  Pharo-4.0)
    pharoGetURL="get.pharo.org/40"
    ;;
  Pharo-5.0)
    pharoGetURL="get.pharo.org/50"
    ;;
  *)
    # noop
    ;;
esac

case "$ST" in

  # PharoCore-1.1
  PharoCore-1.1)
    cd $IMAGES_PATH
    wget http://files.pharo.org/image/11/PharoCore-1.1.2.zip
    unzip PharoCore-1.1.2.zip
    cd PharoCore-1.1.2
    IMAGE_BASE_NAME=PharoCore-1.1.2-11422
    mv *.sources $SOURCES_PATH
  ;;
  # PharoCore-1.3 - don't use zeroconf script as the newer vms apparently cause package load errors...see Issue #69
  PharoCore-1.3)
    cd $IMAGES_PATH
    wget http://files.pharo.org/image/13/13323.zip
    unzip 13323.zip
    cd PharoCore-1.3-13323
    mv *.sources $SOURCES_PATH
  ;;
  Pharo*)
    cd $IMAGES_PATH
    mkdir $ST
    cd $ST
    wget --quiet -O - get.pharo.org/vm | bash
    wget --quiet -O - ${pharoGetURL} | bash
    IMAGE_BASE_NAME=Pharo
    # move VM to $IMAGES_PATH 
    mv pharo ..
    mv pharo-vm ..    
  ;;
  # Squeak-4.3 ... allow Squeak4.3 for backwards compatibility
  Squeak-4.3|Squeak4.3)
    cd $IMAGES_PATH
    wget http://ftp.squeak.org/4.3/Squeak4.3.zip
    unzip Squeak4.3.zip
    cd Squeak4.3
    wget http://ftp.squeak.org/sources_files/SqueakV41.sources.gz
    gunzip SqueakV41.sources.gz
    IMAGE_BASE_NAME=Squeak4.3
    mv *.sources $SOURCES_PATH
    ;;
  # Squeak-4.4
  Squeak-4.4)
    cd $IMAGES_PATH
    # 4.3 stores things in a Squeak4.3 directory. 4.4 doesn't.
    # So we mimic the behaviour of 4.3.
    mkdir -p Squeak4.4
    cd Squeak4.4
    wget http://ftp.squeak.org/4.4/Squeak4.4-12327.zip
    unzip Squeak4.4-12327.zip
    wget http://ftp.squeak.org/sources_files/SqueakV41.sources.gz
    gunzip SqueakV41.sources.gz
    IMAGE_BASE_NAME=Squeak4.4-12327
    mv *.sources $SOURCES_PATH
    ;;
  # Squeak-4.5
  Squeak-4.5)
    cd $IMAGES_PATH
    # 4.3 stores things in a Squeak4.3 directory. 4.5 doesn't.
    # So we mimic the behaviour of 4.3.
    mkdir -p Squeak4.5
    cd Squeak4.5
    wget http://ftp.squeak.org/4.5/Squeak4.5-13680.zip
    unzip Squeak4.5-13680.zip
    wget http://ftp.squeak.org/sources_files/SqueakV41.sources.gz
    gunzip SqueakV41.sources.gz
    IMAGE_BASE_NAME=Squeak4.5-13680
    mv *.sources $SOURCES_PATH
    ;;
  # Squeak-Trunk
  Squeak-Trunk)
    cd $IMAGES_PATH
    mkdir -p TrunkImage
    cd TrunkImage
    wget http://build.squeak.org/job/SqueakTrunk/lastSuccessfulBuild/artifact/target/TrunkImage.zip
    unzip TrunkImage.zip
    wget http://ftp.squeak.org/sources_files/SqueakV41.sources.gz
    gunzip SqueakV41.sources.gz
    IMAGE_BASE_NAME=TrunkImage
    mv *.sources $SOURCES_PATH
    ;;

  # unknown
  \?) echo "Unknown Smalltalk version ${ST}"
    exit 1
  ;;
  esac

# move the image components into the correct location
mv ${IMAGE_BASE_NAME}.changes ../${IMAGE_TARGET_NAME}.changes
mv ${IMAGE_BASE_NAME}.image ../${IMAGE_TARGET_NAME}.image

# success
exit 0
