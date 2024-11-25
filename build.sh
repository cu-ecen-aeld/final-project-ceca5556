#!/bin/bash
# Script to build image for qemu.
# Author: Siddhant Jajoo.

git submodule init
git submodule sync
git submodule update

# local.conf won't exist until this step on first execution
source poky/oe-init-build-env

CONFLINE="MACHINE = \"raspberrypi3-64\""


cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

cat conf/local.conf | grep "${LICENCE}" > /dev/null
local_license_info=$?


if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf
	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi




# place rm_work into conf file
RMWORK="INHERIT += \"rm_work\""
cat conf/local.conf | grep "${RMWORK}" > /dev/null
local_rm_info=$?

if [ $local_rm_info -ne 0 ];then
	echo "Append ${RMWORK} in the local.conf file"
	echo ${RMWORK} >> conf/local.conf
	
else
	echo "${RMWORK} already exists in the local.conf file"
fi


bitbake-layers show-layers | grep "meta-aesd" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-aesd layer"
	bitbake-layers add-layer ../meta-aesd
else
	echo "meta-aesd layer already exists"
fi

# the following was taken from https://github.com/swatikadivar/yocto-assignments-base.git example

LICENSE="LICENSE_FLAGS_WHITELIST = \"commercial\""

cat conf/local.conf | grep "${LICENCE}" > /dev/null
local_licn_info=$?

if [ $local_licn_info -ne 0 ];then
    echo "Append ${LICENCE} in the local.conf file"
	echo ${LICENCE} >> conf/local.conf
else
	echo "${LICENCE} already exists in the local.conf file"
fi


bitbake-layers show-layers | grep "meta-raspberrypi" > /dev/null
layer_info=$?

bitbake-layers show-layers | grep "meta-python" > /dev/null
layer_python_info=$?

bitbake-layers show-layers | grep "meta-oe" > /dev/null
layer_metaoe_info=$?

if [ $layer_metaoe_info -ne 0 ];then
    echo "Adding meta-oe layer"
	bitbake-layers add-layer ../meta-openembedded/meta-oe
else
	echo "layer meta-oe already exists"
fi


if [ $layer_python_info -ne 0 ];then
    echo "Adding meta-python layer"
	bitbake-layers add-layer ../meta-openembedded/meta-python
else
	echo "layer meta-python already exists"
fi

if [ $layer_info -ne 0 ];then
	echo "Adding meta-raspberrypi layer"
	bitbake-layers add-layer ../meta-raspberrypi
else
	echo "layer meta-raspberrypi already exists"
fi

## end of example code

set -e
bitbake core-image-aesd
