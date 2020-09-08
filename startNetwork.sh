#!/bin/bash

# read parameter
if [ -z "$1" ]
then
  # BRANCH_TAG default branch = develop
  echo "Installing latest chaincode from develop."
  echo "Call script with parameter [branch|tag] to specify a different branch or tag."
  export BRANCH_TAG=develop
else
  # BRANCH_TAG read from parameter
  export BRANCH_TAG=$1
fi
echo "######################################################"
echo "#   Clone chaincode with branch / tag: $BRANCH_TAG   #"
echo "######################################################"

# clone chaincode with 
./installChaincode.sh $BRANCH_TAG

# recreate the channelFile and Genesis Block?
read -p "Recreate the channelFile and Genesis Block (y/n)? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "######################################################"
  echo "#       generate channelFile and Genesis block       #"
  echo "######################################################"
  # generate channelFile and Genesis block
  pushd scripts
  ./createChannelTx.sh
  popd
fi


# ######## DOCKER ######## #
# gather Docker Ids for hyperledger-fabric
CONTAINER_IDS=$(docker ps -a | awk '($2 ~ /fabric-peer.*/) {print $1}')
CONTAINER_IDS="$CONTAINER_IDS $(docker ps -a | awk '($2 ~ /fabric-couchdb.*/) {print $1}')"
CONTAINER_IDS="$CONTAINER_IDS $(docker ps -a | awk '($2 ~ /fabric-orderer.*/) {print $1}')"
CONTAINER_IDS="$CONTAINER_IDS $(docker ps -a | awk '($2 ~ /chaincode.*/) {print $1}')"
CONTAINER_IDS="$CONTAINER_IDS $(docker ps -a | awk '($2 ~ /fabric-tools.*/) {print $1}')"
# remove existing containers
docker rm $CONTAINER_IDS
# start docker-environment
docker-compose -f docker-compose-simple.yaml up
