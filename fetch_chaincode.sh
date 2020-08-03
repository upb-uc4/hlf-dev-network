#!/bin/bash


#clone chaincode

if [ ! -d ./hyperledger_chaincode/ ]
then
	git clone https://github.com/upb-uc4/hyperledger_chaincode.git
else
	read -p "Update existing chaincode? " -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		pushd ./hyperledger_chaincode
		git pull
		popd
	fi
fi

echo "#############################################"
echo "#          chaincode up to date             #"
echo "#############################################"
