#!/bin/bash


#clone chaincode

if [ ! -d ./hlf-chaincode/ ]
then
	git clone https://github.com/upb-uc4/hlf-chaincode.git
else
	read -p "Update existing chaincode? " -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		pushd ./hlf-chaincode
		git pull
		popd
	fi
fi

echo "#############################################"
echo "#          chaincode up to date             #"
echo "#############################################"
