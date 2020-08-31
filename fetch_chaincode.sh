#!/bin/bash


# BRANCH_TAG default branch = develop
export BRANCH_TAG=develop

# BRANCH_TAG read branch tag
if [ -z "$1" ]
then
  echo "Installing latest chaincode from develop."
  echo "Use './installChaincode.sh [branch|tag]' to specify another branch or tag."
else
  echo "Using branch / tag: $1"
  export BRANCH_TAG=$1
fi
echo ""


#clone chaincode

if [ ! -d ./hlf-chaincode/ ]
then
	git clone https://github.com/upb-uc4/hlf-chaincode.git
	pushd ./hlf-chaincode
	git checkout $BRANCH_TAG
	git pull
	popd
else
	read -p "Update existing chaincode? " -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		pushd ./hlf-chaincode
		git checkout $BRANCH_TAG
		git pull
		popd
	fi
fi

echo "#############################################"
echo "#          chaincode up to date             #"
echo "#############################################"
