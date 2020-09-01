#!/bin/bash

# read parameter
if [ -z "$1" ]
then
  # BRANCH_TAG default branch = develop
  echo "Installing latest chaincode from develop."
  echo "Use './installChaincode.sh [branch|tag]' to specify another branch or tag."
  export BRANCH_TAG=develop
else
  # BRANCH_TAG read from parameter
  export BRANCH_TAG=$1
fi
echo "######################################################"
echo "#   Clone chaincode with branch / tag: $BRANCH_TAG   #"
echo "######################################################"


# clone chaincode
if [ ! -d ./hlf-chaincode/ ]
then
	git clone https://github.com/upb-uc4/hlf-chaincode.git
	pushd ./hlf-chaincode
	git checkout $BRANCH_TAG
	git pull
	popd
else
	read -p "Overwrite existing chaincode (y/n)? " -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		pushd ./hlf-chaincode
		git checkout $BRANCH_TAG
		git pull
		popd
	fi
fi

echo "#############################################"
echo "#             chaincode ready               #"
echo "#############################################"
