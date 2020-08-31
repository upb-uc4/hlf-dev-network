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

./fetch_chaincode.sh $BRANCH_TAG

#docker

CONTAINER_IDS=$(docker ps -a | awk '($2 ~ /fabric-peer.*/) {print $1}')
CONTAINER_IDS="$CONTAINER_IDS $(docker ps -a | awk '($2 ~ /fabric-couchdb.*/) {print $1}')"
CONTAINER_IDS="$CONTAINER_IDS $(docker ps -a | awk '($2 ~ /fabric-orderer.*/) {print $1}')"
CONTAINER_IDS="$CONTAINER_IDS $(docker ps -a | awk '($2 ~ /chaincode.*/) {print $1}')"
CONTAINER_IDS="$CONTAINER_IDS $(docker ps -a | awk '($2 ~ /fabric-tools.*/) {print $1}')"

docker rm $CONTAINER_IDS

docker-compose -f docker-compose-simple.yaml up
