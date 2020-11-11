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

echo "#############################################"
echo "chaincode ready"
echo "#############################################"
