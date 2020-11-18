#!/bin/bash

# read parameter
if [ -z "$1" ]
then
  # BRANCH_TAG default branch = develop
  echo "Installing latest chaincode from develop."
  echo "Use './installChaincode.sh [release]' to specify another version (e.g. v0.12.2) ."
  export CHAINCODE_VERSION_PATH="latest/download"
else
  # BRANCH_TAG read from parameter
  export CHAINCODE_VERSION_PATH="download/$1"
fi
echo "######################################################"
echo "Download chaincode from: $CHAINCODE_VERSION_PATH"
echo "######################################################"

# dowload chaincode
mkdir -p chaincode/assets
mkdir -p chaincode/UC4-chaincode
wget -q -c https://github.com/upb-uc4/hlf-chaincode/releases/"$CHAINCODE_VERSION_PATH"/UC4-chaincode.tar.gz -O - | tar -xz -C "./chaincode/UC4-chaincode"
echo "######################################################"
echo "Download assets"
echo "######################################################"
wget -q -c https://github.com/upb-uc4/hlf-chaincode/releases/"$CHAINCODE_VERSION_PATH"/collections_config_dev.json -O "./chaincode/assets/collections_config_dev.json"

echo "############################################################################################"
echo "READ CHAINCODE VERSION"
echo "############################################################################################"
jarPath=./chaincode/UC4-chaincode/UC4-chaincode/UC4-chaincode*.jar
unzip -c $jarPath META-INF/MANIFEST.MF | grep 'Implementation-Version' | cut -d ':' -f2 | tr -d ' ' | tr -d '\r' | tr -d '\n'>./chaincode/assets/testversion.txt
# add access rights to file for everyone
chmod 777 ./chaincode/assets/testversion.txt
export CHAINCODE_VERSION=$(cat ./chaincode/assets/testversion.txt)
echo "CHAINCODE VERSION:: $CHAINCODE_VERSION"

echo "#############################################"
echo "chaincode ready"
echo "#############################################"
