#!/bin/bash


#clone chaincode

if [ ! -d ./hyperledger_chaincode/ ]
then
	git clone https://github.com/upb-uc4/hyperledger_chaincode.git
else
	read -p "Override existing chaincode? " -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		rm -rf hyperledger_chaincode
		git clone https://github.com/upb-uc4/hyperledger_chaincode.git
	fi
fi


#docker

CONTAINER_IDS=$(docker ps -a | awk '($2 ~ /fabric-peer.*/) {print $1}')
CONTAINER_IDS="$CONTAINER_IDS $(docker ps -a | awk '($2 ~ /fabric-couchdb.*/) {print $1}')"
CONTAINER_IDS="$CONTAINER_IDS $(docker ps -a | awk '($2 ~ /fabric-orderer.*/) {print $1}')"
CONTAINER_IDS="$CONTAINER_IDS $(docker ps -a | awk '($2 ~ /chaincode.*/) {print $1}')"
CONTAINER_IDS="$CONTAINER_IDS $(docker ps -a | awk '($2 ~ /fabric-tools.*/) {print $1}')"

docker rm $CONTAINER_IDS

docker-compose -f docker-compose-simple.yaml up
