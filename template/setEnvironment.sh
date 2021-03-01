#!/bin/bash
#  this project name is used in many of the object names for several of the cloudformation stacks
export PROJECT_NAME=jph-dms-kafka
#  staging bucket name to initially hold code uploaded from this github
export LOCAL_IP=`curl http://checkip.amazonaws.com/`
export CIDR="${LOCAL_IP}/32"
export KEY_NAME=jphaug
