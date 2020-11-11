#!/bin/bash

# read parameter
if [ -z "$1" ]
then
  # CHAINCODE_VERSION default version = 0.12.2
  echo "Installing chaincode from release v0.12.2"
  echo "Call script with parameter [version] to specify a different branch or tag."
  export CHAINCODE_VERSION="v0.12.2"
else
  # CHAINCODE_VERSION read from parameter
  export CHAINCODE_VERSION=$1
fi
echo "######################################################"
echo "Clone chaincode with version: $CHAINCODE_VERSION"
echo "######################################################"

# clone chaincode
./installChaincode.sh $CHAINCODE_VERSION

# Overwrite the channelFile and Genesis Block?
generate_channel_and_genesis () {
  echo "######################################################"
  echo "generate channelFile and Genesis block"
  echo "######################################################"
  # generate channelFile and Genesis block
  pushd scripts
  ./createChannelTx.sh
  popd
}
if [ ! -f ./myc.tx/ ]
then
  generate_channel_and_genesis
else 
  read -p "Overwrite the channelFile and Genesis Block (y/n)? " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]
	then
	  generate_channel_and_genesis
	fi
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
